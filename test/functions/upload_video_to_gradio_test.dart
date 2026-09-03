import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:swish_lab/functions/upload_video_to_gradio.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(CancelToken());
    registerFallbackValue(Options());
    registerFallbackValue(FormData());
  });

  group('uploadVideoToGradio', () {
    late File tempFile;
    late Dio mockDio;

    setUp(() async {
      final tempDir = await Directory.systemTemp.createTemp();
      tempFile = File(p.join(tempDir.path, 'video.mp4'));
      await tempFile.writeAsString('dummy video data');

      mockDio = _MockDio();
    });

    tearDown(() async {
      if (await tempFile.parent.exists()) {
        await tempFile.parent.delete(recursive: true);
      }
    });

    test('should throw if file does not exist', () async {
      final nonExistentFile = File('non_existent.mp4');
      expect(() => uploadVideoToGradio(nonExistentFile), throwsA(isA<UploadException>()));
    });

    test('should upload video and return Gradio path', () async {
      when(() => mockDio.post<dynamic>(
            any<String>(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            data: ['gradio/cached/path.mp4'],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await uploadVideoToGradio(tempFile, dioClient: mockDio);
      expect(result, 'gradio/cached/path.mp4');
    });

    test('should throw on upload failure', () async {
      when(() => mockDio.post<dynamic>(
            any<String>(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            data: 'Error',
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ));

      expect(() => uploadVideoToGradio(tempFile, dioClient: mockDio), throwsA(isA<UploadException>()));
    });

    test('should throw if response is not a list', () async {
      when(() => mockDio.post<dynamic>(
            any<String>(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response<dynamic>(
            data: {'error': 'bad response'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      expect(() => uploadVideoToGradio(tempFile, dioClient: mockDio), throwsA(isA<UploadException>()));
    });

    test('should handle cancellation', () async {
      final cancelToken = CancelToken();

      when(() => mockDio.post<dynamic>(
            any<String>(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      ));

      expect(() => uploadVideoToGradio(tempFile, dioClient: mockDio, cancelToken: cancelToken),
          throwsA(isA<DioException>()));
    });

    test('should report upload progress', () async {
      double? reportedProgress;

      when(() => mockDio.post<dynamic>(
            any<String>(),
            data: any(named: 'data'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer((invocation) async {
        final onSendProgress = invocation.namedArguments[#onSendProgress] as void Function(int, int)?;
        onSendProgress?.call(50, 100);
        return Response<dynamic>(
          data: ['gradio/path.mp4'],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
      });

      await uploadVideoToGradio(
        tempFile,
        dioClient: mockDio,
        onProgress: (p) => reportedProgress = p,
      );

      expect(reportedProgress, 0.5);
    });

    group('UploadException', () {
      test('toString returns expected message', () {
        final e = UploadException('test', statusCode: 404);
        expect(e.toString(), contains('test'));
        expect(e.toString(), contains('404'));
      });
    });
  });
}
