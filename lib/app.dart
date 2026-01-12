import 'package:SwishLab/pages/about.dart';
import 'package:SwishLab/pages/analysis_results.dart';
import 'package:SwishLab/pages/debug_utilities.dart';
import 'package:SwishLab/pages/error_page.dart';
import 'package:SwishLab/pages/help.dart';
import 'package:SwishLab/pages/home_page.dart';
import 'package:SwishLab/pages/login.dart';
import 'package:SwishLab/pages/markdown_document.dart';
import 'package:SwishLab/pages/past_activity.dart';
import 'package:SwishLab/pages/profile_page.dart';
import 'package:SwishLab/pages/settings.dart';
import 'package:SwishLab/pages/signup.dart';
import 'package:SwishLab/pages/splash_screen.dart';
import 'package:SwishLab/pages/success.dart';
import 'package:SwishLab/pages/front_details.dart';
import 'package:SwishLab/providers/auth_providers.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/router/app_documents.dart';
import 'package:SwishLab/router/go_router_refresh_stream.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/themes.dart';
import 'package:SwishLab/widgets/nav_bar_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Expose the app title globally through this one provider
final appTitleProvider = Provider((_) => 'SwishLab');
final rootNavigatorKey = GlobalKey<NavigatorState>();

// Basically all app's navigation routes
final _routerProvider = Provider<GoRouter>((ref) {
  final supabase = Supabase.instance.client;

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
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/success',
        name: 'success',
        builder: (context, state) => const SuccessAfterSignup(),
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
    ],
  );
});

// Root widget of the app
class SwishLab extends ConsumerWidget {
  const SwishLab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            final existing = await usersRepo.getSingleUserById(user.id);

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
      theme: buildTheme(theBay, Brightness.light),
      darkTheme: buildTheme(theBay, Brightness.dark),
      themeMode: ThemeMode.system, // Auto-switch based on device
    );
  }
}
