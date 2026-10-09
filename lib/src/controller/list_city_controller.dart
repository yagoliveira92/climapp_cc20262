import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:climapp_cc20262/src/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool isOffline = false;
  String errorMessage = '';

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];
  static const _offlineMessage =
      'Você está sem conexão com a internet. Verifique sua rede e tente novamente.';

  Future<void> loadCities() async {
    isLoading = true;
    isOffline = false;
    errorMessage = '';
    notifyListeners();

    _deviceCountry = await deviceInfoService.getDeviceCountry();

    try {
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on TimeoutException {
      _setOffline();
    } on SocketException {
      _setOffline();
    } on HttpException catch (e) {
      debugPrint('====================================');
      errorMessage = e.message;
      debugPrint(errorMessage);
      debugPrint('====================================');
    } catch (e) {
      if (_isConnectionError(e)) {
        _setOffline();
      } else {
        print(e);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _setOffline() {
    isOffline = true;
    errorMessage = _offlineMessage;
  }

  bool _isConnectionError(Object e) {
    final text = e.toString().toLowerCase();
    return text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('clientexception') ||
        text.contains('network is unreachable');
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
