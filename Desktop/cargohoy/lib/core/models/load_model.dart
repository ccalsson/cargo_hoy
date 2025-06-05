import 'package:cloud_firestore/cloud_firestore.dart';

class LoadModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final Map<String, dynamic> origin;
  final Map<String, dynamic> destination;
  final String status;
  final String companyId;
  final String? driverId;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final Map<String, dynamic>? requirements;

  LoadModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.origin,
    required this.destination,
    required this.status,
    required this.companyId,
    this.driverId,
    required this.createdAt,
    this.acceptedAt,
    this.requirements,
  });

  factory LoadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoadModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      origin: data['origin'] ?? {},
      destination: data['destination'] ?? {},
      status: data['status'] ?? 'available',
      companyId: data['companyId'] ?? '',
      driverId: data['driverId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      acceptedAt: data['acceptedAt'] != null 
          ? (data['acceptedAt'] as Timestamp).toDate()
          : null,
      requirements: data['requirements'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'origin': origin,
      'destination': destination,
      'status': status,
      'companyId': companyId,
      'driverId': driverId,
      'createdAt': Timestamp.fromDate(createdAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'requirements': requirements,
    };
  }
} 