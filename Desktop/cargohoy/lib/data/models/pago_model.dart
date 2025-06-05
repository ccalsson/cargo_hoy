import '../../domain/entities/pago_entity.dart';

class PagoModel {
  final String id;
  final double monto;
  final String moneda;
  final String descripcion;
  final DateTime fecha;

  PagoModel({
    required this.id,
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.fecha,
  });

  // Convertir PagoModel a PagoEntity
  PagoEntity toEntity() {
    return PagoEntity(
      id: id,
      monto: monto,
      moneda: moneda,
      descripcion: descripcion,
      fecha: fecha,
    );
  }

  // Crear PagoModel desde JSON
  factory PagoModel.fromJson(Map<String, dynamic> json) {
    return PagoModel(
      id: json['id'],
      monto: json['monto'],
      moneda: json['moneda'],
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
    );
  }

  // Convertir PagoModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monto': monto,
      'moneda': moneda,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }
}
