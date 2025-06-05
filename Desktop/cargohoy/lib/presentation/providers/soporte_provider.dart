import 'package:cargohoy/data/repositories/soporte_repository.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/soporte_usecases.dart';

class SoporteProvider with ChangeNotifier {
  final SoporteUsecases _soporteUsecases = SoporteUsecases(SoporteRepository());
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> enviarSoporte(String usuarioId, String mensaje) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _soporteUsecases.enviarSoporte(usuarioId, mensaje);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
