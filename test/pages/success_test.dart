import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/success.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../test_helper.dart';

class MockUser extends Mock implements supabase.User {}

void main() {
  group('SuccessAfterSignup', () {
    testWidgets('should render correctly with user info', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();
      final mockAuthUser = MockUser();
      when(() => mockAuthUser.id).thenReturn('123');

      const user = UsersRow(
        id: '123',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
      );

      await tester.pumpWidget(
        createTestWidget(
          router: mockRouter,
          overrides: [
            authUserProvider.overrideWithValue(mockAuthUser),
            appUserProvider.overrideWith((ref) => user),
          ],
          child: const SuccessAfterSignup(),
        ),
      );

      // Wait for animations and provider resolution
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Welcome to the Lab'), findsOneWidget);
      expect(find.text('Your account is ready.'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);

      final button = find.text('Get Started');
      expect(button, findsOneWidget);

      await tester.tap(button, warnIfMissed: false);
      await tester.pump();

      verify(() => mockRouter.goNamed('getting-started')).called(1);

      // Cleanup animations
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
