import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:flutter/material.dart';

/// Selo que mostra em qual país o celular se encontra (bandeira + nome).
class CountryBadgeWidget extends StatelessWidget {
  const CountryBadgeWidget({required this.countryCode, super.key});

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x15FFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            DeviceInfoService.flagEmoji(countryCode),
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Você está em: ${DeviceInfoService.countryName(countryCode)}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
