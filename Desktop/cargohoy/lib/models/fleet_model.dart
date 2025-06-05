class Fleet {
  final String id;
  final String name;
  final String ownerId;
  final String companyId;
  final String address;
  final String phone;
  final String email;
  final bool verified;
  final DateTime createdAt;

  // Políticas y términos
  final bool policiesAccepted;
  final DateTime? policiesAcceptedAt;
  final String? policiesDocumentUrl;

  // Configuración de anticipos
  final bool allowAdvances;
  final double advancePercentage;
  final int maxAdvanceDays;

  // Configuración de comisiones
  final double commissionPercentage;
  final double minCommissionAmount;
  final bool autoRetainCommission;

  Fleet({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.companyId,
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
    this.commissionPercentage = 0.10,
    this.minCommissionAmount = 50.0,
    this.autoRetainCommission = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'companyId': companyId,
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
      'commissionPercentage': commissionPercentage,
      'minCommissionAmount': minCommissionAmount,
      'autoRetainCommission': autoRetainCommission,
    };
  }

  factory Fleet.fromMap(Map<String, dynamic> map) {
    return Fleet(
      id: map['id'],
      name: map['name'],
      ownerId: map['ownerId'],
      companyId: map['companyId'],
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
      commissionPercentage: map['commissionPercentage']?.toDouble() ?? 0.10,
      minCommissionAmount: map['minCommissionAmount']?.toDouble() ?? 50.0,
      autoRetainCommission: map['autoRetainCommission'] ?? true,
    );
  }

  // Calcular comisión para un viaje
  double calculateCommission(double tripAmount) {
    final commission = tripAmount * commissionPercentage;
    return commission < minCommissionAmount ? minCommissionAmount : commission;
  }

  // Calcular monto máximo de anticipo permitido
  double calculateMaxAdvance(double tripAmount) {
    return tripAmount * advancePercentage;
  }
}
