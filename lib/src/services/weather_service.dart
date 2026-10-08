import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:climapp_cc20262/src/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<List<WeatherForecastModel>> getWeatherForecast(
    List<String> listCitySearch,
  ) async {
    final enumEnv = EnviromentEnum.constants;
    final List<WeatherForecastModel> listCity = [];

    for (var city in listCitySearch) {
      final uri =
          '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city';
      try {
        final response = await http
            .get(Uri.parse(uri))
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException('Tempo limite ao consultar o clima.');
              },
            );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final jsonDecoded = jsonDecode(response.body)['results'];
          final model = WeatherForecastModel.fromJson(jsonDecoded);
          listCity.add(model);
        } else {
          throw HttpException(
            'Falha na API HG Brasil. Código: ${response.statusCode}',
          );
        }
      } catch (_) {
        _showRequestErrorSnackBar();
        rethrow;
      }
    }
    return listCity;
  }

  void _showRequestErrorSnackBar() {
    final context = NotificationService().navigatorKey.currentContext;
    if (context == null) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível carregar o clima. Verifique sua conexão e tente novamente.',
          ),
        ),
      );
  }
}
