class GamificacionModel {
  final String usuarioId;
  final int puntos;
  final List<String> recompensas; // Lista de recompensas obtenidas
  final List<String> logros; // Lista de logros desbloqueados

  GamificacionModel({
    required this.usuarioId,
    required this.puntos,
    this.recompensas = const [],
    this.logros = const [],
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'puntos': puntos,
      'recompensas': recompensas,
      'logros': logros,
    };
  }

  // Crear desde JSON
  factory GamificacionModel.fromJson(Map<String, dynamic> json) {
    return GamificacionModel(
      usuarioId: json['usuarioId'],
      puntos: json['puntos'],
      recompensas: List<String>.from(json['recompensas']),
      logros: List<String>.from(json['logros']),
    );
  }
}