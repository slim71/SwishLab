import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/app.dart';
import 'package:swish_lab/providers/debug_provider.dart';
import 'package:swish_lab/providers/session.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/repositories/users_repository.dart';
import 'package:swish_lab/router/central_routing.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Session, User;

class MockUsersRepository extends Mock implements UsersRepository {}

class MockSession extends Mock implements Session {}

class MockUser extends Mock implements User {}

void main() {
  late MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    AppThemeManager.reset();
  });

  GoRouter createRouter() => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Home')),
          ),
        ],
      );

  testWidgets('SwishLab renders MaterialApp and handles all provider overrides', (tester) async {
    final router = createRouter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(router),
          debugProvider.overrideWith(() => DebugNotifier()),
          supabaseAuthListenerProvider.overrideWithValue(null),
          sessionBootstrapProvider.overrideWithValue(null),
          verifiedSessionProvider.overrideWithValue(const AsyncData(null)),
          usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          appTitleProvider.overrideWithValue('SwishLab Test'),
        ],
        child: const SwishLab(),
      ),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'SwishLab Test');
    expect(find.text('Home'), findsOneWidget);
  });

  group('ThemeMode tests', () {
    testWidgets('SwishLab uses ThemeMode.light when brightness is light', (tester) async {
      AppThemeManager.setBrightness(AppBrightness.light);
      final router = createRouter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWithValue(const AsyncData(null)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
    });

    testWidgets('SwishLab uses ThemeMode.dark when brightness is dark', (tester) async {
      AppThemeManager.setBrightness(AppBrightness.dark);
      final router = createRouter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWithValue(const AsyncData(null)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
    });

    testWidgets('SwishLab uses ThemeMode.system when brightness is system', (tester) async {
      AppThemeManager.setBrightness(AppBrightness.system);
      final router = createRouter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWithValue(const AsyncData(null)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.system);
    });
  });

  testWidgets('SwishLab shows performance overlay when debug state is enabled', (tester) async {
    final router = createRouter();
    final debugNotifier = DebugNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(router),
          debugProvider.overrideWith(() => debugNotifier),
          supabaseAuthListenerProvider.overrideWithValue(null),
          sessionBootstrapProvider.overrideWithValue(null),
          verifiedSessionProvider.overrideWithValue(const AsyncData(null)),
          usersRepositoryProvider.overrideWithValue(mockUsersRepository),
        ],
        child: const SwishLab(),
      ),
    );
    await tester.pump();

    debugNotifier.togglePerformanceOverlay();
    await tester.pump();

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.showPerformanceOverlay, isTrue);
  });

  group('Session Listener tests', () {
    testWidgets('SwishLab session listener handles new session and inserts user if missing', (tester) async {
      final router = createRouter();
      final mockSession = MockSession();
      final mockUser = MockUser();
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockUser.email).thenReturn('test@example.com');

      when(() => mockUsersRepository.getUserRow(any())).thenAnswer((_) async => null);
      when(() => mockUsersRepository.insertUser(
            id: any(named: 'id'),
            email: any(named: 'email'),
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
          )).thenAnswer((_) async {});

      final sessionStateProvider = StateProvider<Session?>((ref) => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWith((ref) => ref.watch(sessionStateProvider)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(SwishLab)));
      container.read(sessionStateProvider.notifier).state = mockSession;

      await tester.pump();
      await tester.pump(Duration.zero);

      verify(() => mockUsersRepository.getUserRow('test-user-id')).called(1);
      verify(() => mockUsersRepository.insertUser(
            id: 'test-user-id',
            email: 'test@example.com',
            firstName: '',
            lastName: '',
          )).called(1);
    });

    testWidgets('SwishLab session listener does not insert user if already exists', (tester) async {
      final router = createRouter();
      final mockSession = MockSession();
      final mockUser = MockUser();
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockUser.email).thenReturn('test@example.com');

      when(() => mockUsersRepository.getUserRow(any())).thenAnswer((_) async => const UsersRow(
            id: 'test-user-id',
            firstName: '',
            lastName: '',
            email: 'test@example.com',
          ));

      final sessionStateProvider = StateProvider<Session?>((ref) => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWith((ref) => ref.watch(sessionStateProvider)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(SwishLab)));
      container.read(sessionStateProvider.notifier).state = mockSession;

      await tester.pump();
      await tester.pump(Duration.zero);

      verify(() => mockUsersRepository.getUserRow('test-user-id')).called(1);
      verifyNever(() => mockUsersRepository.insertUser(
            id: any(named: 'id'),
            email: any(named: 'email'),
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
          ));
    });

    testWidgets('SwishLab session listener handles null email by using empty string', (tester) async {
      final router = createRouter();
      final mockSession = MockSession();
      final mockUser = MockUser();
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockUser.email).thenReturn(null);

      when(() => mockUsersRepository.getUserRow(any())).thenAnswer((_) async => null);
      when(() => mockUsersRepository.insertUser(
            id: any(named: 'id'),
            email: any(named: 'email'),
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
          )).thenAnswer((_) async {});

      final sessionStateProvider = StateProvider<Session?>((ref) => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWith((ref) => ref.watch(sessionStateProvider)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(SwishLab)));
      container.read(sessionStateProvider.notifier).state = mockSession;

      await tester.pump();
      await tester.pump(Duration.zero);

      verify(() => mockUsersRepository.insertUser(
            id: 'test-user-id',
            email: '',
            firstName: '',
            lastName: '',
          )).called(1);
    });

    testWidgets('SwishLab session listener catches and ignores errors during user sync', (tester) async {
      final router = createRouter();
      final mockSession = MockSession();
      final mockUser = MockUser();
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockUser.email).thenReturn('test@example.com');

      when(() => mockUsersRepository.getUserRow(any())).thenThrow(Exception('DB Error'));

      final sessionStateProvider = StateProvider<Session?>((ref) => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWith((ref) => ref.watch(sessionStateProvider)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(SwishLab)));
      container.read(sessionStateProvider.notifier).state = mockSession;

      await tester.pump();
      await tester.pump(Duration.zero);

      verify(() => mockUsersRepository.getUserRow('test-user-id')).called(1);
    });

    testWidgets('SwishLab session listener handles loading state', (tester) async {
      final router = createRouter();
      final sessionStateProvider = StateProvider<FutureOr<Session?>>((ref) => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerProvider.overrideWithValue(router),
            debugProvider.overrideWith(() => DebugNotifier()),
            supabaseAuthListenerProvider.overrideWithValue(null),
            sessionBootstrapProvider.overrideWithValue(null),
            verifiedSessionProvider.overrideWith((ref) => ref.watch(sessionStateProvider)),
            usersRepositoryProvider.overrideWithValue(mockUsersRepository),
          ],
          child: const SwishLab(),
        ),
      );
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(SwishLab)));

      final completer = Completer<Session?>();
      container.read(sessionStateProvider.notifier).state = completer.future;
      await tester.pump();

      verifyNever(() => mockUsersRepository.getUserRow(any()));
    });
  });
}
