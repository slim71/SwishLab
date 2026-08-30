import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/pages/login.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../test_helper.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockUser mockUser;

  setUpAll(() {
    Animate.restartOnHotReload = true;
    registerFallbackValue(FakeAuthException());
  });

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();

    registerFallbackValue(mockUser);
    when(() => mockUser.email).thenReturn('test@example.com');
  });

  group('LoginPage', () {
    testWidgets('shows validation errors for empty fields',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('Password required'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'invalid-email');
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('successful login navigates to root',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockAuthService.signInWithEmail(any(), any()))
          .thenAnswer((_) async => mockUser);

      final router = GoRouter(routes: [
        GoRoute(
            path: '/', builder: (_, __) => const Scaffold(body: Text('Home'))),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ]);

      await tester.pumpWidget(createTestWidget(
        router: router,
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const SizedBox(),
      ));

      router.go('/login');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');

      await tester.tap(find.text('Log In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('shows snackbar on failed login (null user)',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockAuthService.signInWithEmail(any(), any()))
          .thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'wrong');

      await tester.tap(find.text('Log In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Login failed'), findsOneWidget);
    });

    testWidgets('shows snackbar on AuthException', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockAuthService.signInWithEmail(any(), any()))
          .thenThrow(const AuthException('Invalid credentials'));

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'wrong');

      await tester.tap(find.text('Log In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('shows snackbar on generic Exception',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockAuthService.signInWithEmail(any(), any()))
          .thenThrow(Exception('Unknown error'));

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'any');

      await tester.tap(find.text('Log In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Unexpected error occurred'), findsOneWidget);
    });

    testWidgets('Google Sign In navigates home', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      when(() => mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => mockUser);

      final router = GoRouter(routes: [
        GoRoute(
            path: '/', builder: (_, __) => const Scaffold(body: Text('Root'))),
        GoRoute(
            path: '/home',
            name: 'home',
            builder: (_, __) => const Scaffold(body: Text('Home'))),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ]);

      await tester.pumpWidget(createTestWidget(
        router: router,
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const SizedBox(),
      ));

      router.go('/login');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue with Google'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Navigates to Sign Up', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      final router = GoRouter(routes: [
        GoRoute(
            path: '/', builder: (_, __) => const Scaffold(body: Text('Root'))),
        GoRoute(
            path: '/signup',
            name: 'signup',
            builder: (_, __) => const Scaffold(body: Text('Signup'))),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ]);

      await tester.pumpWidget(createTestWidget(
        router: router,
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const SizedBox(),
      ));

      router.go('/login');
      await tester.pumpAndSettle();

      final signUpText = find.textContaining('Sign Up', findRichText: true);
      await tester.ensureVisible(signUpText);
      await tester.tap(signUpText);
      await tester.pumpAndSettle();

      expect(find.text('Signup'), findsOneWidget);
    });

    testWidgets('unfocuses on background tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
      ));
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.tap(emailField);
      await tester.pump();

      final FocusNode node = FocusManager.instance.primaryFocus!;
      expect(node.hasFocus, isTrue);

      // Tap background (Logo area or title)
      await tester.tap(find.text('Welcome Back'));
      await tester.pump();

      expect(node.hasFocus, isFalse);
    });

    testWidgets('handles disposal during login process (context.mounted)',
        (tester) async {
      final loginCompleter = Completer<User?>();
      when(() => mockAuthService.signInWithEmail(any(), any()))
          .thenAnswer((_) => loginCompleter.future);

      await tester.pumpWidget(createTestWidget(
        child: const LoginPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');

      await tester.tap(find.text('Log In'));
      await tester.pump(); // Start process

      // Dispose the widget tree before completing the future
      await tester.pumpWidget(const SizedBox());

      loginCompleter.complete(mockUser);
      await tester.pump();
      // Should not crash and should return early due to !context.mounted
    });
  });
}

class FakeAuthException extends Fake implements AuthException {
  @override
  String get message => 'Invalid credentials';
}
