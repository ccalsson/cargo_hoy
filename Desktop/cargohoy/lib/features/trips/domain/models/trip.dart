import 'package:cloud_firestore/cloud_firestore.dart';

enum TripStatus {
  available,
  reserved,
  expired,
  inProgress,
  completed,
  cancelled
}

class Trip {
  final String tripId;
  final String companyId;
  final GeoPoint origin;
  final GeoPoint destination;
  final DateTime startsAt;
  final String? reservedBy1;
  final String? reservedBy2;
  final TripStatus status;
  final bool matchingOpen;
  final double price;
  final String description;
  final Map<String, dynamic>? metadata;

  Trip({
    required this.tripId,
    required this.companyId,
    required this.origin,
    required this.destination,
    required this.startsAt,
    this.reservedBy1,
    this.reservedBy2,
    this.status = TripStatus.available,
    this.matchingOpen = false,
    required this.price,
    required this.description,
    this.metadata,
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Trip(
      tripId: doc.id,
      companyId: data['companyId'] as String,
      origin: data['origin'] as GeoPoint,
      destination: data['destination'] as GeoPoint,
      startsAt: (data['startsAt'] as Timestamp).toDate(),
      reservedBy1: data['reservedBy1'] as String?,
      reservedBy2: data['reservedBy2'] as String?,
      status: TripStatus.values.firstWhere(
        (e) => e.toString() == 'TripStatus.${data['status']}',
        orElse: () => TripStatus.available,
      ),
      matchingOpen: data['matchingOpen'] as bool? ?? false,
      price: (data['price'] as num).toDouble(),
      description: data['description'] as String,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'origin': origin,
      'destination': destination,
      'startsAt': Timestamp.fromDate(startsAt),
      'reservedBy1': reservedBy1,
      'reservedBy2': reservedBy2,
      'status': status.toString().split('.').last,
      'matchingOpen': matchingOpen,
      'price': price,
      'description': description,
      'metadata': metadata,
    };
  }

  Trip copyWith({
    String? tripId,
    String? companyId,
    GeoPoint? origin,
    GeoPoint? destination,
    DateTime? startsAt,
    String? reservedBy1,
    String? reservedBy2,
    TripStatus? status,
    bool? matchingOpen,
    double? price,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return Trip(
      tripId: tripId ?? this.tripId,
      companyId: companyId ?? this.companyId,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      startsAt: startsAt ?? this.startsAt,
      reservedBy1: reservedBy1 ?? this.reservedBy1,
      reservedBy2: reservedBy2 ?? this.reservedBy2,
      status: status ?? this.status,
      matchingOpen: matchingOpen ?? this.matchingOpen,
      price: price ?? this.price,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }
}
