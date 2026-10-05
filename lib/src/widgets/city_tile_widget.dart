import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityTileWidget extends StatelessWidget {
  final String cityName;
  final String icon;
  final int temperature;
  final String countryCode; // Adicionado para receber o país
  final VoidCallback onTap;

  const CityTileWidget({
    super.key,
    required this.cityName,
    required this.icon,
    required this.temperature,
    this.countryCode = 'BR',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SvgPicture.network(
          'https://assets.hgbrasil.com/weather/icons/conditions/$icon.svg',
          width: 42,
          height: 42,
          placeholderBuilder: (context) => const SizedBox(
            width: 42,
            height: 42,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          cityName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              "País: $countryCode",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        trailing: Text(
          '$temperature°C',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
