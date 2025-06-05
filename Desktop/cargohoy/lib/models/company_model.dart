class Company {
  final String id;
  final String name;
  final String adminId;
  final String taxId;
  final String address;
  final String phone;
  final String email;
  final bool verified;
  final DateTime createdAt;

  // Políticas y términos
  final bool policiesAccepted;
  final DateTime? policiesAcceptedAt;
  final String? policiesDocumentUrl;

  // Términos de pago
  final bool allowAdvances;
  final double advancePercentage;
  final int maxAdvanceDays;

  // Penalizaciones
  final double cancellationPenaltyPercentage;
  final double minCancellationPenalty;
  final int cancellationNoticeHours;

  Company({
    required this.id,
    required this.name,
    required this.adminId,
    required this.taxId,
    required this.address,
    required this.phone,
    required this.email,
    required this.verified,
    required this.createdAt,
    this.policiesAccepted = false,
    this.policiesAcceptedAt,
    this.policiesDocumentUrl,
    this.allowAdvances = false,
    this.advancePercentage = 0.0,
    this.maxAdvanceDays = 30,
    this.cancellationPenaltyPercentage = 0.10,
    this.minCancellationPenalty = 50.0,
    this.cancellationNoticeHours = 24,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'adminId': adminId,
      'taxId': taxId,
      'address': address,
      'phone': phone,
      'email': email,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'policiesAccepted': policiesAccepted,
      'policiesAcceptedAt': policiesAcceptedAt?.toIso8601String(),
      'policiesDocumentUrl': policiesDocumentUrl,
      'allowAdvances': allowAdvances,
      'advancePercentage': advancePercentage,
      'maxAdvanceDays': maxAdvanceDays,
      'cancellationPenaltyPercentage': cancellationPenaltyPercentage,
      'minCancellationPenalty': minCancellationPenalty,
      'cancellationNoticeHours': cancellationNoticeHours,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      name: map['name'],
      adminId: map['adminId'],
      taxId: map['taxId'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      verified: map['verified'],
      createdAt: DateTime.parse(map['createdAt']),
      policiesAccepted: map['policiesAccepted'] ?? false,
      policiesAcceptedAt: map['policiesAcceptedAt'] != null
          ? DateTime.parse(map['policiesAcceptedAt'])
          : null,
      policiesDocumentUrl: map['policiesDocumentUrl'],
      allowAdvances: map['allowAdvances'] ?? false,
      advancePercentage: map['advancePercentage']?.toDouble() ?? 0.0,
      maxAdvanceDays: map['maxAdvanceDays'] ?? 30,
      cancellationPenaltyPercentage:
          map['cancellationPenaltyPercentage']?.toDouble() ?? 0.10,
      minCancellationPenalty: map['minCancellationPenalty']?.toDouble() ?? 50.0,
      cancellationNoticeHours: map['cancellationNoticeHours'] ?? 24,
    );
  }

  // Calcular penalización por cancelación
  double calculateCancellationPenalty(double tripAmount) {
    final penalty = tripAmount * cancellationPenaltyPercentage;
    return penalty < minCancellationPenalty ? minCancellationPenalty : penalty;
  }

  // Verificar si una cancelación está dentro del plazo permitido
  bool isWithinCancellationNotice(DateTime tripDate) {
    final noticeDeadline =
        tripDate.subtract(Duration(hours: cancellationNoticeHours));
    return DateTime.now().isBefore(noticeDeadline);
  }

  // Calcular monto máximo de anticipo permitido
  double calculateMaxAdvance(double tripAmount) {
    return tripAmount * advancePercentage;
  }
}
