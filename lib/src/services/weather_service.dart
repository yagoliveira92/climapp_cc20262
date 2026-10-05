import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      try {
        final uri =
            '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city';

        final response = await http
            .get(Uri.parse(uri))
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException(
                  "A conexão demorou muito para responder.",
                );
              },
            );

        if (response.statusCode == 200) {
          final jsonDecoded = jsonDecode(response.body)['results'];
          final model = WeatherForecastModel.fromJson(jsonDecoded);
          listCity.add(model);
        } else {
          throw HttpException(
            'Falha na resposta do servidor HGBrasil. Código: ${response.statusCode}',
          );
        }
      } on SocketException {
        throw const HttpException('Sem conexão com a internet.');
      } on http.ClientException {
        throw const HttpException('Sem conexão com a internet.');
      }
    }
    return listCity;
  }
}
