import 'package:cargohoy/data/models/notificacion_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/notificacion_repository.dart';
import '../../domain/usecases/notificacion_usecases.dart';

class NotificacionProvider with ChangeNotifier {
  final NotificacionUsecases _notificacionUsecases =
      NotificacionUsecases(NotificacionRepository());
  List<NotificacionModel> _notificaciones = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<NotificacionModel> get notificaciones => _notificaciones;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Obtener lista de notificaciones
  Future<void> fetchNotificaciones(String usuarioId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notificaciones =
          await _notificacionUsecases.getNotificaciones(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marcar notificación como leída
  Future<void> markAsRead(String notificacionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificacionUsecases.markAsRead(notificacionId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
