import 'dart:async';
import 'dart:io';

import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:climapp_cc20262/src/services/weather_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ListCityController extends ChangeNotifier {
  ListCityController({
    required this.deviceInfoService,
    required this.weatherService,
  }) {
    _initConnectivityListener();
  }

  final WeatherService weatherService;
  final DeviceInfoService deviceInfoService;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  String _deviceCountry = '';
  String get deviceCountry => _deviceCountry;
  List<WeatherForecastModel> allCities = [];
  List<WeatherForecastModel> filteredCities = [];
  bool isLoading = true;
  String errorMessage = '';

  bool get hasError => errorMessage.isNotEmpty;

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];

  // Monitora a rede em tempo real
  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        // Sem internet
        errorMessage = 'Sua conexão com a internet caiu!';
        isLoading = false;
        notifyListeners();
      } else {
        // Conexão reestabelecida
        if (hasError || allCities.isEmpty) {
          loadCities();
        }
      }
    });
  }

  Future<void> loadCities() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      _deviceCountry = await deviceInfoService.getDeviceCountry();
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on TimeoutException catch (e) {
      errorMessage = e.message ?? 'A conexão demorou muito para responder.';
    } on HttpException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Sem conexão com a internet.';
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

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
