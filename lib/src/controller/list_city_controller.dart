import 'dart:async';
import 'dart:io';

import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:climapp_cc20262/src/services/weather_service.dart';
import 'package:flutter/material.dart';

class ListCityController extends ChangeNotifier {
  ListCityController({
    required this.deviceInfoService,
    required this.weatherService,
  });

  final WeatherService weatherService;
  final DeviceInfoService deviceInfoService;

  String _deviceCountry = '';
  String get deviceCountry => _deviceCountry;
  List<WeatherForecastModel> allCities = [];
  List<WeatherForecastModel> filteredCities = [];
  bool isLoading = true;
  String errorMessage = '';
  String errorTitle = '';
  bool isConnectionError = false;

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Carapicuíba,SP',
    'Curitiba,PR',
  ];
  Future<void> loadCities() async {
    isLoading = true;
    errorMessage = '';
    errorTitle = '';
    isConnectionError = false;
    notifyListeners();

    try {
      _deviceCountry = await deviceInfoService.getDeviceCountry();
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on TimeoutException {
      errorTitle = 'A conexão demorou';
      errorMessage = 'O serviço não respondeu em até 5 segundos. Verifique sua conexão e tente novamente.';
      isConnectionError = true;
    } on SocketException {
      errorTitle = 'Deu ruim na conexão';
      errorMessage = 'Não foi possível alcançar a rede. Tente novamente quando estiver conectado a alguma rede.';
      isConnectionError = true;
    } on WeatherApiException catch (e) {
      if (e.statusCode >= 400 && e.statusCode < 500) {
        errorTitle = 'Solicitação recusada';
        errorMessage =
            'A API recusou os dados enviados (HTTP ${e.statusCode}).';
      } else if (e.statusCode >= 500 && e.statusCode < 600) {
        errorTitle = 'Serviço temporariamente indisponível';
        errorMessage =
            'A API está instável no momento (HTTP ${e.statusCode}). Tente novamente em instantes.';
      } else {
        errorTitle = 'Resposta inesperada';
        errorMessage = 'A API respondeu com o código HTTP ${e.statusCode}.';
      }
    } on HttpException catch (e) {
      errorTitle = 'Falha ao carregar os dados';
      errorMessage = e.message;
    } catch (e) {
      errorTitle = 'Falha ao carregar os dados';
      errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      debugPrint('Erro ao carregar cidades: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities = List.from(allCities);
    } else {
      filteredCities = allCities
          .where(
            (city) => city.cityName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
