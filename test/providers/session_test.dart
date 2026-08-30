import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/models/user_row_data.dart';
import 'package:swish_lab/providers/session.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_helper.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSession extends Mock implements Session {}

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void setUserData(UserRowData data) {
    state = state.copyWith(userData: data, userDataFetched: true);
  }
}

void main() {
  late MockSupabaseClient supabaseClient;
  late MockGoTrueClient authClient;

  setUp(() {
    supabaseClient = MockSupabaseClient();
    authClient = MockGoTrueClient();

    when(() => supabaseClient.auth).thenReturn(authClient);
  });

  group('sessionBootstrapProvider', () {
    test('syncs user data to appState when user is loaded', () async {
      final user = UsersRow(
        id: 'u1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        profilePic: 'pic.png',
        shootingHand: 'Right',
        createdAt: DateTime(2023, 1, 1),
      );

      final container = createContainer(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          appUserProvider.overrideWithValue(AsyncValue.data(user)),
        ],
      );

      // Accessing the provider triggers the listener
      container.read(sessionBootstrapProvider);

      final state = container.read(appStateProvider);
      expect(state.userData?.firstName, 'John');
      expect(state.userData?.userID, 'u1');
      expect(state.userData?.profilePicture, 'pic.png');
    });

    test('uses default profile picture when user.profilePic is null', () async {
      final user = UsersRow(
        id: 'u1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        profilePic: null, // Test fallback
        shootingHand: 'Right',
        createdAt: DateTime(2023, 1, 1),
      );

      final container = createContainer(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          appUserProvider.overrideWithValue(AsyncValue.data(user)),
        ],
      );

      container.read(sessionBootstrapProvider);

      final state = container.read(appStateProvider);
      expect(state.userData?.profilePicture, contains('default_profile_male.png'));
    });

    test('does nothing when user is null', () async {
      final container = createContainer(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          appUserProvider.overrideWithValue(const AsyncValue.data(null)),
        ],
      );

      container.read(sessionBootstrapProvider);

      final state = container.read(appStateProvider);
      expect(state.userDataFetched, isFalse);
    });

    test('does nothing when user is error', () async {
      final container = createContainer(
        overrides: [
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
          appUserProvider.overrideWithValue(AsyncValue.error('error', StackTrace.current)),
        ],
      );

      container.read(sessionBootstrapProvider);

      final state = container.read(appStateProvider);
      expect(state.userDataFetched, isFalse);
    });
  });

  group('verifiedSessionProvider', () {
    test('returns current supabase session', () async {
      final mockSession = MockSession();
      when(() => authClient.currentSession).thenReturn(mockSession);

      final container = createContainer(
        overrides: [
          supabaseProvider.overrideWithValue(supabaseClient),
        ],
      );

      final result = await container.read(verifiedSessionProvider.future);

      expect(result, mockSession);
    });

    test('returns null when no session', () async {
      when(() => authClient.currentSession).thenReturn(null);

      final container = createContainer(
        overrides: [
          supabaseProvider.overrideWithValue(supabaseClient),
        ],
      );

      final result = await container.read(verifiedSessionProvider.future);

      expect(result, isNull);
    });
  });
}
