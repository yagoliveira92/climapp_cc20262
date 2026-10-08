import 'package:climapp_cc20262/src/controller/list_city_controller.dart';
import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:climapp_cc20262/src/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('shows a temporary service error when the API returns 503', () async {
    final weatherService = WeatherService(
      clientFactory: () =>
          MockClient((request) async => http.Response('', 503)),
    );
    final controller = ListCityController(
      deviceInfoService: _FakeDeviceInfoService(),
      weatherService: weatherService,
    );
    addTearDown(controller.dispose);

    await controller.loadCities();

    expect(controller.errorTitle, 'Serviço temporariamente indisponível');
    expect(controller.errorMessage, contains('HTTP 503'));
    expect(controller.isLoading, isFalse);
  });
}

class _FakeDeviceInfoService extends DeviceInfoService {
  @override
  Future<String> getDeviceCountry() async => 'BR';
}
