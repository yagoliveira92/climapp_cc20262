import 'dart:async';
import 'dart:io';

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
  String errorMessage = '';

  /// true quando o erro foi falta de conexão com a internet
  bool isOffline = false;

  /// true quando houve qualquer erro ao carregar (offline ou não)
  bool get hasError => isOffline || errorMessage.isNotEmpty;

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];
  Future<void> loadCities() async {
    isLoading = true;
    isOffline = false;
    errorMessage = '';
    notifyListeners();

    // Identifica o país do aparelho (não depende de internet)
    _deviceCountry = await deviceInfoService.getDeviceCountry();

    try {
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on SocketException catch (e) {
      // Sem internet (sem Wi-Fi/dados ou DNS não resolve)
      debugPrint('Sem conexão: $e');
      isOffline = true;
    } on http.ClientException catch (e) {
      // O pacote http também lança ClientException quando está offline
      debugPrint('Falha de conexão: $e');
      isOffline = true;
    } on TimeoutException catch (e) {
      // Demorou demais para responder: geralmente internet ruim/ausente
      debugPrint('Timeout: ${e.message}');
      isOffline = true;
    } on HttpException catch (e) {
      debugPrint('====================================');
      errorMessage = e.message;
      debugPrint(errorMessage);
      debugPrint('====================================');
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      errorMessage =
          'Algo deu errado ao buscar a previsão. Tente novamente em alguns instantes.';
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
