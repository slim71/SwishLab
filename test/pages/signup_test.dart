import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/pages/signup.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void setHasOpenedBefore(bool value) {}
}

void main() {
  late MockAuthService mockAuthService;
  late MockUsersRepository mockUsersRepo;
  late MockGoRouter mockRouter;
  late MockUser mockUser;
  late MockSharedPreferences mockPrefs;

  setUpAll(() {
    registerFallbackValue(const AppState());
  });

  setUp(() {
    mockAuthService = MockAuthService();
    mockUsersRepo = MockUsersRepository();
    mockRouter = MockGoRouter();
    mockUser = MockUser();
    mockPrefs = MockSharedPreferences();

    when(() => mockUser.id).thenReturn('123');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockRouter.go(any())).thenReturn(null);
    when(() => mockRouter.goNamed(any())).thenReturn(null);

    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
  });

  group('SignupPage', () {
    testWidgets('shows validation errors for empty fields', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        child: const SignupPage(),
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('First name required'), findsOneWidget);
      expect(find.text('Last name required'), findsOneWidget);
      expect(find.text('Email required'), findsOneWidget);
    });

    testWidgets('validates name length', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget(
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'First Name'), 'A');
      await tester.enterText(find.widgetWithText(TextFormField, 'Last Name'), 'B');
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('First name too short'), findsOneWidget);
      expect(find.text('Last name too short'), findsOneWidget);
    });

    testWidgets('successful signup flow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      when(() => mockAuthService.signUp(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => mockUser);

      when(() => mockUsersRepo.insertUser(
            id: any(named: 'id'),
            email: any(named: 'email'),
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
          )).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          authServiceProvider.overrideWithValue(mockAuthService),
          usersRepositoryProvider.overrideWithValue(mockUsersRepo),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'First Name'), 'John');
      await tester.enterText(find.widgetWithText(TextFormField, 'Last Name'), 'Doe');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'john@doe.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'Password123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirm password'), 'Password123');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Account'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      verify(() => mockAuthService.signUp(email: 'john@doe.com', password: 'Password123')).called(1);
      verify(() => mockUsersRepo.insertUser(
            id: '123',
            email: 'john@doe.com',
            firstName: 'John',
            lastName: 'Doe',
          )).called(1);
      verify(() => mockRouter.go('/')).called(1);
    });

    testWidgets('handles AuthException', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(() => mockAuthService.signUp(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const AuthException('Error'));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'First Name'), 'John');
      await tester.enterText(find.widgetWithText(TextFormField, 'Last Name'), 'Doe');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'Password123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirm password'), 'Password123');

      await tester.tap(find.text('Create Account'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('Google Signup and Navigation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      when(() => mockAuthService.signInWithGoogle()).thenAnswer((_) async => mockUser);

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Signup with Google'));
      await tester.pumpAndSettle();
      verify(() => mockAuthService.signInWithGoogle()).called(1);

      await tester.tap(find.textContaining('Login here', findRichText: true));
      await tester.pumpAndSettle();
      verify(() => mockRouter.goNamed('login')).called(1);

      await tester.tap(find.text('Get Started'));
      await tester.pump();
    });
  });
}
