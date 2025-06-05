enum AnticipoEstado { pendiente, pagado, programado, rechazado }

class Anticipo {
  final String id;
  final String userId;
  final String tripId;
  final double monto;
  final double comision;
  final AnticipoEstado estado;
  final DateTime fechaSolicitud;
  final DateTime? fechaPago;
  final String? notas;

  Anticipo({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.monto,
    required this.comision,
    required this.estado,
    required this.fechaSolicitud,
    this.fechaPago,
    this.notas,
  });

  double get montoNeto => monto - (monto * comision);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'tripId': tripId,
      'monto': monto,
      'comision': comision,
      'estado': estado.toString(),
      'fechaSolicitud': fechaSolicitud.toIso8601String(),
      'fechaPago': fechaPago?.toIso8601String(),
      'notas': notas,
    };
  }

  factory Anticipo.fromMap(Map<String, dynamic> map) {
    return Anticipo(
      id: map['id'],
      userId: map['userId'],
      tripId: map['tripId'],
      monto: map['monto'].toDouble(),
      comision: map['comision'].toDouble(),
      estado: AnticipoEstado.values.firstWhere(
        (e) => e.toString() == map['estado'],
        orElse: () => AnticipoEstado.pendiente,
      ),
      fechaSolicitud: DateTime.parse(map['fechaSolicitud']),
      fechaPago:
          map['fechaPago'] != null ? DateTime.parse(map['fechaPago']) : null,
      notas: map['notas'],
    );
  }
}
