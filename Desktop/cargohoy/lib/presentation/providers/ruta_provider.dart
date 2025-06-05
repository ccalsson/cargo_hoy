import 'package:cargohoy/data/models/ruta_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/ruta_repository.dart';
import '../../domain/usecases/ruta_usecases.dart';

class RutaProvider with ChangeNotifier {
  final RutaUsecases _rutaUsecases = RutaUsecases(RutaRepository());
  RutaModel? _ruta;
  bool _isLoading = false;
  String _errorMessage = '';

  RutaModel? get ruta => _ruta;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchRuta(String origen, String destino) async {
    _isLoading = true;
    notifyListeners();
    try {
      _ruta = await _rutaUsecases.getRuta(origen, destino);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
