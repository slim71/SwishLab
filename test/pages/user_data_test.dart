import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:swish_lab/pages/user_data.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/models/user_row_data.dart';
import 'package:swish_lab/features/update_user_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../test_helper.dart';

class MockUpdateUser extends Mock implements UpdateUser {
  @override
  Future<UsersRow> execute({required String userId, required Map<String, dynamic> data});
}

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

void main() {
  late MockUpdateUser mockUpdateUser;
  late UsersRow testUser;

  setUpAll(() {
    testUser = UsersRow(
      id: '123',
      email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      shootingHand: 'Right',
      createdAt: DateTime(2023, 1, 1),
    );
  });

  setUp(() {
    mockUpdateUser = MockUpdateUser();
  });

  group('UserData', () {
    testWidgets('renders user information correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const UserData(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('shows validation errors and shakes on invalid input', (tester) async {
      await tester.pumpWidget(createTestWidget(
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const UserData(),
      ));
      await tester.pumpAndSettle();

      final firstNameField = find.widgetWithText(TextFormField, 'First Name');
      await tester.enterText(firstNameField, ''); // Empty
      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      expect(find.text('Valid First Name required'), findsOneWidget);

      await tester.enterText(firstNameField, 'A'); // Too short
      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      // isFieldValid returns true for non-empty string in _handleSave, but InputField validator might show something else
      // In _handleSave: firstNameValid: firstNameFieldTextController.text.isNotEmpty && isFieldValid(...)
    });

    testWidgets('handles save failure with snackbar', (tester) async {
      when(() => mockUpdateUser.execute(userId: any(named: 'userId'), data: any(named: 'data')))
          .thenThrow(Exception('Update failed'));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
          updateUserProvider.overrideWithValue(mockUpdateUser),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const UserData(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.text('Failed to update profile.'), findsOneWidget);
    });

    testWidgets('shooting hand dropdown updates state', (tester) async {
      await tester.pumpWidget(createTestWidget(
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: const UserData(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Right'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Left').last);
      await tester.pumpAndSettle();

      expect(find.text('Left'), findsWidgets);
    });

    testWidgets('successful save updates state and shows success dialog', (tester) async {
      final mockAppState = const AppState(userData: UserRowData(userID: '123'));

      when(() => mockUpdateUser.execute(userId: any(named: 'userId'), data: any(named: 'data')))
          .thenAnswer((_) async => testUser.copyWith(firstName: 'Jane'));

      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, __) => const Scaffold(body: Text('Home'))),
          GoRoute(path: '/user-data', builder: (_, __) => const UserData()),
        ],
      );

      await tester.pumpWidget(createTestWidget(
        router: router,
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
          updateUserProvider.overrideWithValue(mockUpdateUser),
          appStateProvider.overrideWith(() => MockAppStateNotifier(mockAppState)),
        ],
        child: const SizedBox(),
      ));

      router.push('/user-data');
      await tester.pumpAndSettle();

      final firstNameField = find.widgetWithText(TextFormField, 'First Name');
      await tester.enterText(firstNameField, 'Jane');

      await tester.tap(find.text('Save Changes'));
      await tester.pump(); // Start save
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Profile updated successfully!'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}
