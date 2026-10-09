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

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];
  Future<void> loadCities() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      _deviceCountry = await deviceInfoService.getDeviceCountry();
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on TimeoutException catch (e) {
      errorMessage =
          e.message ?? 'Deu ruim nas internet, vá botar crédito seu pobre';
    } on HttpException catch (e) {
      debugPrint('====================================');
      errorMessage = e.message;
      debugPrint(errorMessage);
      debugPrint('====================================');
    } on SocketException {
      
      errorMessage = 'Parece que você está sem conexão com a internet. Verifique sua rede Wi-Fi ou dados móveis e tente novamente.';
    } catch (e) {
      debugPrint('Erro não tratado: $e');
      
      errorMessage = 'Parece que você está sem conexão com a internet. Verifique sua rede Wi-Fi ou dados móveis e tente novamente.';
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
