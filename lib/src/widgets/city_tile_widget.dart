import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityTileWidget extends StatelessWidget {
  const CityTileWidget({
    required this.cityName,
    required this.icon,
    required this.temperature,
    required this.onTap,
    super.key,
  });

  final String cityName;
  final String icon;
  final int temperature;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    const EnviromentEnum envEnum = EnviromentEnum.constants;
    // Material (em vez de Container com cor) para o efeito de toque do
    // ListTile aparecer por cima do fundo.
    return Padding(
      padding: .symmetric(vertical: 10),
      child: Material(
        color: Color(0x15FFFFFF),
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: SvgPicture.network('${envEnum.IMAGE_URL}$icon.svg'),
          titleTextStyle: TextStyle(fontSize: 20),
          textColor: Colors.white,
          title: Text(cityName, textAlign: .center),
          trailing: Text(
            '${temperature.toString()}°C',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
