import 'package:climapp_cc20262/src/screens/list_city_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:climapp_cc20262/src/controller/list_city_controller.dart';

String _flagForCountry(String countryCode) {
  final normalizedCode = countryCode.trim().toUpperCase();
  if (!RegExp(r'^[A-Z]{2}$').hasMatch(normalizedCode)) {
    return '';
  }
  return String.fromCharCodes(
    normalizedCode.codeUnits.map((letter) => letter + 0x1F1E6 - 0x41),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF00457D), Color(0xFF05051F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 40,
            children: [
              SizedBox(height: 30),
              Image.asset("assets/logo_climapp.png", width: 200),
              Image.asset("assets/ilustracao_home.png", width: 250),
              Consumer<ListCityController>(
                builder: (context, controller, child) {
                  final countryCode = controller.deviceCountry
                      .trim()
                      .toUpperCase();
                  final flag = _flagForCountry(countryCode);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Boas-vindas!',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      if (flag.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 8),
                            Text(
                              countryCode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListCityScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7693FF),
                  ),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Entrar',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.black, size: 25),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
