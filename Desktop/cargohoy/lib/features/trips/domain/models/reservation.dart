import 'package:cloud_firestore/cloud_firestore.dart';

enum ReservationStatus { confirmed, standby, cancelled, expired, completed }

class Reservation {
  final String reservationId;
  final String tripId;
  final String userId;
  final int priority;
  final ReservationStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool confirmed;
  final Map<String, dynamic>? metadata;

  Reservation({
    required this.reservationId,
    required this.tripId,
    required this.userId,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.confirmed = false,
    this.metadata,
  });

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reservation(
      reservationId: doc.id,
      tripId: data['tripId'] as String,
      userId: data['userId'] as String,
      priority: data['priority'] as int,
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString() == 'ReservationStatus.${data['status']}',
        orElse: () => ReservationStatus.standby,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      confirmed: data['confirmed'] as bool? ?? false,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'userId': userId,
      'priority': priority,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'confirmed': confirmed,
      'metadata': metadata,
    };
  }

  Reservation copyWith({
    String? reservationId,
    String? tripId,
    String? userId,
    int? priority,
    ReservationStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? confirmed,
    Map<String, dynamic>? metadata,
  }) {
    return Reservation(
      reservationId: reservationId ?? this.reservationId,
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      confirmed: confirmed ?? this.confirmed,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isActive =>
      status == ReservationStatus.confirmed ||
      status == ReservationStatus.standby;

  bool get isExpired =>
      DateTime.now().isAfter(expiresAt) || status == ReservationStatus.expired;

  bool get canBeCancelled => isActive && DateTime.now().isBefore(expiresAt);
}
