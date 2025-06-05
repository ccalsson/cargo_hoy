class ServicioModel {
  final String id;
  final String tipo; // combustible, gomería, mecánica
  final String ubicacion;
  final List<String> descuentos; // Lista de descuentos disponibles
  final List<Map<String, dynamic>> resenas; // Lista de resenas

  ServicioModel({
    required this.id,
    required this.tipo,
    required this.ubicacion,
    this.descuentos = const [],
    this.resenas = const [],
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'ubicacion': ubicacion,
      'descuentos': descuentos,
      'resenas': resenas,
    };
  }

  // Crear desde JSON
  factory ServicioModel.fromJson(Map<String, dynamic> json) {
    return ServicioModel(
      id: json['id'],
      tipo: json['tipo'],
      ubicacion: json['ubicacion'],
      descuentos: List<String>.from(json['descuentos']),
      resenas: List<Map<String, dynamic>>.from(json['resenas']),
    );
  }
}
