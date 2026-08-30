import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:swish_lab/widgets/nav_bar.dart';
import 'package:swish_lab/router/central_routing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('NavBar highlights correct item based on location', (WidgetTester tester) async {
    final routes = ['/home', '/activity', '/profile', '/settings'];
    final expectedIndices = [0, 1, 2, 3];

    for (int i = 0; i < routes.length; i++) {
      final router = GoRouter(
        initialLocation: routes[i],
        routes: [
          ShellRoute(
            builder: (context, state, child) => NavBar(child: child),
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home Page'))),
              GoRoute(path: '/activity', builder: (_, __) => const Scaffold(body: Text('Activity Page'))),
              GoRoute(path: '/profile', builder: (_, __) => const Scaffold(body: Text('Profile Page'))),
              GoRoute(path: '/settings', builder: (_, __) => const Scaffold(body: Text('Settings Page'))),
            ],
          ),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(router),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ));
      await tester.pumpAndSettle();

      final navBarView = tester.widget<NavBarView>(find.byType(NavBarView));
      expect(navBarView.currentIndex, expectedIndices[i], reason: 'Failed for route ${routes[i]}');
    }
  });

  testWidgets('NavBar navigates to correct route on tap', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) => NavBar(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home Page'))),
            GoRoute(path: '/activity', builder: (_, __) => const Scaffold(body: Text('Activity Page'))),
            GoRoute(path: '/profile', builder: (_, __) => const Scaffold(body: Text('Profile Page'))),
            GoRoute(path: '/settings', builder: (_, __) => const Scaffold(body: Text('Settings Page'))),
          ],
        ),
      ],
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [
        routerProvider.overrideWithValue(router),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/activity');

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/profile');

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/settings');

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/home');
  });
}
