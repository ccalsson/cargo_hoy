class ServicioFinancieroModel {
  final String id;
  final String cargaId;
  final String transportistaId;
  final double montoTotal;
  final double montoAdelanto;
  final double porcentajeQuita; // Para pagos anticipados
  final String metodoPago;
  final int diasPlazo; // 0 para contado, 15, 30, etc.
  final String estado; // pendiente, aprobado, rechazado, liquidado
  final DateTime fechaSolicitud;
  final DateTime? fechaLiquidacion;
  final List<String> documentosRespaldo;
  final Map<String, dynamic> datosFacturacion;

  ServicioFinancieroModel({
    required this.id,
    required this.cargaId,
    required this.transportistaId,
    required this.montoTotal,
    required this.montoAdelanto,
    required this.porcentajeQuita,
    required this.metodoPago,
    required this.diasPlazo,
    required this.estado,
    required this.fechaSolicitud,
    this.fechaLiquidacion,
    required this.documentosRespaldo,
    required this.datosFacturacion,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cargaId': cargaId,
    'transportistaId': transportistaId,
    'montoTotal': montoTotal,
    'montoAdelanto': montoAdelanto,
    'porcentajeQuita': porcentajeQuita,
    'metodoPago': metodoPago,
    'diasPlazo': diasPlazo,
    'estado': estado,
    'fechaSolicitud': fechaSolicitud.toIso8601String(),
    'fechaLiquidacion': fechaLiquidacion?.toIso8601String(),
    'documentosRespaldo': documentosRespaldo,
    'datosFacturacion': datosFacturacion,
  };
} 