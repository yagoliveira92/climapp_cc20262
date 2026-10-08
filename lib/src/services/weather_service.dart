import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  WeatherService({http.Client Function()? clientFactory})
    : _clientFactory = clientFactory ?? http.Client.new;

  static const Duration requestTimeout = Duration(seconds: 5);
  final http.Client Function() _clientFactory;
  Future<List<WeatherForecastModel>> getWeatherForecast(
    List<String> listCitySearch,
  ) async {
    final enumEnv = EnviromentEnum.constants;
    final List<WeatherForecastModel> listCity = [];
    final client = _clientFactory();

    try {
      for (var city in listCitySearch) {
        final uri =
            '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city';
        final response = await client
            .get(Uri.parse(uri))
            .timeout(requestTimeout);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final jsonDecoded = jsonDecode(response.body)['results'];
          final model = WeatherForecastModel.fromJson(jsonDecoded);
          listCity.add(model);
        } else {
          throw WeatherApiException(response.statusCode);
        }
      }
    } finally {
      client.close();
    }

    return listCity;
  }
}

class WeatherApiException extends HttpException {
  WeatherApiException(this.statusCode)
    : super('A API respondeu com HTTP $statusCode.');

  final int statusCode;
}
