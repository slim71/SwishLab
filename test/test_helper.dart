import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swish_lab/router/central_routing.dart';
import 'package:swish_lab/services/authentication.dart';
import 'package:swish_lab/repositories/users_repository.dart';
import 'package:swish_lab/repositories/statistics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: implementation_imports
import 'package:riverpod/src/framework.dart' show Override;

class MockGoRouter extends Mock implements GoRouter {
  MockGoRouter() {
    when(() => pushNamed(any(),
        pathParameters: any(named: 'pathParameters'),
        queryParameters: any(named: 'queryParameters'),
        extra: any(named: 'extra'))).thenAnswer((_) async => null);
    when(() => push(any(), extra: any(named: 'extra'))).thenAnswer((_) async => null);
    when(() => go(any(), extra: any(named: 'extra'))).thenReturn(null);
    when(() => goNamed(any(),
        pathParameters: any(named: 'pathParameters'),
        queryParameters: any(named: 'queryParameters'),
        extra: any(named: 'extra'))).thenReturn(null);
    when(() => pop(any())).thenReturn(null);
  }

  @override
  bool canPop() => true;
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

class MockUsersRepository extends Mock implements UsersRepository {}

class MockStatisticsRepository extends Mock implements StatisticsRepository {}

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyHttpOverrides extends TestHttpOverrides {}

/// A testing utility which creates a [ProviderContainer] and automatically disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );
  addTearDown(container.dispose);
  return container;
}

Widget createTestWidget({
  required Widget child,
  List<Override> overrides = const [],
  GoRouter? router,
}) {
  final goRouter = router ??
      GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(body: child),
          ),
          GoRoute(
              path: '/pre-upload/:perspective',
              name: 'pre-upload',
              builder: (_, __) => const Scaffold(body: Text('Pre-Upload Page'))),
          GoRoute(path: '/pic', name: 'pic', builder: (_, __) => const Scaffold(body: Text('Pic Page'))),
          GoRoute(path: '/user', name: 'user', builder: (_, __) => const Scaffold(body: Text('User Page'))),
          GoRoute(path: '/home', name: 'home', builder: (_, __) => const Scaffold(body: Text('Home Page'))),
          GoRoute(path: '/results', name: 'results', builder: (_, __) => const Scaffold(body: Text('Results Page'))),
          GoRoute(path: '/success', name: 'success', builder: (_, __) => const Scaffold(body: Text('Success Page'))),
          GoRoute(
              path: '/theme-test',
              name: 'theme-test',
              builder: (_, __) => const Scaffold(body: Text('Theme Test Page'))),
          GoRoute(path: '/signup', name: 'signup', builder: (_, __) => const Scaffold(body: Text('Signup Page'))),
        ],
      );

  return ProviderScope(
    overrides: [
      routerProvider.overrideWithValue(goRouter),
      ...overrides,
    ],
    child: MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      routerConfig: (goRouter is Mock)
          ? GoRouter(routes: [
              GoRoute(path: '/', builder: (context, state) => Scaffold(body: child)),
              GoRoute(
                  path: '/pre-upload/:perspective',
                  name: 'pre-upload',
                  builder: (_, __) => const Scaffold(body: Text('Pre-Upload Page'))),
              GoRoute(path: '/pic', name: 'pic', builder: (_, __) => const Scaffold(body: Text('Pic Page'))),
              GoRoute(path: '/user', name: 'user', builder: (_, __) => const Scaffold(body: Text('User Page'))),
              GoRoute(path: '/home', name: 'home', builder: (_, __) => const Scaffold(body: Text('Home Page'))),
              GoRoute(
                  path: '/results', name: 'results', builder: (_, __) => const Scaffold(body: Text('Results Page'))),
              GoRoute(
                  path: '/success', name: 'success', builder: (_, __) => const Scaffold(body: Text('Success Page'))),
              GoRoute(
                  path: '/theme-test',
                  name: 'theme-test',
                  builder: (_, __) => const Scaffold(body: Text('Theme Test Page'))),
              GoRoute(path: '/signup', name: 'signup', builder: (_, __) => const Scaffold(body: Text('Signup Page'))),
            ])
          : goRouter,
    ),
  );
}
