import 'package:SwishLab/pages/home_page.dart';
import 'package:SwishLab/pages/past_activity.dart';
import 'package:SwishLab/pages/profile_page.dart';
import 'package:SwishLab/pages/settings.dart';
import 'package:SwishLab/pages/splash_screen.dart';
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
    ],
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final loggedIn = session != null;
      final location = state.matchedLocation;
      final isSplash = location == '/splash';
      final isLogin = location == '/login';
      final isSignup = location == '/signup';

      // If logged in -> redirect to home
      if ((isSplash || isLogin || isSignup) && loggedIn) {
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
