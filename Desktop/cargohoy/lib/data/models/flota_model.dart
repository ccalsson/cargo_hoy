class FlotaModel {
  final String id;
  final String duenoId;
  final List<String> camiones; // Lista de IDs de camiones
  final String membresia; // básica, media, full
  final DateTime fechaRegistro;

  FlotaModel({
    required this.id,
    required this.duenoId,
    this.camiones = const [],
    required this.membresia,
    required this.fechaRegistro,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duenoId': duenoId,
      'camiones': camiones,
      'membresia': membresia,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  // Crear desde JSON
  factory FlotaModel.fromJson(Map<String, dynamic> json) {
    return FlotaModel(
      id: json['id'],
      duenoId: json['duenoId'],
      camiones: List<String>.from(json['camiones']),
      membresia: json['membresia'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }
}
