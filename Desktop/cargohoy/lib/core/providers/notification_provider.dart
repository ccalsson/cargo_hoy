import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    // Solicitar permisos
    await _messaging.requestPermission();

    // Obtener token
    final token = await _messaging.getToken();
    if (token != null) {
      // Guardar token en Firestore
      await _firestore
          .collection('users')
          .doc('CURRENT_USER_ID')
          .update({'fcmToken': token});
    }

    // Escuchar mensajes en primer plano
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  Future<void> fetchNotifications(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      _notifications = snapshot.docs
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleMessage(RemoteMessage message) {
    // Mostrar notificación local
    // Actualizar lista de notificaciones
    fetchNotifications('CURRENT_USER_ID');
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});
    
    await fetchNotifications('CURRENT_USER_ID');
  }
} 