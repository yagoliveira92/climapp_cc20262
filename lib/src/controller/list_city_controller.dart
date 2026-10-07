import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:climapp_cc20262/src/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:climapp_cc20262/src/utils/country_helper.dart';
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
  String get deviceCountryLabel => CountryHelper.format(_deviceCountry);
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

    _deviceCountry = await deviceInfoService.getDeviceCountry();

    try {
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on TimeoutException catch (e) {
      errorMessage =
          e.message ?? 'Deu ruim nas internet, vá botar crédito seu pobre';
    }  on HttpException {
      errorMessage = 'O serviço de clima não respondeu como esperado. Tente mais tarde.';
    } on SocketException {
      errorMessage = 'Você parece estar sem internet.';
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      errorMessage = 'Algo deu errado. Tente novamente.';
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

  Future<List<WeatherForecastModel>> getWeatherForecast() async {
    final enumEnv = EnviromentEnum.constants;
    final List<WeatherForecastModel> listCity = [];

    for (var city in listCitySearch) {
      final response = await http.get(
        Uri.parse(
          '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city',
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
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
