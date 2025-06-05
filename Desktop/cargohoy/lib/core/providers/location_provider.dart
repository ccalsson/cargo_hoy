import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class LocationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Position? _currentPosition;
  bool _isTracking = false;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;

  Future<void> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Permiso de ubicación denegado');
    }
  }

  Future<void> startTracking(String userId) async {
    _isTracking = true;
    notifyListeners();

    try {
      // Obtener ubicación actual
      _currentPosition = await Geolocator.getCurrentPosition();
      
      // Actualizar en Firestore
      await _firestore.collection('users').doc(userId).update({
        'location': {
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        },
      });

      // Iniciar seguimiento en segundo plano
      Geolocator.getPositionStream().listen((Position position) {
        _currentPosition = position;
        _firestore.collection('users').doc(userId).update({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          },
        });
        notifyListeners();
      });
    } catch (e) {
      _isTracking = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopTracking() async {
    _isTracking = false;
    notifyListeners();
  }
} 