import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/services/authentication.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockOAuthResponse extends Mock implements OAuthResponse {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSupabaseClient supabase;
  late MockGoTrueClient auth;
  late AuthService authService;

  setUpAll(() {
    registerFallbackValue(OAuthProvider.google);

    // Mock url_launcher MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'), (MethodCall methodCall) async {
      return true;
    });
  });

  setUp(() {
    supabase = MockSupabaseClient();
    auth = MockGoTrueClient();
    when(() => supabase.auth).thenReturn(auth);
    authService = AuthService(supabase);
  });

  group('AuthService', () {
    test('signInWithGoogle calls oauth sign in', () async {
      final mockOAuthResponse = MockOAuthResponse();
      when(() => mockOAuthResponse.url).thenReturn('https://test.com');

      when(() => auth.getOAuthSignInUrl(
            provider: any(named: 'provider'),
            redirectTo: any(named: 'redirectTo'),
          )).thenAnswer((_) async => mockOAuthResponse);

      await authService.signInWithGoogle();

      verify(() => auth.getOAuthSignInUrl(
            provider: OAuthProvider.google,
            redirectTo: 'swishlab://auth-callback',
          )).called(1);
    });

    test('signInWithEmail returns user on success', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => auth.signInWithPassword(
            email: 'test@example.com',
            password: 'password',
          )).thenAnswer((_) async => mockResponse);

      final result = await authService.signInWithEmail('test@example.com', 'password');

      expect(result, equals(mockUser));
    });

    test('signOut calls auth sign out', () async {
      when(() => auth.signOut()).thenAnswer((_) async => {});

      await authService.signOut();

      verify(() => auth.signOut()).called(1);
    });

    test('signUp returns user on success', () async {
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => auth.signUp(
            email: 'test@example.com',
            password: 'password',
          )).thenAnswer((_) async => mockResponse);

      final result = await authService.signUp(email: 'test@example.com', password: 'password');

      expect(result, equals(mockUser));
    });

    test('currentUser returns supabase auth currentUser', () {
      final mockUser = MockUser();
      when(() => auth.currentUser).thenReturn(mockUser);

      final result = authService.currentUser;

      expect(result, equals(mockUser));
    });
  });
}
