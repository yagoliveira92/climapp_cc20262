import 'dart:async';
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
      final url = '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 5), // Se demorar mais de 5 segundos, dá erro
        onTimeout: () {
          throw TimeoutException('Deu ruim na internet, vá botar crédito seu pobre');
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['results'] == null) {
          throw Exception('Cidade não encontrada ou chave de API inválida.');
        }

        final jsonDecoded = jsonResponse['results'];
        final model = WeatherForecastModel.fromJson(jsonDecoded);
        listCity.add(model);
      } else {
        throw Exception('Erro ao carregar dados: ${response.statusCode}');
      }
    }
    return listCity;
  }
}