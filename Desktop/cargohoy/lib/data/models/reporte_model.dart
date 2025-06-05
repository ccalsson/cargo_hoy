class ReporteModel {
  final String id;
  final String tipo; // desempeño, sostenibilidad
  final Map<String, dynamic> datos; // Datos del reporte
  final DateTime fechaGeneracion;

  ReporteModel({
    required this.id,
    required this.tipo,
    required this.datos,
    required this.fechaGeneracion,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'datos': datos,
      'fechaGeneracion': fechaGeneracion.toIso8601String(),
    };
  }

  // Crear desde JSON
  factory ReporteModel.fromJson(Map<String, dynamic> json) {
    return ReporteModel(
      id: json['id'],
      tipo: json['tipo'],
      datos: json['datos'],
      fechaGeneracion: DateTime.parse(json['fechaGeneracion']),
    );
  }
}
