import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/analysis_results.dart';
import 'package:swish_lab/providers/shared_preferences_provider.dart';
import 'package:swish_lab/providers/shooting_analysis_provider.dart';
import 'package:swish_lab/models/analysis_state.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:swish_lab/widgets/section_details.dart';
import 'package:swish_lab/controllers/shooting_analysis_notifier.dart';
import 'package:state_notifier/state_notifier.dart';
import '../test_helper.dart';

class MockVideoPlayerPlatform extends Mock with MockPlatformInterfaceMixin implements VideoPlayerPlatform {}

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;

  @override
  void setShowRadarChart(bool value) {
    state = state.copyWith(showRadarChart: value);
  }
}

class TestShootingAnalysisController extends StateNotifier<AnalysisState> implements ShootingAnalysisController {
  TestShootingAnalysisController() : super(AnalysisIdle());

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<void> start({
    required File videoFile,
    required String shootingHand,
    required String pointOfView,
  }) async {}

  @override
  void cancel() {
    state = AnalysisIdle();
  }
}

void main() {
  late MockSharedPreferences mockPrefs;
  late MockVideoPlayerPlatform mockVideoPlayerPlatform;

  setUpAll(() {
    final dataSource = DataSource(sourceType: DataSourceType.asset, asset: '');
    registerFallbackValue(dataSource);
    registerFallbackValue(VideoPlayerOptions());
    registerFallbackValue(VideoCreationOptions(dataSource: dataSource, viewType: VideoViewType.values.first));
    registerFallbackValue(Duration.zero);
    registerFallbackValue(const VideoViewOptions(playerId: 1));

    mockVideoPlayerPlatform = MockVideoPlayerPlatform();
    VideoPlayerPlatform.instance = mockVideoPlayerPlatform;

    when(() => mockVideoPlayerPlatform.init()).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.createWithOptions(any())).thenAnswer((_) async => 1);
    when(() => mockVideoPlayerPlatform.setPreventsDisplaySleepDuringVideoPlayback(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.videoEventsFor(any())).thenAnswer((_) => Stream.value(
          VideoEvent(
            eventType: VideoEventType.initialized,
            duration: const Duration(seconds: 1),
            size: const Size(100, 100),
          ),
        ));
    when(() => mockVideoPlayerPlatform.setLooping(any(), any())).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.seekTo(any(), any())).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.getPosition(any())).thenAnswer((_) async => Duration.zero);
    when(() => mockVideoPlayerPlatform.buildViewWithOptions(any())).thenReturn(const SizedBox());
    when(() => mockVideoPlayerPlatform.dispose(any())).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.setVolume(any(), any())).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.setPlaybackSpeed(any(), any())).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.play(any())).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.pause(any())).thenAnswer((_) async {});
  });

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getBool(any())).thenReturn(null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
  });

  final mockVideoData = {
    'analysis': {
      'Set point': {
        'scores': {'Total': 0.8}
      },
      'Jump': {
        'scores': {'Total': 0.7}
      },
      'Elbow position': {
        'scores': {'Total': 0.9}
      },
    }
  };

  group('AnalysisResults', () {
    testWidgets('displays radar chart and section scores', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2400));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          shootingAnalysisProvider.overrideWith((ref) => TestShootingAnalysisController()),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(showRadarChart: true))),
        ],
        child: AnalysisResults(videoDataJson: mockVideoData),
      ));

      await tester.pumpAndSettle();
      expect(find.byType(RadarChart), findsOneWidget);
      expect(find.text('Set point'), findsWidgets);
      expect(find.text('0.8'), findsOneWidget);
    });

    testWidgets('toggles radar chart visibility', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2400));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          shootingAnalysisProvider.overrideWith((ref) => TestShootingAnalysisController()),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(showRadarChart: true))),
        ],
        child: AnalysisResults(videoDataJson: mockVideoData),
      ));

      await tester.pumpAndSettle();
      expect(find.byType(RadarChart), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(RadarChart), findsNothing);

      await tester.tap(find.text('SHOW FORM SIGNATURE'));
      await tester.pumpAndSettle();
      expect(find.byType(RadarChart), findsOneWidget);
    });

    testWidgets('opens bottom sheet and unfocuses', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2400));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => TestShootingAnalysisController()),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState())),
        ],
        child: AnalysisResults(videoDataJson: mockVideoData),
      ));
      await tester.pumpAndSettle();

      final jumpFinder = find.text('Jump');
      await tester.ensureVisible(jumpFinder);
      await tester.tap(jumpFinder);
      await tester.pumpAndSettle();

      expect(find.byType(SectionDetails), findsOneWidget);

      // Tap background of bottom sheet
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    });

    testWidgets('handles missing "Total" score and background tap', (tester) async {
      final incompleteData = {
        'analysis': {
          'A': {
            'scores': {'X': 0.1}
          },
          'B': {
            'scores': {'X': 0.1}
          },
          'C': {
            'scores': {'X': 0.1}
          },
        }
      };

      await tester.pumpWidget(createTestWidget(
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => TestShootingAnalysisController()),
          appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(showRadarChart: true))),
        ],
        child: AnalysisResults(videoDataJson: incompleteData),
      ));
      await tester.pumpAndSettle();

      expect(find.text('POOR'), findsAtLeast(3));

      // Tap background to unfocus
      await tester.tapAt(const Offset(400, 100));
      await tester.pump();
    });
  });
}
