import 'package:cloud_firestore/cloud_firestore.dart';

class MetricsModel {
  final String id;
  final String userId;
  final double distance;
  final double fuelConsumption;
  final double earnings;
  final DateTime date;
  final String? loadId;
  final Map<String, dynamic>? route;

  MetricsModel({
    required this.id,
    required this.userId,
    required this.distance,
    required this.fuelConsumption,
    required this.earnings,
    required this.date,
    this.loadId,
    this.route,
  });

  factory MetricsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MetricsModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      distance: (data['distance'] ?? 0.0).toDouble(),
      fuelConsumption: (data['fuelConsumption'] ?? 0.0).toDouble(),
      earnings: (data['earnings'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      loadId: data['loadId'],
      route: data['route'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'distance': distance,
      'fuelConsumption': fuelConsumption,
      'earnings': earnings,
      'date': Timestamp.fromDate(date),
      'loadId': loadId,
      'route': route,
    };
  }
} 