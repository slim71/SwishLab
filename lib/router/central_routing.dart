import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swish_lab/controllers/router_refresh_notifier.dart';
import 'package:swish_lab/logger.dart';
import 'package:swish_lab/models/custom_enums.dart';
import 'package:swish_lab/pages/about.dart';
import 'package:swish_lab/pages/analysis_results.dart';
import 'package:swish_lab/pages/credits.dart';
import 'package:swish_lab/pages/debug_utilities.dart';
import 'package:swish_lab/pages/error_page.dart';
import 'package:swish_lab/pages/front_details.dart';
import 'package:swish_lab/pages/getting_started.dart';
import 'package:swish_lab/pages/help.dart';
import 'package:swish_lab/pages/home_page.dart';
import 'package:swish_lab/pages/loading_page.dart';
import 'package:swish_lab/pages/login.dart';
import 'package:swish_lab/pages/markdown_document.dart';
import 'package:swish_lab/pages/past_activity.dart';
import 'package:swish_lab/pages/processing_video.dart';
import 'package:swish_lab/pages/profile_page.dart';
import 'package:swish_lab/pages/profile_picture.dart';
import 'package:swish_lab/pages/settings.dart';
import 'package:swish_lab/pages/side_details.dart';
import 'package:swish_lab/pages/signup.dart';
import 'package:swish_lab/pages/splash_screen.dart';
import 'package:swish_lab/pages/success.dart';
import 'package:swish_lab/pages/user_data.dart';
import 'package:swish_lab/pages/video_pre_upload.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/router/app_documents.dart';
import 'package:swish_lab/router/app_transitions.dart';
import 'package:swish_lab/widgets/nav_bar_scaffold.dart';

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

      debugPrint('\t\t going to $location');

      // Public routes that should always be accessible
      const publicRoutes = ['/splash', '/login', '/signup'];

      if (publicRoutes.contains(location)) {
        return null;
      }

      switch (status) {
        case AppAuthStatus.loading:
          debugPrint('\t\t loading');
          return location == '/loading' ? null : '/loading';

        case AppAuthStatus.offline:
          debugPrint('\t\t offline');
          return location == '/splash' ? null : '/splash';

        case AppAuthStatus.unauthenticated:
          debugPrint('\t\t unauthenticated');
          return location == '/splash' ? null : '/splash';

        case AppAuthStatus.authenticated:
          debugPrint('\t\t authenticated');
          if (location == '/' || location == '/loading') {
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
        builder: (context, state) => NavBarScaffold(child: HomePage()),
      ),
      GoRoute(
        path: '/activity',
        name: 'activity',
        builder: (context, state) => NavBarScaffold(child: PastActivity()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => NavBarScaffold(child: ProfilePage()),
      ),
      GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => NavBarScaffold(child: Settings()),
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
        builder: (context, state) => const ProcessingVideo(),
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
  void didPush(Route route, Route? previousRoute) {
    routingLogger.i('PUSH -> ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    routingLogger.i('POP ← ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routingLogger.i('REPLACE ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}