class ConfiguracionEntity {
  final String id;
  final String usuarioId;
  final bool notificacionesActivas;
  final String tema; // Puede ser "claro" o "oscuro"

  ConfiguracionEntity({
    required this.id,
    required this.usuarioId,
    required this.notificacionesActivas,
    required this.tema,
  });

  // Convertir la entidad a un mapa (útil para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'notificacionesActivas': notificacionesActivas,
      'tema': tema,
    };
  }

  // Crear una entidad desde un mapa (útil para Firestore)
  factory ConfiguracionEntity.fromMap(Map<String, dynamic> map) {
    return ConfiguracionEntity(
      id: map['id'],
      usuarioId: map['usuarioId'],
      notificacionesActivas: map['notificacionesActivas'],
      tema: map['tema'],
    );
  }

  // Método para copiar la entidad con nuevos valores
  ConfiguracionEntity copyWith({
    String? id,
    String? usuarioId,
    bool? notificacionesActivas,
    String? tema,
  }) {
    return ConfiguracionEntity(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      notificacionesActivas:
          notificacionesActivas ?? this.notificacionesActivas,
      tema: tema ?? this.tema,
    );
  }

  @override
  String toString() {
    return 'ConfiguracionEntity(id: $id, usuarioId: $usuarioId, notificacionesActivas: $notificacionesActivas, tema: $tema)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConfiguracionEntity &&
        other.id == id &&
        other.usuarioId == usuarioId &&
        other.notificacionesActivas == notificacionesActivas &&
        other.tema == tema;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        usuarioId.hashCode ^
        notificacionesActivas.hashCode ^
        tema.hashCode;
  }
}
