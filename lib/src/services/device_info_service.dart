import 'package:flutter/services.dart';

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel(
    'br.dev.yago.climapp/device',
  );

  /// Retorna o código ISO do país do aparelho (ex.: "BR"), vindo do código
  /// nativo (Android: SIM/locale | iOS: região do aparelho).
  /// Retorna string vazia se não for possível identificar.
  Future<String> getDeviceCountry() async {
    try {
      final String? countryCode = await _channel.invokeMethod(
        'getDeviceCountry',
      );
      final code = (countryCode ?? '').trim().toUpperCase();
      // Código de país válido tem exatamente 2 letras
      return RegExp(r'^[A-Z]{2}$').hasMatch(code) ? code : '';
    } on PlatformException {
      return '';
    } on MissingPluginException {
      // Plataforma sem o canal nativo implementado (ex.: web/desktop)
      return '';
    }
  }

  /// Converte o código ISO (ex.: "BR") no emoji da bandeira (🇧🇷).
  static String flagEmoji(String countryCode) {
    if (countryCode.length != 2) return '🌎';
    const base = 0x1F1E6 - 0x41; // 'A' -> 🇦
    return String.fromCharCodes(
      countryCode.toUpperCase().codeUnits.map((c) => base + c),
    );
  }

  /// Nome do país em português para os códigos mais comuns.
  /// Se não estiver na lista, mostra o próprio código.
  static String countryName(String countryCode) {
    const names = {
      'BR': 'Brasil',
      'US': 'Estados Unidos',
      'PT': 'Portugal',
      'AR': 'Argentina',
      'UY': 'Uruguai',
      'PY': 'Paraguai',
      'CL': 'Chile',
      'BO': 'Bolívia',
      'PE': 'Peru',
      'CO': 'Colômbia',
      'VE': 'Venezuela',
      'MX': 'México',
      'CA': 'Canadá',
      'GB': 'Reino Unido',
      'ES': 'Espanha',
      'FR': 'França',
      'DE': 'Alemanha',
      'IT': 'Itália',
      'JP': 'Japão',
      'CN': 'China',
    };
    if (countryCode.isEmpty) return 'País não identificado';
    return names[countryCode] ?? countryCode;
  }
}
