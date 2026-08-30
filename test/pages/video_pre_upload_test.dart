import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/video_pre_upload.dart';
import 'package:swish_lab/models/custom_enums.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../test_helper.dart';

class MockVideoPlayerPlatform extends Mock with MockPlatformInterfaceMixin implements VideoPlayerPlatform {}

class FakeDataSource extends Fake implements DataSource {}

class FakeVideoCreationOptions extends Fake implements VideoCreationOptions {}

class FakeVideoViewOptions extends Fake implements VideoViewOptions {}

void main() {
  late MockVideoPlayerPlatform mockPlatform;
  late StreamController<VideoEvent> eventController;
  late File testFile;

  setUpAll(() {
    registerFallbackValue(FakeDataSource());
    registerFallbackValue(FakeVideoCreationOptions());
    registerFallbackValue(FakeVideoViewOptions());
  });

  setUp(() {
    mockPlatform = MockVideoPlayerPlatform();
    VideoPlayerPlatform.instance = mockPlatform;
    eventController = StreamController<VideoEvent>.broadcast();
    testFile = File('test.mp4');

    when(() => mockPlatform.init()).thenAnswer((_) async {});
    when(() => mockPlatform.createWithOptions(any())).thenAnswer((_) async => 1);
    when(() => mockPlatform.setLooping(any(), any())).thenAnswer((_) async => {});
    when(() => mockPlatform.play(any())).thenAnswer((_) async => {});
    when(() => mockPlatform.pause(any())).thenAnswer((_) async => {});
    when(() => mockPlatform.dispose(any())).thenAnswer((_) async => {});
    when(() => mockPlatform.setPreventsDisplaySleepDuringVideoPlayback(any(), any())).thenAnswer((_) async => {});
    when(() => mockPlatform.setMixWithOthers(any())).thenAnswer((_) async => {});
    when(() => mockPlatform.setVolume(any(), any())).thenAnswer((_) async => {});
    when(() => mockPlatform.videoEventsFor(any())).thenAnswer((_) => eventController.stream);
    when(() => mockPlatform.buildViewWithOptions(any())).thenReturn(const SizedBox());
    when(() => mockPlatform.setPlaybackSpeed(any(), any())).thenAnswer((_) async => {});
    when(() => mockPlatform.getPosition(any())).thenAnswer((_) async => Duration.zero);
  });

  tearDown(() {
    eventController.close();
  });

  group('VideoPreUpload', () {
    testWidgets('renders all fields and handles successful navigation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();
      when(() => mockRouter.pushNamed(any(), extra: any(named: 'extra'))).thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          appUserProvider.overrideWithValue(const AsyncValue.data(null)),
        ],
        child: VideoPreUpload(
          perspective: OriginFunc.front,
          videoFile: testFile,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Review Upload'), findsOneWidget);
      expect(find.text('SESSION DETAILS'), findsOneWidget);
      expect(find.text('ANALYSIS CONFIG'), findsOneWidget);

      // Enter session name
      await tester.enterText(find.widgetWithText(TextFormField, 'Session Name'), 'My Test Session');
      await tester.pump();

      // Select shooting hand
      await tester.tap(find.text('RIGHT'));
      await tester.pump();

      // Start Analysis
      await tester.tap(find.text('Start AI Analysis'));
      await tester.pump(const Duration(milliseconds: 100));

      verify(() => mockRouter.pushNamed(
            'processing',
            extra: any(named: 'extra'),
          )).called(1);

      // Cleanup
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows error if shooting hand is missing', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appUserProvider.overrideWithValue(const AsyncValue.data(null)),
        ],
        child: VideoPreUpload(
          perspective: OriginFunc.front,
          videoFile: testFile,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      // Tap without selecting hand
      await tester.tap(find.text('Start AI Analysis'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Missing Data'), findsOneWidget);
      expect(find.text('Please select your shooting hand to proceed.'), findsOneWidget);

      // Close dialog for coverage of line 295
      await tester.tap(find.text('OK'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('initializes shooting hand from user profile', (tester) async {
      final mockRouter = MockGoRouter();
      when(() => mockRouter.pushNamed(any(), extra: any(named: 'extra'))).thenAnswer((_) async => null);

      final user = const UsersRow(
        id: '1',
        firstName: 'A',
        lastName: 'B',
        email: 'a@b.com',
        shootingHand: 'left',
      );

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(user)),
        ],
        child: VideoPreUpload(
          perspective: OriginFunc.front,
          videoFile: testFile,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Start AI Analysis'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Missing Data'), findsNothing);
      verify(() => mockRouter.pushNamed(any(), extra: any(named: 'extra'))).called(1);

      // Trigger onChanged for perspective (line 171)
      final perspectiveChip = find.text('FRONT');
      await tester.tap(perspectiveChip);
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles invalid shooting hand from profile', (tester) async {
      final user = const UsersRow(
        id: '1',
        firstName: 'A',
        lastName: 'B',
        email: 'a@b.com',
        shootingHand: 'invalid_hand', // Coverage for line 79
      );

      await tester.pumpWidget(createTestWidget(
        overrides: [
          appUserProvider.overrideWithValue(AsyncValue.data(user)),
        ],
        child: VideoPreUpload(
          perspective: OriginFunc.front,
          videoFile: testFile,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
