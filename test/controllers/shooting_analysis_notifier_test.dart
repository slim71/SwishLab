import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/controllers/shooting_analysis_notifier.dart';
import 'package:swish_lab/models/analysis_state.dart';
import 'package:swish_lab/models/analysis_response.dart';
import 'package:swish_lab/models/results_response.dart';
import 'package:swish_lab/providers/api_providers.dart';
import 'package:swish_lab/providers/upload_provider.dart';
import 'package:swish_lab/api/endpoint_address_api.dart';
import 'package:swish_lab/providers/shooting_analysis_provider.dart';
import 'package:swish_lab/providers/auth_providers.dart';
import 'package:swish_lab/providers/statistics_provider.dart';
import 'package:fake_async/fake_async.dart';

import '../test_helper.dart';

class MockEndpointAddressApi extends Mock implements EndpointAddressApi {}

void main() {
  setUpAll(() {
    registerFallbackValue(CancelToken());
  });

  late MockEndpointAddressApi api;
  late MockStatisticsRepository statsRepo;
  late MockUser user;
  late ProviderContainer container;
  late ShootingAnalysisController controller;
  late File testFile;

  setUp(() {
    api = MockEndpointAddressApi();
    statsRepo = MockStatisticsRepository();
    user = MockUser();

    when(() => user.id).thenReturn('user123');
    when(() => statsRepo.insertAnalysisResults(
          userId: any(named: 'userId'),
          analysisData: any(named: 'analysisData'),
        )).thenAnswer((_) async => {});

    container = createContainer(
      overrides: [
        endpointAddressApiProvider.overrideWithValue(api),
        videoUploaderProvider.overrideWithValue((file) async => 'gradio-url'),
        statisticsRepositoryProvider.overrideWithValue(statsRepo),
        authUserProvider.overrideWithValue(user),
      ],
    );
    controller = container.read(shootingAnalysisProvider.notifier);
    testFile = File('test.mp4');
  });

  group('ShootingAnalysisController', () {
    test('initial state is AnalysisIdle', () {
      expect(controller.state, isA<AnalysisIdle>());
    });

    test('start success flow', () async {
      // Mock analyzeShootingForm
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      // Mock getFinalAnalysisResult
      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => ResultsResponse(<String, dynamic>{'analysis': <String, dynamic>{}}));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisSuccess>());
    });

    test('start success flow transitions through loading', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => ResultsResponse(<String, dynamic>{'analysis': <String, dynamic>{}}));

      final states = <AnalysisState>[];
      container.listen(shootingAnalysisProvider, (previous, next) {
        states.add(next);
      }, fireImmediately: true);

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(states[0], isA<AnalysisIdle>());
      expect(states[1], isA<AnalysisLoading>());
      expect(states[2], isA<AnalysisSuccess>());
    });

    test('start failure at upload', () async {
      // Re-create container for this test to override videoUploaderProvider to fail
      container = createContainer(
        overrides: [
          endpointAddressApiProvider.overrideWithValue(api),
          videoUploaderProvider.overrideWithValue((file) async => throw Exception('Upload failed')),
        ],
      );
      controller = container.read(shootingAnalysisProvider.notifier);

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error.toString(), contains('Upload failed'));
    });

    test('start failure at upload timeout exception', () async {
      container = createContainer(
        overrides: [
          endpointAddressApiProvider.overrideWithValue(api),
          videoUploaderProvider.overrideWithValue((file) async => throw Exception('Upload timed out')),
        ],
      );
      controller = container.read(shootingAnalysisProvider.notifier);

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error.toString(), contains('Upload timed out'));
    });

    test('start failure at analysis trigger', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(Exception('Trigger failed'));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
    });

    test('start failure at results check (succeeded=false)', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => ResultsResponse(<String, dynamic>{}, opStatus: false, opError: 'Backend error'));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error, 'Backend error');
    });

    test('start failure with empty upload URL', () async {
      container = createContainer(
        overrides: [
          endpointAddressApiProvider.overrideWithValue(api),
          videoUploaderProvider.overrideWithValue((file) async => throw Exception('Upload failed')),
        ],
      );
      controller = container.read(shootingAnalysisProvider.notifier);

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error.toString(), contains('Upload failed'));
    });

    test('start failure at results check with null opError', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => ResultsResponse(<String, dynamic>{}, opStatus: false, opError: null));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error, 'Analysis failed');
    });

    test('start failure at getFinalAnalysisResult with generic exception', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(Exception('Unexpected stream error'));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error.toString(), contains('Unexpected stream error'));
    });

    test('start failure at analysis trigger timeout exception', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(Exception('Triggering analysis timed out'));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error.toString(), contains('Triggering analysis timed out'));
    });

    test('start failure at results timeout exception', () async {
      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(Exception('Analysis timed out'));

      await controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(controller.state, isA<AnalysisFailure>());
      final failure = controller.state as AnalysisFailure;
      expect(failure.error.toString(), contains('Analysis timed out'));
    });

    group('Timeout Coverage (fakeAsync)', () {
      test('upload timeout branch', () {
        fakeAsync((async) {
          final completer = Completer<String>();
          final localContainer = createContainer(
            overrides: [
              endpointAddressApiProvider.overrideWithValue(api),
              videoUploaderProvider.overrideWithValue((file) => completer.future),
            ],
          );
          // Listen to keep the autoDispose provider alive
          localContainer.listen(shootingAnalysisProvider, (p, n) {});
          final localController = localContainer.read(shootingAnalysisProvider.notifier);

          localController.start(
            videoFile: testFile,
            shootingHand: 'Right',
            pointOfView: 'Side',
          );

          async.elapse(const Duration(minutes: 2, seconds: 1));

          // Flush microtasks multiple times to allow the async function to resume and reach the catch block
          for (int i = 0; i < 5; i++) {
            async.flushMicrotasks();
          }

          expect(localController.state, isA<AnalysisFailure>());
          expect((localController.state as AnalysisFailure).error.toString(), contains('Upload timed out'));
        });
      });

      test('trigger timeout branch', () {
        fakeAsync((async) {
          final completer = Completer<AnalysisResponse>();
          final localContainer = createContainer(
            overrides: [
              endpointAddressApiProvider.overrideWithValue(api),
              videoUploaderProvider.overrideWithValue((file) async => 'url'),
            ],
          );
          localContainer.listen(shootingAnalysisProvider, (p, n) {});
          final localController = localContainer.read(shootingAnalysisProvider.notifier);

          when(() => api.analyzeShootingForm(
                sourceVideo: any(named: 'sourceVideo'),
                shootingHand: any(named: 'shootingHand'),
                pointOfView: any(named: 'pointOfView'),
                cancelToken: any(named: 'cancelToken'),
              )).thenAnswer((_) => completer.future);

          localController.start(
            videoFile: testFile,
            shootingHand: 'Right',
            pointOfView: 'Side',
          );

          async.elapse(const Duration(seconds: 31));
          for (int i = 0; i < 5; i++) {
            async.flushMicrotasks();
          }

          expect(localController.state, isA<AnalysisFailure>());
          expect(
              (localController.state as AnalysisFailure).error.toString(), contains('Triggering analysis timed out'));
        });
      });

      test('results timeout branch', () {
        fakeAsync((async) {
          final completer = Completer<ResultsResponse>();
          final localContainer = createContainer(
            overrides: [
              endpointAddressApiProvider.overrideWithValue(api),
              videoUploaderProvider.overrideWithValue((file) async => 'url'),
            ],
          );
          localContainer.listen(shootingAnalysisProvider, (p, n) {});
          final localController = localContainer.read(shootingAnalysisProvider.notifier);

          when(() => api.analyzeShootingForm(
                sourceVideo: any(named: 'sourceVideo'),
                shootingHand: any(named: 'shootingHand'),
                pointOfView: any(named: 'pointOfView'),
                cancelToken: any(named: 'cancelToken'),
              )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

          when(() => api.getFinalAnalysisResult(
                hfEventId: any(named: 'hfEventId'),
                cancelToken: any(named: 'cancelToken'),
              )).thenAnswer((_) => completer.future);

          localController.start(
            videoFile: testFile,
            shootingHand: 'Right',
            pointOfView: 'Side',
          );

          async.elapse(const Duration(minutes: 5, seconds: 1));
          for (int i = 0; i < 5; i++) {
            async.flushMicrotasks();
          }

          expect(localController.state, isA<AnalysisFailure>());
          expect((localController.state as AnalysisFailure).error.toString(), contains('Analysis timed out'));
        });
      });
    });
    test('cancel() sets state to AnalysisIdle', () {
      controller.state = AnalysisLoading();
      controller.cancel();
      expect(controller.state, isA<AnalysisIdle>());
    });

    test('start success flow when user is null', () async {
      container = createContainer(
        overrides: [
          endpointAddressApiProvider.overrideWithValue(api),
          videoUploaderProvider.overrideWithValue((file) async => 'gradio-url'),
          statisticsRepositoryProvider.overrideWithValue(statsRepo),
          authUserProvider.overrideWithValue(null),
        ],
      );
      final localController = container.read(shootingAnalysisProvider.notifier);

      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => AnalysisResponse(eventId: 'evt123'));

      when(() => api.getFinalAnalysisResult(
            hfEventId: any(named: 'hfEventId'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => ResultsResponse(<String, dynamic>{'analysis': <String, dynamic>{}}));

      await localController.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      expect(localController.state, isA<AnalysisSuccess>());
      verifyNever(() =>
          statsRepo.insertAnalysisResults(userId: any(named: 'userId'), analysisData: any(named: 'analysisData')));
    });

    test('cancellation during process returns early', () async {
      final uploadCompleter = Completer<String>();
      container = createContainer(
        overrides: [
          endpointAddressApiProvider.overrideWithValue(api),
          videoUploaderProvider.overrideWithValue((file) => uploadCompleter.future),
        ],
      );
      final localController = container.read(shootingAnalysisProvider.notifier);

      final startFuture = localController.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      localController.cancel();
      uploadCompleter.complete('gradio-url');
      await startFuture;

      expect(localController.state, isA<AnalysisIdle>());
    });

    test('cancel() aborts active Dio requests', () async {
      final analyzeCompleter = Completer<AnalysisResponse>();

      // Keep the provider alive
      container.listen(shootingAnalysisProvider, (p, n) {});

      when(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) => analyzeCompleter.future);

      final startFuture = controller.start(
        videoFile: testFile,
        shootingHand: 'Right',
        pointOfView: 'Side',
      );

      // Give it a moment to reach the trigger analysis step
      await Future<void>.delayed(Duration.zero);

      controller.cancel();

      // Capture the cancel token passed to the API
      final capturedToken = verify(() => api.analyzeShootingForm(
            sourceVideo: any(named: 'sourceVideo'),
            shootingHand: any(named: 'shootingHand'),
            pointOfView: any(named: 'pointOfView'),
            cancelToken: captureAny(named: 'cancelToken'),
          )).captured.first as CancelToken;

      expect(capturedToken.isCancelled, isTrue);

      // Complete the future with a cancel error to simulate Dio behavior
      analyzeCompleter.completeError(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      ));

      await startFuture;
      expect(controller.state, isA<AnalysisIdle>());
    });
  });
}
