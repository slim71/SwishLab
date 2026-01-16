import 'package:SwishLab/api/api_client.dart';
import 'package:SwishLab/api/endpoint_address_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Makes APIs available in the whole app

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: 'https://7d195f4ad35ebcfc3d.gradio.live', // TODO: change
  );
});

final endpointAddressApiProvider = Provider<EndpointAddressApi>((ref) {
  return EndpointAddressApi(ref.read(apiClientProvider));
});
