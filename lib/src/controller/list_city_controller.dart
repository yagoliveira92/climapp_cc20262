import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum LoadStatus { loading, success, noInternet, error }

class ListCityController extends ChangeNotifier {
  List<WeatherForecastModel> allCities = [];
  List<WeatherForecastModel> filteredCities = [];

  LoadStatus status = LoadStatus.loading;
  String? errorMessage;

  bool get isLoading => status == LoadStatus.loading;

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];

  static const _requestTimeout = Duration(seconds: 10);

  String _query = '';
  bool _requesting = false;
  bool _disposed = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  void startMonitoring() {
    _connectivitySub ??= Connectivity().onConnectivityChanged.listen((
        results,
        ) {
      final online = !results.contains(ConnectivityResult.none);
      if (online && status == LoadStatus.noInternet) {
        loadCities();
      }
    });
  }

  Future<bool> _isOffline() async {
    final results = await Connectivity().checkConnectivity();
    return results.contains(ConnectivityResult.none);
  }

  Future<void> loadCities() async {
    if (_requesting) return;
    _requesting = true;

    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      if (await _isOffline()) {
        status = LoadStatus.noInternet;
        return;
      }

      allCities = await getWeatherForecast();
      _applyFilter();
      status = LoadStatus.success;
    } on SocketException {
      status = LoadStatus.noInternet;
    } on TimeoutException {
      status = LoadStatus.noInternet;
    } on http.ClientException {
      status = LoadStatus.noInternet;
    } catch (e) {
      debugPrint('Erro ao carregar cidades: $e');
      errorMessage = e.toString();
      status = LoadStatus.error;
    } finally {
      _requesting = false;
      notifyListeners();
    }
  }

  void filterCities(String query) {
    _query = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      filteredCities = List.from(allCities);
    } else {
      final q = _query.toLowerCase();
      filteredCities = allCities
          .where((city) => city.cityName.toLowerCase().contains(q))
          .toList();
    }
  }

  Future<List<WeatherForecastModel>> getWeatherForecast() async {
    final enumEnv = EnviromentEnum.constants;

    if (enumEnv.API_KEY.isEmpty) {
      throw Exception(
        'API_KEY não informada. Rode com --dart-define=API_KEY=sua_chave',
      );
    }

    final List<WeatherForecastModel> listCity = [];

    for (final city in listCitySearch) {
      final uri = Uri.parse(enumEnv.API_BASE_URL).replace(
        queryParameters: {'key': enumEnv.API_KEY, 'city_name': city},
      );

      final response = await http.get(uri).timeout(_requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        if (body['valid_key'] == false) {
          throw Exception('Chave da API HG Brasil inválida');
        }
        final results = body['results'];
        if (results == null) {
          throw Exception('Resposta da API sem dados para $city');
        }
        listCity.add(WeatherForecastModel.fromJson(results));
      } else {
        throw Exception('Erro ao carregar dados (HTTP ${response.statusCode})');
      }
    }
    return listCity;
  }

  @override
  void notifyListeners() {
    // Evita erro se a requisição terminar depois do dispose da tela.
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _connectivitySub?.cancel();
    super.dispose();
  }
}