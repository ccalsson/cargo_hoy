class CamionModel {
  final String id;
  final String flotaId;
  final String matricula;
  final String marca;
  final String modelo;
  final double capacidad; // Capacidad en toneladas
  final DateTime fechaAdquisicion;

  CamionModel({
    required this.id,
    required this.flotaId,
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.capacidad,
    required this.fechaAdquisicion,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flotaId': flotaId,
      'matricula': matricula,
      'marca': marca,
      'modelo': modelo,
      'capacidad': capacidad,
      'fechaAdquisicion': fechaAdquisicion.toIso8601String(),
    };
  }

  // Crear desde JSON
  factory CamionModel.fromJson(Map<String, dynamic> json) {
    return CamionModel(
      id: json['id'],
      flotaId: json['flotaId'],
      matricula: json['matricula'],
      marca: json['marca'],
      modelo: json['modelo'],
      capacidad: json['capacidad'],
      fechaAdquisicion: DateTime.parse(json['fechaAdquisicion']),
    );
  }
}