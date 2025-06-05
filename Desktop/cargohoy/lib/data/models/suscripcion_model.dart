class SuscripcionModel {
  final String id;
  final String usuarioId;
  final String stripeSubscriptionId;
  final String plan; // básica, media, full
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String estado; // activa, cancelada, vencida

  SuscripcionModel({
    required this.id,
    required this.usuarioId,
    required this.stripeSubscriptionId,
    required this.plan,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'stripeSubscriptionId': stripeSubscriptionId,
      'plan': plan,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'estado': estado,
    };
  }

  // Crear desde JSON
  factory SuscripcionModel.fromJson(Map<String, dynamic> json) {
    return SuscripcionModel(
      id: json['id'],
      usuarioId: json['usuarioId'],
      stripeSubscriptionId: json['stripeSubscriptionId'],
      plan: json['plan'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
      estado: json['estado'],
    );
  }
}