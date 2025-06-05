import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/load_model.dart';

class LoadProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LoadModel> _availableLoads = [];
  List<LoadModel> _myLoads = [];
  bool _isLoading = false;

  List<LoadModel> get availableLoads => _availableLoads;
  List<LoadModel> get myLoads => _myLoads;
  bool get isLoading => _isLoading;

  Future<void> fetchAvailableLoads({
    double? maxDistance,
    String? type,
    Map<String, dynamic>? location,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      Query query = _firestore.collection('loads')
          .where('status', isEqualTo: 'available');

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      final snapshot = await query.get();
      _availableLoads = snapshot.docs
          .map((doc) => LoadModel.fromFirestore(doc))
          .toList();

      // Filtrar por distancia si se especifica
      if (maxDistance != null && location != null) {
        _availableLoads = _availableLoads.where((load) {
          final distance = _calculateDistance(
            location['latitude'],
            location['longitude'],
            load.origin['latitude'],
            load.origin['longitude'],
          );
          return distance <= maxDistance;
        }).toList();
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyLoads(String userId, UserRole role) async {
    try {
      _isLoading = true;
      notifyListeners();

      final field = role == UserRole.driver ? 'driverId' : 'companyId';
      final snapshot = await _firestore
          .collection('loads')
          .where(field, isEqualTo: userId)
          .get();

      _myLoads = snapshot.docs
          .map((doc) => LoadModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createLoad(LoadModel load) async {
    try {
      await _firestore.collection('loads').add(load.toMap());
      await fetchMyLoads(load.companyId, UserRole.company);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptLoad(String loadId, String driverId) async {
    try {
      await _firestore.collection('loads').doc(loadId).update({
        'status': 'in_progress',
        'driverId': driverId,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
      await fetchAvailableLoads();
      await fetchMyLoads(driverId, UserRole.driver);
    } catch (e) {
      rethrow;
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Implementar cálculo de distancia (Haversine formula)
    // Por ahora retornamos 0
    return 0.0;
  }
} 