import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio; // To make http requests

  ApiClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(minutes: 10),
            headers: const {
              'Content-Type': 'application/json',
            },
          ),
        );
}
