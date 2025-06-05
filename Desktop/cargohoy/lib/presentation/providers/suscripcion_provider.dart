import 'package:flutter/material.dart';
import '../../data/repositories/suscripcion_repository.dart';
import '../../domain/usecases/suscripcion_usecases.dart';

class SuscripcionProvider with ChangeNotifier {
  final SuscripcionUsecases _suscripcionUsecases = SuscripcionUsecases(SuscripcionRepository());
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Crear una suscripción
  Future<void> createSubscription(String plan) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _suscripcionUsecases.createSubscription(plan);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancelar una suscripción
  Future<void> cancelSubscription(String subscriptionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _suscripcionUsecases.cancelSubscription(subscriptionId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}