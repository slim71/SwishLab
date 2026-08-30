import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../api/endpoint_address_api.dart';
import '../constants.dart';

/// Makes APIs available in the whole app

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    baseUrl: hfSpace,
  );
  ref.onDispose(client.dio.close);
  return client;
});

final endpointAddressApiProvider = Provider<EndpointAddressApi>((ref) {
  return EndpointAddressApi(ref.read(apiClientProvider));
});

final reachabilityPollingIntervalProvider = Provider<Duration>((ref) {
  return const Duration(seconds: 5);
});
