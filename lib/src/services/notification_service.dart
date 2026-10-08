// lib/src/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Instância singleton para acesso global
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Chave global para permitir navegação sem BuildContext
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initializeLocalNotifications() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      linux: LinuxInitializationSettings(
        defaultActionName: 'Abrir notificação',
      ),
      windows: WindowsInitializationSettings(
        appName: 'Climapp',
        appUserModelId: 'br.dev.yago.climapp_cc20262',
        guid: '9f9d3eb4-7c68-4f20-91ad-651ced8f2463',
      ),
      web: WebInitializationSettings(),
    );

    await _localNotifications.initialize(settings: settings);
  }

  Future<void> showWeatherTestNotification({required String cityName}) async {
    final bool? permissionGranted = await _requestNotificationPermission();
    if (permissionGranted == false) return;

    await _localNotifications.show(
      id: 0,
      title: 'Climapp',
      body: 'Dados do clima de $cityName carregados.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'weather_updates',
          'Atualizações do clima',
          channelDescription: 'Avisos sobre a atualização do clima.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<bool?> _requestNotificationPermission() async {
    if (kIsWeb) {
      final WebFlutterLocalNotificationsPlugin? webPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
            WebFlutterLocalNotificationsPlugin
          >();
      if (webPlugin == null ||
          webPlugin.permissionStatus == WebNotificationPermission.granted) {
        return true;
      }
      return webPlugin.requestNotificationsPermission();
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return _localNotifications
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    return true;
  }

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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Mensagem recebida em Foreground: ${message.notification?.title}',
      );

      final notification = message.notification;
      if (notification != null) {
        // Exibe um alerta ou SnackBar utilizando o contexto global
        final context = navigatorKey.currentContext;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${notification.title}\n${notification.body}'),
              backgroundColor: Colors.blueAccent,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
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

  void _handleDeepLink(RemoteMessage message) {
    final city = message.data['city'];
    if (city != null) {
      // Navega diretamente para a tela de clima da cidade
      navigatorKey.currentState?.pushNamed('/weather', arguments: city);
    }
  }
}
