import 'package:SwishLab/pages/home_page.dart';
import 'package:SwishLab/pages/login.dart';
import 'package:SwishLab/pages/past_activity.dart';
import 'package:SwishLab/pages/profile_page.dart';
import 'package:SwishLab/pages/settings.dart';
import 'package:SwishLab/pages/signup.dart';
import 'package:SwishLab/pages/splash_screen.dart';
import 'package:SwishLab/providers/auth_providers.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/router/go_router_refresh_stream.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/themes.dart';
import 'package:SwishLab/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Expose the app title globally through this one provider
final appTitleProvider = Provider((_) => 'SwishLab');

// Basically all app's navigation routes
final _routerProvider = Provider<GoRouter>((ref) {
  final supabase = Supabase.instance.client;

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return NavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/activity',
            name: 'activity',
            builder: (context, state) => const PastActivity(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (_, __) => const Settings(),
          ),
        ],
      ),
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
    ],
    redirect: (context, state) {
      final loggedIn = ref.read(loggedInProvider);
      final location = state.matchedLocation;

      // If logged in -> redirect to home
      if (loggedIn && (location == '/splash' || location == '/login')) {
        return '/home';
      }

      // No redirect
      return null;
    },
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
      // Light theme
      darkTheme: buildTheme(theBay, Brightness.dark),
      // Dark theme
      themeMode: ThemeMode.system, // Auto-switch based on device
    );
  }
}
