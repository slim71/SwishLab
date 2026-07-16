import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/router_refresh_notifier.dart';
import '../logger.dart';
import '../models/custom_enums.dart';
import '../pages/about.dart';
import '../pages/analysis_results.dart';
import '../pages/credits.dart';
import '../pages/debug_utilities.dart';
import '../pages/error_page.dart';
import '../pages/front_details.dart';
import '../pages/getting_started.dart';
import '../pages/help.dart';
import '../pages/home_page.dart';
import '../pages/loading_page.dart';
import '../pages/login.dart';
import '../pages/markdown_document.dart';
import '../pages/past_activity.dart';
import '../pages/processing_video.dart';
import '../pages/profile_page.dart';
import '../pages/profile_picture.dart';
import '../pages/settings.dart';
import '../pages/side_details.dart';
import '../pages/signup.dart';
import '../pages/splash_screen.dart';
import '../pages/success.dart';
import '../pages/user_data.dart';
import '../pages/video_pre_upload.dart';
import '../providers/auth_providers.dart';
import '../state/app_state.dart';
import '../widgets/nav_bar_scaffold.dart';
import 'app_documents.dart';
import 'app_transitions.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final routingLogger = AppLogger.scope('Router');

// Basically all app's navigation routes
final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    observers: [_RouterObserver()],
    redirect: (context, state) {
      final status = ref.read(appStatusProvider);
      final location = state.matchedLocation;

      // Public routes that should always be accessible
      const publicRoutes = ['/splash', '/login', '/signup'];

      if (publicRoutes.contains(location)) {
        return null;
      }

      switch (status) {
        case AppAuthStatus.loading:
          // Stay on root loading or explicit loading page
          if (location == '/' || location == '/loading') return null;
          return '/loading';

        case AppAuthStatus.offline:
          // Stay where we are on network blips, don't force logout
          return null;

        case AppAuthStatus.unauthenticated:
          return location == '/splash' ? null : '/splash';

        case AppAuthStatus.authenticated:
          if (location == '/' || location == '/loading') {
            final hasOpened = ref.read(appStateProvider).hasOpenedBefore;
            if (!hasOpened) {
              return '/settings/getting-started';
            }
            return '/home';
          }
          return null;
      }
    },
    errorBuilder: (context, state) {
      final error = state.error;
      routingLogger.e('Routing error on ${state.uri}', error: error, stackTrace: StackTrace.current);
      return ErrorPage(message: error?.toString(), onHome: () => context.go('/'));
    },
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const NavBarScaffold(child: HomePage()),
      ),
      GoRoute(
        path: '/activity',
        name: 'activity',
        builder: (context, state) => const NavBarScaffold(child: PastActivity()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const NavBarScaffold(child: ProfilePage()),
      ),
      GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const NavBarScaffold(child: Settings()),
          routes: [
            GoRoute(
              path: 'about',
              name: 'about',
              builder: (context, state) => const AboutUs(),
            ),
            GoRoute(
              path: 'help',
              name: 'help',
              builder: (context, state) => const HelpPage(),
            ),
            GoRoute(
              path: 'debug',
              name: 'debug',
              builder: (context, state) => const DebugUtilities(),
            ),
            GoRoute(
              path: 'user',
              name: 'user',
              builder: (context, state) => const UserData(),
            ),
            GoRoute(
              path: 'getting-started',
              name: 'getting-started',
              builder: (context, state) => const GettingStartedPage(),
            ),
            GoRoute(
              path: 'credits',
              name: 'credits',
              builder: (context, state) => const Credits(),
            ),
            GoRoute(
              path: '/doc/:name',
              name: 'document',
              builder: (context, state) {
                final name = state.pathParameters['name']!;
                final doc = appDocuments[name]!;
                return MarkdownDocument(
                  fileName: doc.file,
                  title: doc.title,
                );
              },
            ),
          ]),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) {
          return buildTransitionPage(
            state: state,
            child: const LoginPage(),
            transition: AppTransition.bottomToTop,
            duration: const Duration(milliseconds: 300),
          );
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) {
          return buildTransitionPage(
            state: state,
            child: const SignupPage(),
            transition: AppTransition.bottomToTop,
            duration: const Duration(milliseconds: 300),
          );
        },
      ),
      GoRoute(
        path: '/success',
        name: 'success',
        builder: (context, state) => const SuccessAfterSignup(),
      ),
      GoRoute(
        path: '/side',
        name: 'side',
        builder: (context, state) => const SideDetails(),
      ),
      GoRoute(
        path: '/front',
        name: 'front',
        builder: (context, state) => const FrontDetails(),
      ),
      GoRoute(
        path: '/results',
        name: 'results',
        builder: (context, state) {
          final videoDataJson = state.extra as Map<String, dynamic>;
          return AnalysisResults(videoDataJson: videoDataJson);
        },
      ),
      GoRoute(
        path: '/pic',
        name: 'pic',
        builder: (context, state) => const ProfilePicturePage(),
      ),
      GoRoute(
        name: 'pre-upload',
        path: '/pre-upload',
        builder: (context, state) {
          final extra = state.extra;

          // Defensive guard
          if (extra is! Map<String, dynamic>) {
            return const SizedBox.shrink();
          }

          final originFunc = extra['originFunc'] as OriginFunc;
          final File videoFile = extra['videoFile'] as File;

          return VideoPreUpload(
            perspective: originFunc,
            videoFile: videoFile,
          );
        },
      ),
      GoRoute(
        path: '/processing',
        name: 'processing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ProcessingVideo(
            videoFile: extra['videoFile'] as File,
            shootingHand: extra['shootingHand'] as String,
            pointOfView: extra['pointOfView'] as String,
          );
        },
      ),
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const LoadingPage(),
      ),
    ],
  );
});

class _RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routingLogger.i('PUSH -> ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routingLogger.i('POP ← ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    routingLogger.i('REPLACE ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
