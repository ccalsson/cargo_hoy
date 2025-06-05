import 'package:flutter/material.dart';
import '../../data/repositories/pago_repository.dart';
import '../../domain/usecases/pago_usecases.dart';

class PagoProvider with ChangeNotifier {
  final PagoUsecases _pagoUsecases = PagoUsecases(PagoRepository());
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  get pagos => null;

  // Crear un pago
  Future<void> createPayment(
      double monto, String moneda, String descripcion) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _pagoUsecases.createPayment(monto, moneda, descripcion);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
