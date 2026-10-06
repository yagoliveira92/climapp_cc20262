import 'dart:io'; // Necessário para acessar o Platform.localeName NÃO MEECHEE
import 'package:flutter/services.dart';

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel(
    'br.dev.yago.climapp/device',
  );

  Future<String> getDeviceCountry() async {
    try {
      final String? countryCode = await _channel.invokeMethod(
        'getDeviceCountry',
      );
      return countryCode ?? "Deu Ruim";
    } on PlatformException {
      return "Deu Ruim";
    }
  }

  // Isso é oque pega a sigla do país (ex: BR, PT)
  String getCountryCode() {
    try {
      String locale = Platform.localeName;
      if (locale.contains('_')) {
        return locale.split('_').last;
      }
      return locale;
    } catch (e) {
      return 'BR';
    }
  }

  String getFlagEmoji(String countryCode) {
    if (countryCode.length != 2) return '🌍';

    int firstLetter = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    int secondLetter = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;

    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}