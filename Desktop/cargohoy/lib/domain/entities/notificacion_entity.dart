class NotificacionEntity {
  final String id;
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final bool leido;

  NotificacionEntity({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    this.leido = false,
  });

  // Crear una instancia desde un JSON
  factory NotificacionEntity.fromJson(Map<String, dynamic> json) {
    return NotificacionEntity(
      id: json['id'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      fecha: DateTime.parse(json['fecha']),
      leido: json['leido'] ?? false,
    );
  }

  // Convertir la instancia a un JSON
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
