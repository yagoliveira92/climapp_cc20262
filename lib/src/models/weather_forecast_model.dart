import 'forecast_model.dart';

class WeatherForecastModel {
  final int temp;
  final String date;
  final String time;
  final String conditionCode;
  final String description;
  final String currently;
  final String city;
  final String imgId;
  final int humidity;
  final double cloudiness;
  final double rain;
  final String windSpeedy;
  final int windDirection;
  final String windCardinal;
  final String sunrise;
  final String sunset;
  final String moonPhase;
  final String conditionSlug;
  final String cityName;
  final String timezone;
  final List<ForecastModel> forecast;

  WeatherForecastModel({
    required this.temp,
    required this.date,
    required this.time,
    required this.conditionCode,
    required this.description,
    required this.currently,
    required this.city,
    required this.imgId,
    required this.humidity,
    required this.cloudiness,
    required this.rain,
    required this.windSpeedy,
    required this.windDirection,
    required this.windCardinal,
    required this.sunrise,
    required this.sunset,
    required this.moonPhase,
    required this.conditionSlug,
    required this.cityName,
    required this.timezone,
    required this.forecast,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'date': date,
      'time': time,
      'condition_code': conditionCode,
      'description': description,
      'currently': currently,
      'city': city,
      'img_id': imgId,
      'humidity': humidity,
      'cloudiness': cloudiness,
      'rain': rain,
      'wind_speedy': windSpeedy,
      'wind_direction': windDirection,
      'wind_cardinal': windCardinal,
      'sunrise': sunrise,
      'sunset': sunset,
      'moon_phase': moonPhase,
      'condition_slug': conditionSlug,
      'city_name': cityName,
      'timezone': timezone,
      'forecast': forecast.map((item) => item.toMap()).toList(),
    };
  }

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      temp: json['temp'],
      date: json['date'],
      time: json['time'],
      conditionCode: json['condition_code'],
      description: json['description'],
      currently: json['currently'],
      city: json['city'],
      imgId: json['img_id'].toString(),
      humidity: json['humidity'],
      cloudiness: json['cloudiness'].toDouble(),
      rain: json['rain'].toDouble(),
      windSpeedy: json['wind_speedy'],
      windDirection: json['wind_direction'],
      windCardinal: json['wind_cardinal'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonPhase: json['moon_phase'],
      conditionSlug: json['condition_slug'],
      cityName: json['city_name'],
      timezone: json['timezone'],
      forecast: (json['forecast'] as List)
          .map((item) => ForecastModel.fromJson(item))
          .toList(),
    );
  }
}
