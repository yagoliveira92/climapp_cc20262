import 'package:climapp_cc20262/src/controller/list_city_controller.dart';
import 'package:climapp_cc20262/src/screens/weather_city_screen.dart';
import 'package:climapp_cc20262/src/widgets/city_tile_widget.dart';
import 'package:climapp_cc20262/src/widgets/nointernet_widget.dart';
import 'package:flutter/material.dart';

class ListCityScreen extends StatefulWidget {
  const ListCityScreen({super.key});

  @override
  State<ListCityScreen> createState() => _ListCityScreenState();
}

class _ListCityScreenState extends State<ListCityScreen> {
  final TextEditingController textController = TextEditingController();

  final ListCityController controller = ListCityController();

  @override
  void initState() {
    super.initState();
    controller.startMonitoring();
    controller.loadCities();
  }

  @override
  void dispose() {
    textController.dispose();
    controller.dispose();
    super.dispose();
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
        child: SafeArea(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              // Tela de erro ocupa a página inteira (sem campo de busca).
              if (controller.status == LoadStatus.noInternet) {
                return NoInternetWidget(onRetry: controller.loadCities);
              }
              if (controller.status == LoadStatus.error) {
                return GenericErrorWidget(
                  message: controller.errorMessage,
                  onRetry: controller.loadCities,
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 9),
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
                    const SizedBox(height: 15),
                    Expanded(child: _buildList()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.filteredCities.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma cidade encontrada',
          style: TextStyle(color: Colors.white70, fontSize: 16),
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
}