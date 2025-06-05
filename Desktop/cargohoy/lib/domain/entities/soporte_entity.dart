class SoporteEntity {
  final String usuarioId;
  final String mensaje;

  SoporteEntity({required this.usuarioId, required this.mensaje});

  factory SoporteEntity.fromJson(Map<String, dynamic> json) {
    return SoporteEntity(
      usuarioId: json['usuarioId'],
      mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'mensaje': mensaje,
    };
  }
}
