import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/api/api_client.dart';
import 'package:swish_lab/api/endpoint_address_api.dart';
import 'package:swish_lab/providers/api_providers.dart';
import 'package:http/http.dart' as http;

void main() {
  test('httpClientProvider returns http.Client instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final client = container.read(httpClientProvider);
    expect(client, isA<http.Client>());
  });

  test('apiClientProvider returns ApiClient instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final apiClient = container.read(apiClientProvider);
    expect(apiClient, isA<ApiClient>());
  });

  test('endpointAddressApiProvider returns EndpointAddressApi instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final api = container.read(endpointAddressApiProvider);
    expect(api, isA<EndpointAddressApi>());
  });

  test('reachabilityPollingIntervalProvider returns default duration', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final interval = container.read(reachabilityPollingIntervalProvider);
    expect(interval, const Duration(seconds: 5));
  });
}
