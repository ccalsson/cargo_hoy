import '../../domain/entities/notificacion_entity.dart';

class NotificacionModel {
  final String id;
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final bool leido;

  NotificacionModel({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    this.leido = false,
  });

  // Convertir NotificacionModel a NotificacionEntity
  NotificacionEntity toEntity() {
    return NotificacionEntity(
      id: id,
      titulo: titulo,
      mensaje: mensaje,
      fecha: fecha,
      leido: leido,
    );
  }

  // Crear NotificacionModel desde JSON
  factory NotificacionModel.fromJson(Map<String, dynamic> json) {
    return NotificacionModel(
      id: json['id'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      fecha: DateTime.parse(json['fecha']),
      leido: json['leido'] ?? false,
    );
  }

  // Convertir NotificacionModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'fecha': fecha.toIso8601String(),
      'leido': leido,
    };
  }
}
