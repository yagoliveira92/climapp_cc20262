import 'package:climapp_cc20262/src/controller/list_city_controller.dart';
import 'package:climapp_cc20262/src/screens/weather_city_screen.dart';
import 'package:climapp_cc20262/src/widgets/city_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCityScreen extends StatefulWidget {
  const ListCityScreen({super.key});

  @override
  State<ListCityScreen> createState() => _ListCityScreenState();
}

class _ListCityScreenState extends State<ListCityScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Widget _buildContent(BuildContext context, ListCityController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.isOffline) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 64),
              const SizedBox(height: 20),
              const Text(
                'Você está offline',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                controller.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: controller.loadCities,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7693FF),
                ),
                child: const Text(
                  'Tentar novamente',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: controller.filteredCities.length,
      itemBuilder: (context, index) {
        final city = controller.filteredCities[index];
        return CityTileWidget(
          cityName: city.cityName,
          icon: city.conditionSlug,
          temperature: city.temp,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WeatherCityScreen(weatherForecastModel: city),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Consumer<ListCityController>(
            builder: (context, controller, child) {
              final country = controller.deviceCountry;
              final showCountry =
                  country.isNotEmpty && country != 'Deu Ruim';

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 25),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: textController,
                    onChanged: controller.filterCities,
                    decoration: const InputDecoration(
                      fillColor: Color(0x15FFFFFF),
                      filled: true,
                      hintText: 'Digite uma cidade',
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                  if (showCountry) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'País: $country',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  Expanded(child: _buildContent(context, controller)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
