class CountryHelper {

  static const Map<String, String> _names = {
    'BR': 'Brasil',
    'US': 'Estados Unidos',
    'PT': 'Portugal',
    'AR': 'Argentina',
    'UY': 'Uruguai',
    'PY': 'Paraguai',
    'CL': 'Chile',
    'CO': 'Colômbia',
    'PE': 'Peru',
    'BO': 'Bolívia',
    'VE': 'Venezuela',
    'EC': 'Equador',
    'MX': 'México',
    'CA': 'Canadá',
    'GB': 'Reino Unido',
    'IE': 'Irlanda',
    'FR': 'França',
    'DE': 'Alemanha',
    'IT': 'Itália',
    'ES': 'Espanha',
    'NL': 'Países Baixos',
    'JP': 'Japão',
    'CN': 'China',
    'KR': 'Coreia do Sul',
    'IN': 'Índia',
    'AU': 'Austrália',
    'AO': 'Angola',
    'MZ': 'Moçambique',
  };

  static const String unknownLabel = 'Unknown';

  static bool _isValid(String? code) =>
      RegExp(r'^[A-Za-z]{2}$').hasMatch(code?.trim() ?? '');

  static String format(String? code) {
    if (!_isValid(code)) return unknownLabel;
    final normalized = code!.trim().toUpperCase();
    return '${flag(normalized)} ${_names[normalized] ?? normalized}';
  }

  /// Cada letra A-Z vira o "símbolo regional" Unicode correspondente;
  /// duas delas juntas formam a bandeira.
  static String flag(String code) {
    const offset = 0x1F1E6 - 0x41; // 0x41 é a letra 'A'
    return String.fromCharCodes(code.codeUnits.map((unit) => unit + offset));
  }

}