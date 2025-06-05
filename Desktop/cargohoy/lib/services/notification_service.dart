import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Permisos
    NotificationSettings settings = await _fcm.requestPermission();
    
    // Configurar handlers
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Tópicos
    await _fcm.subscribeToTopic('nuevas_cargas');
    await _fcm.subscribeToTopic('urgentes');
  }

  void _handleMessage(RemoteMessage message) {
    // Mostrar notificación local
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Navegar a la pantalla correspondiente
  }
} 