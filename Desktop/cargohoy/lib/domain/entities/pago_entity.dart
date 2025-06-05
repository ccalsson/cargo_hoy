class PagoEntity {
  final String id;
  final double monto;
  final String moneda;
  final String descripcion;
  final DateTime fecha;

  PagoEntity({
    required this.id,
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.fecha,
  });
}
