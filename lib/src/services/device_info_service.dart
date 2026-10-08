import 'package:flutter/services.dart';

import 'dart:ui' show PlatformDispatcher;

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel(
    'br.dev.yago.climapp/device',
  );

  Future<String> getDeviceCountry() async {
    try {
      final String? countryCode = await _channel.invokeMethod(
        'getDeviceCountry',
      );
      if (countryCode != null && countryCode.isNotEmpty) {
        return countryCode.toUpperCase();
      }
      return _localeCountryCode;
    } on PlatformException {
      return _localeCountryCode;
    }
  }

  String get _localeCountryCode =>
      PlatformDispatcher.instance.locale.countryCode?.toUpperCase() ?? '';
}
