import 'package:cloud_firestore/cloud_firestore.dart';

enum MembershipPlan { basic, pro, premium }

class UserModel {
  final String id;
  final String email;
  final String name;
  final MembershipPlan membershipPlan;
  final int reservationTokens;
  final Map<String, dynamic> penalties;
  final List<String> activeReservations;
  final GeoPoint? location;
  final String? photoUrl;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.membershipPlan,
    this.reservationTokens = 0,
    this.penalties = const {},
    this.activeReservations = const [],
    this.location,
    this.photoUrl,
    this.metadata,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      name: data['name'] as String,
      membershipPlan: MembershipPlan.values.firstWhere(
        (e) => e.toString() == 'MembershipPlan.${data['membershipPlan']}',
        orElse: () => MembershipPlan.basic,
      ),
      reservationTokens: data['reservationTokens'] as int? ?? 0,
      penalties: data['penalties'] as Map<String, dynamic>? ?? {},
      activeReservations: List<String>.from(data['activeReservations'] ?? []),
      location: data['location'] as GeoPoint?,
      photoUrl: data['photoUrl'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'membershipPlan': membershipPlan.toString().split('.').last,
      'reservationTokens': reservationTokens,
      'penalties': penalties,
      'activeReservations': activeReservations,
      'location': location,
      'photoUrl': photoUrl,
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    MembershipPlan? membershipPlan,
    int? reservationTokens,
    Map<String, dynamic>? penalties,
    List<String>? activeReservations,
    GeoPoint? location,
    String? photoUrl,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      membershipPlan: membershipPlan ?? this.membershipPlan,
      reservationTokens: reservationTokens ?? this.reservationTokens,
      penalties: penalties ?? this.penalties,
      activeReservations: activeReservations ?? this.activeReservations,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get canReserve =>
      membershipPlan != MembershipPlan.basic && !hasActivePenalty;

  bool get hasActivePenalty {
    if (penalties.isEmpty) return false;

    final penaltyEndDate = penalties['endDate'] as Timestamp?;
    if (penaltyEndDate == null) return false;

    return DateTime.now().isBefore(penaltyEndDate.toDate());
  }

  bool get hasLowPriority {
    if (penalties.isEmpty) return false;
    return penalties['lowPriority'] as bool? ?? false;
  }

  int get maxReservations {
    switch (membershipPlan) {
      case MembershipPlan.basic:
        return 0;
      case MembershipPlan.pro:
        return 2;
      case MembershipPlan.premium:
        return -1; // Ilimitado
    }
  }

  bool get hasUnlimitedTokens => membershipPlan == MembershipPlan.premium;
}
