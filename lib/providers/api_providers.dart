import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/endpoint_address_api.dart';
import '../constants.dart';

/// Makes APIs available in the whole app

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: hfSpace,
  );
});

final endpointAddressApiProvider = Provider<EndpointAddressApi>((ref) {
  return EndpointAddressApi(ref.read(apiClientProvider));
});
