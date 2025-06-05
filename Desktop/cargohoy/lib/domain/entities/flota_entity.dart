class FlotaEntity {
  final String id;
  final String nombre;
  final String duenoId;

  FlotaEntity({
    required this.id,
    required this.nombre,
    required this.duenoId,
  });

  factory FlotaEntity.fromJson(Map<String, dynamic> json) {
    return FlotaEntity(
      id: json['id'],
      nombre: json['nombre'],
      duenoId: json['duenoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'duenoId': duenoId,
    };
  }
}
