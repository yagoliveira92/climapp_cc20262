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
      if (countryCode == null || countryCode.isEmpty) return "Unknown" ;
      return countryCode;
    } on PlatformException {
      return "Unknown";
    }
  }
}
