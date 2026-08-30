import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/processing_video.dart';
import 'package:swish_lab/providers/shooting_analysis_provider.dart';
import 'package:swish_lab/models/analysis_state.dart';
import 'package:swish_lab/controllers/shooting_analysis_notifier.dart';
import 'package:swish_lab/models/results_response.dart';
import 'package:state_notifier/state_notifier.dart';
import '../test_helper.dart';

class TestShootingAnalysisController extends StateNotifier<AnalysisState> implements ShootingAnalysisController {
  TestShootingAnalysisController() : super(AnalysisIdle());

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<void> start({
    required File videoFile,
    required String shootingHand,
    required String pointOfView,
  }) async {
    // Initial call
  }

  @override
  void cancel() {
    state = AnalysisIdle();
  }

  void setTestState(AnalysisState newState) {
    state = newState;
  }
}

void main() {
  late TestShootingAnalysisController mockNotifier;
  late File testFile;

  setUp(() {
    mockNotifier = TestShootingAnalysisController();
    testFile = File('test.mp4');
  });

  group('ProcessingVideo', () {
    testWidgets('renders correctly and handles success', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => mockNotifier),
        ],
        child: ProcessingVideo(
          videoFile: testFile,
          shootingHand: 'right',
          pointOfView: 'front',
        ),
      ));

      expect(find.text('Processing Video'), findsOneWidget);

      // Simulate success
      final mockResult = ResultsResponse({'data': 'results'});

      mockNotifier.setTestState(AnalysisSuccess(mockResult));
      await tester.pump(); // trigger listener

      verify(() => mockRouter.goNamed('results', extra: mockResult.raw)).called(1);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles failure with error dialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => mockNotifier),
        ],
        child: ProcessingVideo(
          videoFile: testFile,
          shootingHand: 'right',
          pointOfView: 'front',
        ),
      ));

      // Simulate failure
      mockNotifier.setTestState(AnalysisFailure('Network error'));
      await tester.pump(); // trigger listener
      await tester.pump(); // show dialog

      expect(find.text('Analysis failed'), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);

      // Tap "Go home"
      await tester.tap(find.text('Go home'));
      await tester.pumpAndSettle();

      verify(() => mockRouter.goNamed('home')).called(1);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles DioException failure', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => mockNotifier),
        ],
        child: ProcessingVideo(
          videoFile: testFile,
          shootingHand: 'right',
          pointOfView: 'front',
        ),
      ));

      // Simulate DioException
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test-url'),
        response: Response(requestOptions: RequestOptions(path: 'test-url'), statusCode: 500),
        type: DioExceptionType.badResponse,
        message: 'Internal Server Error',
      );

      mockNotifier.setTestState(AnalysisFailure(dioError));
      await tester.pump(); // trigger listener
      await tester.pump(); // show dialog

      expect(find.text('Analysis failed'), findsOneWidget);
      expect(find.textContaining('Network Error'), findsOneWidget);
      expect(find.textContaining('500'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Go back button pops', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      await tester.pumpWidget(createTestWidget(
        router: mockRouter,
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => mockNotifier),
        ],
        child: ProcessingVideo(
          videoFile: testFile,
          shootingHand: 'right',
          pointOfView: 'front',
        ),
      ));

      await tester.tap(find.text('Go back'));
      await tester.pumpAndSettle();

      expect(find.text('Stop Analysis?'), findsOneWidget);
      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();

      verify(() => mockRouter.pop()).called(1);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('GestureDetector unfocuses on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(createTestWidget(
        overrides: [
          shootingAnalysisProvider.overrideWith((ref) => mockNotifier),
        ],
        child: ProcessingVideo(
          videoFile: testFile,
          shootingHand: 'right',
          pointOfView: 'front',
        ),
      ));

      await tester.tap(find.text('Processing Video'));
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
