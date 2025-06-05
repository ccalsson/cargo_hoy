class CargaModel {
  final String id;
  final String tipoCarga;
  final double peso;
  final String dimensiones;
  final String origen;
  final String destino;
  final DateTime fechaRecogida;
  final DateTime fechaEntrega;
  final String estado; // pendiente, en_progreso, completada
  final String empresaId;
  final String? conductorId;
  final double tarifa;
  final String metodoPago;
  final List<String> requisitosEspeciales;
  final List<String> imagenes; // URLs de imágenes
  final List<String> documentos; // URLs de documentos
  final Map<String, dynamic> tracking;
  final double calificacion;
  final List<String> comentarios;
  final bool urgente;
  final Map<String, dynamic> seguro;
  final Map<String, dynamic> restricciones;

  CargaModel({
    required this.id,
    required this.tipoCarga,
    required this.peso,
    required this.dimensiones,
    required this.origen,
    required this.destino,
    required this.fechaRecogida,
    required this.fechaEntrega,
    this.estado = 'pendiente',
    required this.empresaId,
    this.conductorId,
    required this.tarifa,
    required this.metodoPago,
    this.requisitosEspeciales = const [],
    this.imagenes = const [],
    this.documentos = const [],
    this.tracking = const {},
    this.calificacion = 0.0,
    this.comentarios = const [],
    this.urgente = false,
    required this.seguro,
    required this.restricciones,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipoCarga': tipoCarga,
      'peso': peso,
      'dimensiones': dimensiones,
      'origen': origen,
      'destino': destino,
      'fechaRecogida': fechaRecogida.toIso8601String(),
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'estado': estado,
      'empresaId': empresaId,
      'conductorId': conductorId,
      'tarifa': tarifa,
      'metodoPago': metodoPago,
      'requisitosEspeciales': requisitosEspeciales,
      'imagenes': imagenes,
      'documentos': documentos,
      'tracking': tracking,
      'calificacion': calificacion,
      'comentarios': comentarios,
      'urgente': urgente,
      'seguro': seguro,
      'restricciones': restricciones,
    };
  }

  // Crear desde JSON
  factory CargaModel.fromJson(Map<String, dynamic> json) {
    return CargaModel(
      id: json['id'],
      tipoCarga: json['tipoCarga'],
      peso: json['peso'],
      dimensiones: json['dimensiones'],
      origen: json['origen'],
      destino: json['destino'],
      fechaRecogida: DateTime.parse(json['fechaRecogida']),
      fechaEntrega: DateTime.parse(json['fechaEntrega']),
      estado: json['estado'],
      empresaId: json['empresaId'],
      conductorId: json['conductorId'],
      tarifa: json['tarifa'],
      metodoPago: json['metodoPago'],
      requisitosEspeciales: List<String>.from(json['requisitosEspeciales']),
      imagenes: List<String>.from(json['imagenes']),
      documentos: List<String>.from(json['documentos']),
      tracking: Map<String, dynamic>.from(json['tracking']),
      calificacion: json['calificacion'],
      comentarios: List<String>.from(json['comentarios']),
      urgente: json['urgente'],
      seguro: Map<String, dynamic>.from(json['seguro']),
      restricciones: Map<String, dynamic>.from(json['restricciones']),
    );
  }
}
