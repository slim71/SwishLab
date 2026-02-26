import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swish_lab/api/api_client.dart';
import 'package:swish_lab/api/endpoint_address_api.dart';
import 'package:swish_lab/constants.dart';

/// Makes APIs available in the whole app

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: hfSpace,
  );
});

final endpointAddressApiProvider = Provider<EndpointAddressApi>((ref) {
  return EndpointAddressApi(ref.read(apiClientProvider));
});
