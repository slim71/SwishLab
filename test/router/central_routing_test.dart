import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/error_page.dart';
import 'package:swish_lab/pages/home_page.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/router/central_routing.dart';
import 'package:swish_lab/state/app_state.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
  });

  group('rootRedirect', () {
    test('redirects to /loading when status is loading and not on / or /loading', () {
      final result = rootRedirect(AppAuthStatus.loading, '/home', false);
      expect(result, '/loading');
    });

    test('returns null when status is loading and on /', () {
      final result = rootRedirect(AppAuthStatus.loading, '/', false);
      expect(result, null);
    });

    test('returns null when status is loading and on /loading', () {
      final result = rootRedirect(AppAuthStatus.loading, '/loading', false);
      expect(result, null);
    });

    test('redirects to /splash when unauthenticated and on private route', () {
      final result = rootRedirect(AppAuthStatus.unauthenticated, '/home', false);
      expect(result, '/splash');
    });

    test('allows public routes when unauthenticated', () {
      const routes = ['/splash', '/login', '/signup'];
      for (final route in routes) {
        final result = rootRedirect(AppAuthStatus.unauthenticated, route, false);
        expect(result, null, reason: 'Failed for route $route');
      }
    });

    test('redirects to /splash when unauthenticated and on /loading', () {
      final result = rootRedirect(AppAuthStatus.unauthenticated, '/loading', false);
      expect(result, '/splash');
    });

    test('redirects to /home when authenticated and hasOpenedBefore is true', () {
      final routes = ['/login', '/', '/loading', '/splash'];
      for (final route in routes) {
        final result = rootRedirect(AppAuthStatus.authenticated, route, true);
        expect(result, '/home', reason: 'Failed for route $route');
      }
    });

    test('redirects to /settings/getting-started when authenticated and hasOpenedBefore is false', () {
      final routes = ['/splash', '/', '/loading'];
      for (final route in routes) {
        final result = rootRedirect(AppAuthStatus.authenticated, route, false);
        expect(result, '/settings/getting-started', reason: 'Failed for route $route');
      }
    });

    test('returns null when authenticated and on private route', () {
      final result = rootRedirect(AppAuthStatus.authenticated, '/home', true);
      expect(result, null);
    });

    test('returns null when authenticated and on other page', () {
      final result = rootRedirect(AppAuthStatus.authenticated, '/settings', true);
      expect(result, null);
    });

    test('returns null when offline', () {
      final result = rootRedirect(AppAuthStatus.offline, '/home', true);
      expect(result, null);
      final result2 = rootRedirect(AppAuthStatus.offline, '/splash', false);
      expect(result2, null);
    });

    test('exhaustive authenticated redirects', () {
      expect(rootRedirect(AppAuthStatus.authenticated, '/profile', true), null);
      expect(rootRedirect(AppAuthStatus.authenticated, '/profile', false), null);
      expect(rootRedirect(AppAuthStatus.authenticated, '/splash', true), '/home');
      expect(rootRedirect(AppAuthStatus.authenticated, '/splash', false), '/settings/getting-started');
      expect(rootRedirect(AppAuthStatus.authenticated, '/loading', true), '/home');
    });
  });

  testWidgets('error builder onHome works', (tester) async {
    final container = ProviderContainer(
      overrides: [
        appStatusProvider.overrideWithValue(AppAuthStatus.authenticated),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
      ],
    );

    final router = container.read(routerProvider);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));

    router.go('/non-existent-route-force-error');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ErrorPage), findsOneWidget);
    await tester.tap(find.text('Go Home'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('document route builder works', (tester) async {
    final container = ProviderContainer(
      overrides: [
        appStatusProvider.overrideWithValue(AppAuthStatus.authenticated),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
      ],
    );

    final router = container.read(routerProvider);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));

    router.go('/settings/doc/EULA');
    await tester.pumpAndSettle();
    expect(find.text('End User License Agreement'), findsOneWidget);

    router.go('/settings/doc/PRIVACY');
    await tester.pumpAndSettle();
    expect(find.text('Privacy Policy'), findsOneWidget);
  });
}
