import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/api/api_client.dart';
import 'package:swish_lab/api/endpoint_address_api.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late MockDio dio;
  late EndpointAddressApi api;

  setUp(() {
    apiClient = MockApiClient();
    dio = MockDio();
    when(() => apiClient.dio).thenReturn(dio);
    when(() => dio.options).thenReturn(BaseOptions(baseUrl: 'https://test.com'));
    api = EndpointAddressApi(apiClient);
  });

  group('EndpointAddressApi', () {
    test('analyzeShootingForm success', () async {
      final responseData = {'event_id': '123'};
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await api.analyzeShootingForm(
        sourceVideo: 'video.mp4',
        shootingHand: 'right',
        pointOfView: 'front',
      );

      expect(result.eventId, equals('123'));
    });

    test('analyzeShootingForm handles 404 error', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      expect(
        () => api.analyzeShootingForm(
          sourceVideo: 'video.mp4',
          shootingHand: 'right',
          pointOfView: 'front',
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('getShootingFormResults returns a stream of lines', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(
        controller.stream,
        200,
      );

      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final stream = api.getShootingFormResults(hfEventId: '123');

      final resultFuture = stream.toList();
      controller.add(Uint8List.fromList(utf8.encode('line1\nline2\n')));
      controller.close();

      final results = await resultFuture;
      expect(results, equals(['line1', 'line2']));
    });

    test('getFinalAnalysisResult success with complete event', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(
        controller.stream,
        200,
      );

      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');

      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: {"analysis": {"score": 90}}\n\n')));
      controller.close();

      final result = await resultFuture;
      expect(result.analysis?['score'], equals(90));
    });

    test('getFinalAnalysisResult handles list data', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(
        controller.stream,
        200,
      );

      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');

      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: [{"score": 85}]\n\n')));
      controller.close();

      final result = await resultFuture;
      expect(result.raw['score'], equals(85));
    });

    test('getFinalAnalysisResult handles error event', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(
        controller.stream,
        200,
      );

      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');

      controller.add(Uint8List.fromList(utf8.encode('error: something went wrong\n\n')));
      controller.close();

      expect(resultFuture, throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Backend Error'))));
    });

    test('getFinalAnalysisResult throws if stream closes without complete', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(
        controller.stream,
        200,
      );

      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');
      controller.close();

      expect(
          resultFuture,
          throwsA(
              isA<Exception>().having((e) => e.toString(), 'message', contains('Stream closed without "complete"'))));
    });

    test('analyzeShootingForm handles generic DioException', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      expect(
        () => api.analyzeShootingForm(
          sourceVideo: 'video.mp4',
          shootingHand: 'right',
          pointOfView: 'front',
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('analyzeShootingForm handles 500 error', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      expect(
        () => api.analyzeShootingForm(
          sourceVideo: 'video.mp4',
          shootingHand: 'right',
          pointOfView: 'front',
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('getShootingFormResults handles null stream', () async {
      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final stream = api.getShootingFormResults(hfEventId: '123');
      final results = await stream.toList();
      expect(results, isEmpty);
    });

    test('getShootingFormResults handles DioException', () async {
      when(() => dio.get<ResponseBody>(
            any(),
            options: any(named: 'options'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      final stream = api.getShootingFormResults(hfEventId: '123');
      expect(() => stream.toList(), throwsA(isA<DioException>()));
    });

    test('getFinalAnalysisResult handles list with non-map element', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(controller.stream, 200);

      when(() => dio.get<ResponseBody>(any(), options: any(named: 'options'))).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');
      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: [123]\n\n')));
      controller.close();

      final result = await resultFuture;
      expect(result.raw['data'], equals([123]));
    });

    test('getFinalAnalysisResult handles empty list', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(controller.stream, 200);

      when(() => dio.get<ResponseBody>(any(), options: any(named: 'options'))).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');
      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: []\n\n')));
      controller.close();

      final result = await resultFuture;
      expect(result.raw['data'], isEmpty);
    });

    test('getFinalAnalysisResult handles primitive data', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(controller.stream, 200);

      when(() => dio.get<ResponseBody>(any(), options: any(named: 'options'))).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');
      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: "hello"\n\n')));
      controller.close();

      final result = await resultFuture;
      expect(result.raw['raw_data'], equals('hello'));
    });

    test('getFinalAnalysisResult handles multi-line data', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(controller.stream, 200);

      when(() => dio.get<ResponseBody>(any(), options: any(named: 'options'))).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');
      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: {"analysis": {"score": \ndata: 95}}\n\n')));
      controller.close();

      final result = await resultFuture;
      expect(result.analysis?['score'], equals(95));
    });

    test('getFinalAnalysisResult handles exception during stream processing', () async {
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(controller.stream, 200);

      when(() => dio.get<ResponseBody>(any(), options: any(named: 'options'))).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final resultFuture = api.getFinalAnalysisResult(hfEventId: '123');
      controller.add(Uint8List.fromList(utf8.encode('event: complete\ndata: invalid-json\n\n')));
      controller.close();

      expect(resultFuture, throwsA(anyOf(isA<FormatException>(), isA<TypeError>())));
    });

    test('analyzeShootingForm passes cancelToken to Dio', () async {
      final token = CancelToken();
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            cancelToken: token,
          )).thenAnswer((_) async => Response(
            data: {'event_id': '123'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      await api.analyzeShootingForm(
        sourceVideo: 'video.mp4',
        shootingHand: 'right',
        pointOfView: 'front',
        cancelToken: token,
      );

      verify(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            cancelToken: token,
          )).called(1);
    });

    test('getShootingFormResults passes cancelToken to Dio', () async {
      final token = CancelToken();
      final controller = StreamController<Uint8List>();
      final responseBody = ResponseBody(controller.stream, 200);

      when(() => dio.get<ResponseBody>(
            any(),
            cancelToken: token,
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: responseBody,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final stream = api.getShootingFormResults(hfEventId: '123', cancelToken: token);

      // Trigger the get call by listening to the stream
      stream.listen((_) {});

      controller.close();
      await Future<void>.delayed(Duration.zero);

      verify(() => dio.get<ResponseBody>(
            any(),
            cancelToken: token,
            options: any(named: 'options'),
          )).called(1);
    });
  });
}
