import '../entities/notificacion_entity.dart';
import '../../data/repositories/notificacion_repository.dart';

class NotificacionUsecases {
  final NotificacionRepository _notificacionRepository;

  NotificacionUsecases(this._notificacionRepository);

  // Obtener lista de notificaciones
  Future<List<NotificacionEntity>> getNotificaciones(String usuarioId) async {
    final notificacionesModel =
        await _notificacionRepository.getNotificaciones(usuarioId);
    return notificacionesModel.map((model) => model.toEntity()).toList();
  }

  // Marcar notificación como leída
  Future<void> markAsRead(String notificacionId) async {
    return await _notificacionRepository.markAsRead(notificacionId);
  }
}
