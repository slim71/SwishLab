import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/router/central_routing.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/models/custom_enums.dart';
import 'package:swish_lab/pages/error_page.dart';
import 'package:swish_lab/controllers/shooting_analysis_notifier.dart';
import 'package:swish_lab/providers/shooting_analysis_provider.dart';
import 'package:swish_lab/models/analysis_state.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../test_helper.dart';

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

class MockVideoPlayerPlatform extends Mock with MockPlatformInterfaceMixin implements VideoPlayerPlatform {}

class FakeShootingAnalysisController extends StateNotifier<AnalysisState> implements ShootingAnalysisController {
  FakeShootingAnalysisController() : super(AnalysisIdle());

  @override
  late final Ref ref;

  @override
  Future<void> start({
    required File videoFile,
    required String shootingHand,
    required String pointOfView,
  }) async {
    // Do nothing
  }

  @override
  void cancel() {
    state = AnalysisIdle();
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockVideoPlayerPlatform mockVideoPlayerPlatform;

  const testUser = UsersRow(
    id: '123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    profilePic: null,
  );

  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();

    final dataSource = DataSource(sourceType: DataSourceType.asset, asset: '');
    registerFallbackValue(dataSource);
    registerFallbackValue(VideoPlayerOptions());
    registerFallbackValue(VideoCreationOptions(dataSource: dataSource, viewType: VideoViewType.values.first));
    registerFallbackValue(Duration.zero);
    registerFallbackValue(const VideoViewOptions(playerId: 1));
    registerFallbackValue(File(''));

    mockVideoPlayerPlatform = MockVideoPlayerPlatform();
    VideoPlayerPlatform.instance = mockVideoPlayerPlatform;

    when(() => mockVideoPlayerPlatform.init()).thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.createWithOptions(any())).thenAnswer((_) async => 1);
    when(() => mockVideoPlayerPlatform.setPreventsDisplaySleepDuringVideoPlayback(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockVideoPlayerPlatform.videoEventsFor(any())).thenAnswer((_) => const Stream.empty());
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

  group('routerProvider', () {
    testWidgets('RouterObserver methods including replace', (tester) async {
      final container = createContainer(overrides: [
        appStatusProvider.overrideWith((ref) => AppAuthStatus.authenticated),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
        appUserProvider.overrideWith((ref) => testUser),
      ]);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      router.push('/splash');
      await tester.pump();

      // router.replace should trigger didReplace
      router.replace<void>('/home');
      await tester.pump();

      router.pop();
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('redirects to onboarding for new user', (tester) async {
      final container = createContainer(overrides: [
        appStatusProvider.overrideWith((ref) => AppAuthStatus.authenticated),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: false))),
        appUserProvider.overrideWith((ref) => testUser),
      ]);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      // Should redirect from / to onboarding
      expect(router.state.matchedLocation, '/settings/getting-started');

      // Clean up animations
      await tester.pumpAndSettle();
    });

    testWidgets('covers all routes builders including pageBuilders', (tester) async {
      final container = createContainer(overrides: [
        appStatusProvider.overrideWith((ref) => AppAuthStatus.authenticated),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
        appUserProvider.overrideWith((ref) => testUser),
        shootingAnalysisProvider.overrideWith((ref) => FakeShootingAnalysisController()),
      ]);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();

      // Exhaustively visit every route
      final routes = [
        '/home',
        '/activity',
        '/profile',
        '/settings',
        '/settings/about',
        '/settings/help',
        '/settings/debug',
        '/settings/user',
        '/settings/getting-started',
        '/settings/credits',
        '/settings/appearance',
        '/settings/theme-test',
        '/settings/doc/PRIVACY',
        '/splash',
        '/login', // Uses pageBuilder
        '/signup', // Uses pageBuilder
        '/success',
        '/side',
        '/front',
        '/pic',
        '/loading',
        '/',
      ];

      for (final route in routes) {
        router.go(route);
        await tester.pump();
      }

      // Complex routes with extra
      router.go('/results', extra: <String, dynamic>{'analysis': <String, dynamic>{}});
      await tester.pump();

      router.go('/pre-upload/front', extra: <String, dynamic>{
        'originFunc': OriginFunc.front,
        'videoFile': File('test.mp4'),
      });
      await tester.pump();

      router.go('/processing', extra: <String, dynamic>{
        'videoFile': File('test.mp4'),
        'shootingHand': 'Right',
        'pointOfView': 'Front',
      });
      await tester.pump();

      // Hit defensive branches in builders
      router.go('/pre-upload/invalid_perspective', extra: <String, dynamic>{
        'videoFile': File('test.mp4'),
      });
      await tester.pump();

      router.go('/pre-upload/front', extra: <String, dynamic>{
        'videoFile': 'not_a_file',
      });
      await tester.pump();

      router.go('/pre-upload/front', extra: null);
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('covers errorBuilder', (tester) async {
      final container = createContainer(overrides: [
        appStatusProvider.overrideWith((ref) => AppAuthStatus.authenticated),
        appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(hasOpenedBefore: true))),
        appUserProvider.overrideWith((ref) => testUser),
      ]);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      router.go('/invalid-route-force-error');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ErrorPage), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
