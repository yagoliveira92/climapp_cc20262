import 'dart:convert';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<List<WeatherForecastModel>> getWeatherForecast(
    List<String> listCitySearch,
  ) async {
    final enumEnv = EnviromentEnum.constants;
    final List<WeatherForecastModel> listCity = [];

    for (var city in listCitySearch) {
      final response = await http.get(
        Uri.parse(
          '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city',
        ),
      );
      if (response.statusCode >= 200 || response.statusCode < 300) {
        final jsonDecoded = jsonDecode(response.body)['results'];
        final model = WeatherForecastModel.fromJson(jsonDecoded);
        listCity.add(model);
      } else {
        throw Exception('Erro ao carregar dados');
      }
    }
    return listCity;
  }
}
