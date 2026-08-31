import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/functions/upload_video_to_gradio.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(const Stream<List<int>>.empty());
    registerFallbackValue(_FakeBaseRequest());
  });

  group('uploadVideoToGradio', () {
    late File mockFile;

    setUp(() {
      mockFile = _MockFile();
      when(() => mockFile.path).thenReturn('/path/to/video.mp4');
    });

    test('should throw if file does not exist', () async {
      when(() => mockFile.exists()).thenAnswer((_) async => false);
      expect(() => uploadVideoToGradio(mockFile), throwsA(isA<UploadException>()));
    });

    test('should upload video and return Gradio path', () async {
      when(() => mockFile.exists()).thenAnswer((_) async => true);
      when(() => mockFile.readAsBytes()).thenAnswer((_) async => utf8.encode('video data'));
      when(() => mockFile.path).thenReturn('/path/to/video.mp4');

      final mockResponse = json.encode(['gradio/cached/path.mp4']);
      final client = MockClient((request) async {
        return http.Response(mockResponse, 200);
      });

      final result = await uploadVideoToGradio(mockFile, client: client);
      expect(result, 'gradio/cached/path.mp4');
    });

    test('should throw on upload failure', () async {
      when(() => mockFile.exists()).thenAnswer((_) async => true);
      when(() => mockFile.readAsBytes()).thenAnswer((_) async => utf8.encode('video data'));

      final client = MockClient((request) async {
        return http.Response('Error', 500);
      });

      expect(() => uploadVideoToGradio(mockFile, client: client), throwsA(isA<UploadException>()));
    });

    test('should throw if response is not a list', () async {
      when(() => mockFile.exists()).thenAnswer((_) async => true);
      when(() => mockFile.readAsBytes()).thenAnswer((_) async => utf8.encode('video data'));

      final client = MockClient((request) async {
        return http.Response(json.encode({'error': 'bad response'}), 200);
      });

      expect(() => uploadVideoToGradio(mockFile, client: client), throwsA(isA<UploadException>()));
    });

    test('should throw if response list is empty', () async {
      when(() => mockFile.exists()).thenAnswer((_) async => true);
      when(() => mockFile.readAsBytes()).thenAnswer((_) async => utf8.encode('video data'));

      final client = MockClient((request) async {
        return http.Response(json.encode([]), 200);
      });

      expect(() => uploadVideoToGradio(mockFile, client: client), throwsA(isA<UploadException>()));
    });

    test('should cover client null branch (using factory and finally close)', () async {
      when(() => mockFile.exists()).thenAnswer((_) async => true);
      when(() => mockFile.readAsBytes()).thenAnswer((_) async => utf8.encode('video data'));
      when(() => mockFile.path).thenReturn('/path/to/video.mp4');

      final mockHttpClient = _MockHttpClient();
      httpClientFactory = () => mockHttpClient;

      when(() => mockHttpClient.send(any<http.BaseRequest>())).thenAnswer((invocation) async {
        return http.StreamedResponse(
          Stream.value(utf8.encode(json.encode(['gradio/path.mp4']))),
          200,
        );
      });
      when(() => mockHttpClient.close()).thenReturn(null);

      final result = await uploadVideoToGradio(mockFile);
      expect(result, 'gradio/path.mp4');
      verify(() => mockHttpClient.close()).called(1);

      // Reset factory
      httpClientFactory = () => http.Client();
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

class _MockFile extends Mock implements File {}

class _MockHttpClient extends Mock implements http.Client {}

class _FakeBaseRequest extends Fake implements http.BaseRequest {}
