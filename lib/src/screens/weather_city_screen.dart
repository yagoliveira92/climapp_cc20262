import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherCityScreen extends StatefulWidget {
  const WeatherCityScreen({required this.weatherForecastModel, super.key});

  final WeatherForecastModel weatherForecastModel;

  @override
  State<WeatherCityScreen> createState() => _WeatherCityScreenState();
}

class _WeatherCityScreenState extends State<WeatherCityScreen> {
  EnviromentEnum envEnum = EnviromentEnum.constants;
  final CarouselController _controller = CarouselController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Placeholder exibido quando uma imagem remota não carrega (ex.: offline).
  Widget _imageFallback({double size = 64}) {
    return SizedBox(
      height: size,
      child: Center(
        child: Icon(Icons.cloud_off, size: size * 0.6, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.weatherForecastModel;
    final hasForecast = model.forecast.isNotEmpty;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF05051F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00457D),
        centerTitle: true,
        title: Text(
          model.cityName,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF00457D), Color(0xFF05051F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF4463D5),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Hoje: ${model.date}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.network(
                      '${envEnum.IMAGE_URL}${model.conditionSlug}.svg',
                      placeholderBuilder: (_) => const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorBuilder: (_, _, _) => _imageFallback(size: 100),
                    ),
                    Text(
                      '${model.temp}°',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.description,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.thermostat,
                          color: Colors.redAccent,
                          size: 33,
                        ),
                        const Text(
                          'Min/Max:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            hasForecast
                                ? '${model.forecast[0].min}°/${model.forecast[0].max}°'
                                : '--',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 21),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (hasForecast)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: CarouselView(
                    controller: _controller,
                    itemExtent: 200,
                    shrinkExtent: 200,
                    children: List<Widget>.generate(
                      model.forecast.length,
                          (int index) => Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF05051F).withValues(alpha: 0.85),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.forecast[index].weekday,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '(${model.forecast[index].date})',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Image.network(
                                '${envEnum.MOON_PHASE_URL}${model.forecast[index].moonPhase}.png',
                                height: 60,
                                errorBuilder: (_, _, _) =>
                                    _imageFallback(size: 60),
                              ),
                            ),
                            Text(
                              '${model.forecast[index].min}/${model.forecast[index].max}°',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}