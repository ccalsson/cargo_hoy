class CargaEntity {
  final String id;
  final String tipoCarga;
  final double peso;
  final String dimensiones;
  final String origen;
  final String destino;
  final DateTime fechaEntrega;
  final String estado; // pendiente, en_progreso, completada
  final String empresaId;
  final String? conductorId;
  final List<String> imagenes; // URLs de imágenes
  final List<String> documentos; // URLs de documentos

  CargaEntity({
    required this.id,
    required this.tipoCarga,
    required this.peso,
    required this.dimensiones,
    required this.origen,
    required this.destino,
    required this.fechaEntrega,
    this.estado = 'pendiente',
    required this.empresaId,
    this.conductorId,
    this.imagenes = const [],
    this.documentos = const [],
  });

  factory CargaEntity.fromJson(Map<String, dynamic> json) {
    return CargaEntity(
      id: json['id'],
      tipoCarga: json['tipoCarga'],
      peso: json['peso'],
      dimensiones: json['dimensiones'],
      origen: json['origen'],
      destino: json['destino'],
      fechaEntrega: DateTime.parse(json['fechaEntrega']),
      estado: json['estado'],
      empresaId: json['empresaId'],
      conductorId: json['conductorId'],
      imagenes: List<String>.from(json['imagenes']),
      documentos: List<String>.from(json['documentos']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipoCarga': tipoCarga,
      'peso': peso,
      'dimensiones': dimensiones,
      'origen': origen,
      'destino': destino,
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'estado': estado,
      'empresaId': empresaId,
      'conductorId': conductorId,
      'imagenes': imagenes,
      'documentos': documentos,
    };
  }
}
