import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/metrics_model.dart';

class MetricsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MetricsModel> _metrics = [];
  bool _isLoading = false;

  List<MetricsModel> get metrics => _metrics;
  bool get isLoading => _isLoading;

  Future<void> fetchMetrics({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      Query query = _firestore
          .collection('metrics')
          .where('userId', isEqualTo: userId);

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      _metrics = snapshot.docs
          .map((doc) => MetricsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMetrics(MetricsModel metrics) async {
    try {
      await _firestore.collection('metrics').add(metrics.toMap());
      await fetchMetrics(userId: metrics.userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> generateReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final metrics = await _firestore
          .collection('metrics')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      double totalDistance = 0;
      double totalFuel = 0;
      double totalEarnings = 0;

      for (var doc in metrics.docs) {
        final data = doc.data();
        totalDistance += (data['distance'] ?? 0.0).toDouble();
        totalFuel += (data['fuelConsumption'] ?? 0.0).toDouble();
        totalEarnings += (data['earnings'] ?? 0.0).toDouble();
      }

      return {
        'totalDistance': totalDistance,
        'totalFuel': totalFuel,
        'totalEarnings': totalEarnings,
        'fuelEfficiency': totalDistance / totalFuel,
        'earningsPerKm': totalEarnings / totalDistance,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MetricsModel>> getMetricsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('metrics')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return snapshot.docs
          .map((doc) => MetricsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMetrics(String metricsId) async {
    try {
      await _firestore.collection('metrics').doc(metricsId).delete();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
} 