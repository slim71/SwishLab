import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/router/app_documents.dart';
import 'package:swish_lab/router/app_transitions.dart';
import 'package:swish_lab/router/go_router_refresh_stream.dart';
import 'package:swish_lab/styles/colors.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/styles/themes.dart';
import 'package:swish_lab/widgets/nav_bar_scaffold.dart';

// Expose the app title globally through this one provider
final appTitleProvider = Provider((_) => 'SwishLab');
final rootNavigatorKey = GlobalKey<NavigatorState>();

// Basically all app's navigation routes
final _routerProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),
    errorBuilder: (context, state) {
      final error = state.error;

      return ErrorPage(
        message: error?.toString(),
        onHome: () => context.go('/'),
      );
    },
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        builder: (context, state) {
          // Render nothing while deciding
          return const SizedBox.shrink();
        },
        redirect: (context, state) {
          final loggedInAsync = ref.watch(persistedLoggedInProvider);

          return loggedInAsync.maybeWhen(
            data: (isLoggedIn) => isLoggedIn ? '/home' : '/splash',
            orElse: () => null, // wait until loaded
          );
        },
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
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const LoadingPage(),
      ),
    ],
  );
});

// Root widget of the app
class SwishLab extends ConsumerStatefulWidget {
  const SwishLab({super.key});

  @override
  ConsumerState<SwishLab> createState() => _SwishLabState();
}

class _SwishLabState extends ConsumerState<SwishLab> {
  AppColorSet currentColors = theBay;
  Brightness brightness = Brightness.light;

  void updateTheme(AppColorSet newColors, Brightness newBrightness) {
    setState(() {
      currentColors = newColors;
      brightness = newBrightness;
      AppThemeManager.setColors(newColors);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(_routerProvider);
    final title = ref.watch(appTitleProvider);

    // Listener to add the user to the DB
    ref.listen<AsyncValue<AuthState>>(
      authStateProvider,
      (previous, next) {
        next.when(
          data: (authState) async {
            final user = authState.session?.user;
            if (user == null) return;

            final usersRepo = ref.read(usersRepositoryProvider);

            // Only insert if the user does not exist
            final existing = await usersRepo.getUserRow(user.id);

            if (existing == null) {
              await usersRepo.insertUser(
                id: user.id,
                email: user.email ?? '',
                firstName: '',
                lastName: '',
              );
            }
          },
          loading: () {},
          error: (_, __) {},
        );
      },
    );

    return MaterialApp.router(
      title: title,
      routerConfig: router,
      theme: buildTheme(),
      darkTheme: buildTheme(),
      themeMode: ThemeMode.system, // Auto-switch based on device
    );
  }
}
