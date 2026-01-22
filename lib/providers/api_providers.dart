import 'package:SwishLab/api/api_client.dart';
import 'package:SwishLab/api/endpoint_address_api.dart';
import 'package:SwishLab/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Makes APIs available in the whole app

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: hfSpace,
  );
});

final endpointAddressApiProvider = Provider<EndpointAddressApi>((ref) {
  return EndpointAddressApi(ref.read(apiClientProvider));
});
