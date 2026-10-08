import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnviromentEnum {
  constants(
    API_BASE_URL: 'https://api.hgbrasil.com/weather',
    IMAGE_URL: 'https://assets.hgbrasil.com/weather/icons/conditions/',
    MOON_PHASE_URL: 'https://assets.hgbrasil.com/weather/icons/moon/',
  );

  final String API_BASE_URL;
  final String IMAGE_URL;
  final String MOON_PHASE_URL;

  /// Lida do arquivo .env (API_KEY=sua_chave) em tempo de execução.
  /// Exige que dotenv.load() tenha sido chamado no main().
  String get API_KEY => dotenv.maybeGet('API_KEY') ?? '';

  const EnviromentEnum({
    required this.API_BASE_URL,
    required this.IMAGE_URL,
    required this.MOON_PHASE_URL,
  });
}