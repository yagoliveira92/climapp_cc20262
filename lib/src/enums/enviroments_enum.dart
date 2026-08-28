enum EnviromentEnum {
  constants(
    API_BASE_URL: 'https://api.hgbrasil.com/weather',
    API_KEY: String.fromEnvironment('API_KEY'),
    IMAGE_URL: 'https://assets.hgbrasil.com/weather/icons/conditions/',
    MOON_PHASE_URL: 'https://assets.hgbrasil.com/weather/icons/moon/',
  );

  final String API_BASE_URL;
  final String API_KEY;
  final String IMAGE_URL;
  final String MOON_PHASE_URL;

  const EnviromentEnum({
    required this.API_BASE_URL,
    required this.API_KEY,
    required this.IMAGE_URL,
    required this.MOON_PHASE_URL,
  });
}
