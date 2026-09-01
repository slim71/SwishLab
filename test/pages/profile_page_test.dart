import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/profile_page.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/providers/statistics_provider.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('ProfilePage displays user information and stats', (WidgetTester tester) async {
    final user = UsersRow(
      id: 'user-123',
      email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      createdAt: DateTime(2023, 8, 23),
      shootingHand: 'Right',
    );

    await tester.pumpWidget(createTestWidget(
      child: const ProfilePage(),
      overrides: [
        appUserProvider.overrideWith((ref) => user),
        userStatisticsProvider.overrideWith((ref) => MockUserStatisticsNotifier(
            ref, const AsyncValue.data(UserStatisticsState(items: [], totalCount: 0, hasMore: false)))),
      ],
    ));

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('JOHN DOE'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Right hand'), findsOneWidget);
    expect(find.text('MEMBER SINCE AUGUST 2023'), findsOneWidget);
    expect(find.text('Performance Overview'), findsOneWidget);

    // Tap background to hit onTap branch
    await tester.tap(find.byType(ProfilePage));
    await tester.pump();
  });
}
