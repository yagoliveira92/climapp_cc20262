// lib/src/services/notification_service.dart
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Instância singleton para acesso global
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // `late`: só acessa o Firebase quando initialize() for chamado, assim as
  // chaves globais abaixo podem ser usadas mesmo sem Firebase configurado.
  late final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Chave global para permitir navegação sem BuildContext
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Chave global do ScaffoldMessenger: permite exibir banners/snackbars
  // de qualquer lugar do app (ex.: quando chega uma notificação push).
  // IMPORTANTE: precisa ser registrada no MaterialApp (scaffoldMessengerKey).
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Timer? _bannerTimer;

  Future<void> initialize() async {
    // 1. Solicitar permissões (Obrigatório para iOS e Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permissão concedida pelo usuário.');

      // No iOS, por padrão o sistema NÃO mostra a notificação com o app aberto.
      // Aqui pedimos para ele tocar o som/atualizar o badge, mas o alerta
      // visual fica por conta do nosso banner dentro do app.
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: true,
      );

      // 2. Obter o FCM Token na inicialização
      String? token = await _fcm.getToken();
      debugPrint('====================================');
      debugPrint('FCM TOKEN DO DISPOSITIVO: $token');
      debugPrint('====================================');

      // Escuta caso o token seja renovado pelo Firebase
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token atualizado: $newToken');
      });

      // 3. Configurar os listeners de eventos
      _setupMessageHandlers();
    } else {
      debugPrint('Permissão negada ou não configurada.');
    }
  }

  void _setupMessageHandlers() {
    // Cenário: Foreground (App aberto na tela)
    // O Firebase NÃO exibe a notificação do sistema quando o app está em
    // primeiro plano, então nós mesmos mostramos um banner dentro do app.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Mensagem recebida em Foreground: ${message.notification?.title}',
      );

      final title =
          message.notification?.title ?? message.data['title'] ?? 'Climapp';
      final body = message.notification?.body ?? message.data['body'] ?? '';

      showInAppNotification(title: title, body: body);
    });

    // Cenário: Background (App minimizado e usuário clica na notificação)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Toque na notificação (Background): ${message.data}');
      _handleDeepLink(message);
    });

    // Cenário: Terminated (App fechado e aberto pelo clique na notificação)
    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App inicializado a partir de notificação: ${message.data}');
        _handleDeepLink(message);
      }
    });
  }

  /// Exibe um banner no topo da tela, estilo notificação, com o app aberto.
  /// Some sozinho depois de alguns segundos ou ao tocar em "Fechar".
  void showInAppNotification({required String title, required String body}) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint('ScaffoldMessenger indisponível para exibir a notificação.');
      return;
    }

    _bannerTimer?.cancel();
    messenger.clearMaterialBanners();
    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: const Color(0xFF4463D5),
        elevation: 4,
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications_active, color: Color(0xFF00457D)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (body.isNotEmpty)
              Text(body, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            child: const Text('Fechar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // Esconde o banner automaticamente depois de 5 segundos
    _bannerTimer = Timer(const Duration(seconds: 5), () {
      scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
    });
  }

  void _handleDeepLink(RemoteMessage message) {
    final city = message.data['city'];
    if (city != null) {
      // Navega diretamente para a tela de clima da cidade
      navigatorKey.currentState?.pushNamed('/weather', arguments: city);
    }
  }
}
