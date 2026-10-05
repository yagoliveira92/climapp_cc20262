class ForecastItemModel {
  final String date;
  final String weekday;
  final int min;
  final int max;
  final String moonPhase;

  ForecastItemModel({
    required this.date,
    required this.weekday,
    required this.min,
    required this.max,
    required this.moonPhase,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    return ForecastItemModel(
      date: json['date'] ?? '',
      weekday: json['weekday'] ?? '',
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      moonPhase: json['moon_phase'] ?? 'new',
    );
  }
}

class WeatherForecastModel {
  final String cityName;
  final String country;
  final String temp;
  final String date;
  final String time;
  final String description;
  final String currently;
  final String humidity;
  final String windSpeedy;
  final String conditionSlug;
  final List<ForecastItemModel> forecast;

  WeatherForecastModel({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.date,
    required this.time,
    required this.description,
    required this.currently,
    required this.humidity,
    required this.windSpeedy,
    required this.conditionSlug,
    required this.forecast,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    var forecastList = json['forecast'] as List? ?? [];
    List<ForecastItemModel> parsedForecast = forecastList
        .map((item) => ForecastItemModel.fromJson(item))
        .toList();

    return WeatherForecastModel(
      cityName: json['city_name'] ?? json['city'] ?? 'Cidade Desconhecida',
      country: json['country'] ?? 'Brasil',
      temp: '${json['temp'] ?? 0}',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? 'Sem descrição',
      currently: json['currently'] ?? 'dia',
      humidity: '${json['humidity'] ?? 0}%',
      windSpeedy: json['wind_speedy'] ?? '0 km/h',
      conditionSlug: json['condition_slug'] ?? 'cloud',
      forecast: parsedForecast,
    );
  }
}
