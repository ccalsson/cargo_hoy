enum UserRole {
  empresa_admin, // Administrador de empresa generadora de carga
  dueno_flota, // Dueño de flota de camiones
  conductor_propietario, // Conductor dueño de su camión
  conductor_empleado, // Conductor empleado
  admin_plataforma // Admin interno de Cargo Hoy
}

enum MembershipPlan {
  basic, // $10 USD - solo visualización
  pro, // $30 USD - reservas limitadas
  premium // $50 USD - reservas ilimitadas y anticipos
}

class User {
  final String id;
  final String email;
  final String nombre;
  final UserRole rol;
  final Map<String, dynamic> perfil;
  final List<String> documentos;
  final bool verificado;
  final DateTime fechaRegistro;

  // Campos para empresa o flota
  final String? companyId; // Para usuarios vinculados a empresas
  final String? fleetId; // Para conductores empleados

  // Campos para términos y condiciones
  final bool agreedToTerms;
  final DateTime? termsAcceptedAt;

  // Campos para membresía
  final MembershipStatus? membershipStatus;

  // Campos para contrato de autorización
  final bool contractAccepted;
  final DateTime? contractSignedAt;

  // Campos para políticas de empresa
  final bool? companyPoliciesAccepted;
  final DateTime? companyPoliciesAcceptedAt;

  User({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
    required this.perfil,
    required this.documentos,
    required this.verificado,
    required this.fechaRegistro,
    this.companyId,
    this.fleetId,
    this.agreedToTerms = false,
    this.termsAcceptedAt,
    this.membershipStatus,
    this.contractAccepted = false,
    this.contractSignedAt,
    this.companyPoliciesAccepted,
    this.companyPoliciesAcceptedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'rol': rol.toString(),
      'perfil': perfil,
      'documentos': documentos,
      'verificado': verificado,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'companyId': companyId,
      'fleetId': fleetId,
      'agreedToTerms': agreedToTerms,
      'termsAcceptedAt': termsAcceptedAt?.toIso8601String(),
      'membershipStatus': membershipStatus?.toMap(),
      'contractAccepted': contractAccepted,
      'contractSignedAt': contractSignedAt?.toIso8601String(),
      'companyPoliciesAccepted': companyPoliciesAccepted,
      'companyPoliciesAcceptedAt': companyPoliciesAcceptedAt?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      nombre: map['nombre'],
      rol: UserRole.values.firstWhere(
        (e) => e.toString() == map['rol'],
        orElse: () => UserRole.conductor_propietario,
      ),
      perfil: Map<String, dynamic>.from(map['perfil']),
      documentos: List<String>.from(map['documentos']),
      verificado: map['verificado'],
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
      companyId: map['companyId'],
      fleetId: map['fleetId'],
      agreedToTerms: map['agreedToTerms'] ?? false,
      termsAcceptedAt: map['termsAcceptedAt'] != null
          ? DateTime.parse(map['termsAcceptedAt'])
          : null,
      membershipStatus: map['membershipStatus'] != null
          ? MembershipStatus.fromMap(map['membershipStatus'])
          : null,
      contractAccepted: map['contractAccepted'] ?? false,
      contractSignedAt: map['contractSignedAt'] != null
          ? DateTime.parse(map['contractSignedAt'])
          : null,
      companyPoliciesAccepted: map['companyPoliciesAccepted'],
      companyPoliciesAcceptedAt: map['companyPoliciesAcceptedAt'] != null
          ? DateTime.parse(map['companyPoliciesAcceptedAt'])
          : null,
    );
  }

  // Verificar si el usuario puede realizar una reserva
  bool canMakeReservation() {
    if (membershipStatus == null) return false;
    return membershipStatus!.reservationsRemaining > 0;
  }

  // Verificar si el usuario puede solicitar un anticipo
  bool canRequestAdvance() {
    if (membershipStatus == null) return false;
    return membershipStatus!.plan != MembershipPlan.basic;
  }

  // Verificar si el usuario puede recibir descuento en comisión
  bool canGetCommissionDiscount() {
    if (membershipStatus == null) return false;
    return membershipStatus!.plan != MembershipPlan.basic;
  }
}

class MembershipStatus {
  final MembershipPlan plan;
  final DateTime paidAt;
  final bool hasUsedBenefit;
  final bool eligibleForFreeMonth;
  final int reservationsRemaining;

  MembershipStatus({
    required this.plan,
    required this.paidAt,
    required this.hasUsedBenefit,
    required this.eligibleForFreeMonth,
    required this.reservationsRemaining,
  });

  Map<String, dynamic> toMap() {
    return {
      'plan': plan.toString(),
      'paidAt': paidAt.toIso8601String(),
      'hasUsedBenefit': hasUsedBenefit,
      'eligibleForFreeMonth': eligibleForFreeMonth,
      'reservationsRemaining': reservationsRemaining,
    };
  }

  factory MembershipStatus.fromMap(Map<String, dynamic> map) {
    return MembershipStatus(
      plan: MembershipPlan.values.firstWhere(
        (e) => e.toString() == map['plan'],
        orElse: () => MembershipPlan.basic,
      ),
      paidAt: DateTime.parse(map['paidAt']),
      hasUsedBenefit: map['hasUsedBenefit'] ?? false,
      eligibleForFreeMonth: map['eligibleForFreeMonth'] ?? true,
      reservationsRemaining: map['reservationsRemaining'] ?? 0,
    );
  }

  // Precios de los planes
  static const Map<MembershipPlan, double> prices = {
    MembershipPlan.basic: 10.0,
    MembershipPlan.pro: 30.0,
    MembershipPlan.premium: 50.0,
  };

  // Límites de reservas por plan
  static const Map<MembershipPlan, int?> reservationLimits = {
    MembershipPlan.basic: 0,
    MembershipPlan.pro: 5,
    MembershipPlan.premium: null, // ilimitado
  };
}
