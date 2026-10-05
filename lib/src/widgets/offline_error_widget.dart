import 'package:flutter/material.dart';

/// Tela de erro amigável exibida quando não foi possível carregar os dados
/// (sem internet, servidor fora do ar, etc.), com botão para tentar de novo.
class OfflineErrorWidget extends StatelessWidget {
  const OfflineErrorWidget({
    required this.onRetry,
    this.isOffline = true,
    this.message,
    super.key,
  });

  final VoidCallback onRetry;
  final bool isOffline;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final title = isOffline
        ? 'Ops! Você está sem internet'
        : 'Não conseguimos carregar o clima';
    final description = isOffline
        ? 'Parece que seu celular está desconectado. Verifique o Wi-Fi ou os '
              'dados móveis e tente novamente.'
        : (message?.isNotEmpty == true
              ? message!
              : 'Algo deu errado ao buscar a previsão. Tente novamente em '
                    'alguns instantes.');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0x15FFFFFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOffline ? Icons.wifi_off_rounded : Icons.cloud_off_rounded,
                color: const Color(0xFF7693FF),
                size: 72,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7693FF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.black),
              label: const Text(
                'Tentar novamente',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
