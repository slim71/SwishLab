import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player/video_player.dart';
import 'package:swish_lab/widgets/video_preview.dart';
import 'package:swish_lab/models/video_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVideoPlayerPlatform extends Mock with MockPlatformInterfaceMixin implements VideoPlayerPlatform {}

class FakeDataSource extends Fake implements DataSource {}

class FakeVideoCreationOptions extends Fake implements VideoCreationOptions {}

class FakeVideoViewOptions extends Fake implements VideoViewOptions {}

void main() {
  late MockVideoPlayerPlatform mockPlatform;
  late StreamController<VideoEvent> eventController;

  setUpAll(() {
    registerFallbackValue(FakeDataSource());
    registerFallbackValue(FakeVideoCreationOptions());
    registerFallbackValue(FakeVideoViewOptions());
  });

  setUp(() {
    mockPlatform = MockVideoPlayerPlatform();
    VideoPlayerPlatform.instance = mockPlatform;
    eventController = StreamController<VideoEvent>.broadcast();

    when(() => mockPlatform.init()).thenAnswer((_) async => {});
    when(() => mockPlatform.createWithOptions(any())).thenAnswer((_) async => 1);
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

  testWidgets('VideoPreview handles NetworkVideoSource', (tester) async {
    const source = NetworkVideoSource('https://example.com/video.mp4');

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: VideoPreview(source: source),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    eventController.add(VideoEvent(
      eventType: VideoEventType.initialized,
      duration: const Duration(seconds: 1),
      size: const Size(100, 100),
    ));

    await tester.pump();
    await tester.pump();

    expect(find.byType(VideoPlayer), findsOneWidget);
  });

  testWidgets('VideoPreview handles FileVideoSource', (tester) async {
    final file = File('test_video.mp4');
    final source = FileVideoSource(file);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: VideoPreview(source: source),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    eventController.add(VideoEvent(
      eventType: VideoEventType.initialized,
      duration: const Duration(seconds: 1),
      size: const Size(100, 100),
    ));

    await tester.pump();
    await tester.pump();

    expect(find.byType(VideoPlayer), findsOneWidget);
  });

  testWidgets('VideoPreview autoPlay and play/pause toggle', (tester) async {
    const source = NetworkVideoSource('https://example.com/video.mp4');

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: VideoPreview(
          source: source,
          autoPlay: true,
          looping: false,
        ),
      ),
    ));

    eventController.add(VideoEvent(
      eventType: VideoEventType.initialized,
      duration: const Duration(seconds: 1),
      size: const Size(100, 100),
    ));

    await tester.pump();
    await tester.pump();

    // Tap to pause (or play if it wasn't playing)
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    // Dispose
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
