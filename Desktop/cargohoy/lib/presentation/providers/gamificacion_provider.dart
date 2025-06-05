import 'package:cargohoy/data/models/gamificacion_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/gamificacion_repository.dart';
import '../../domain/usecases/gamificacion_usecases.dart';

class GamificacionProvider with ChangeNotifier {
  final GamificacionUsecases _gamificacionUsecases =
      GamificacionUsecases(GamificacionRepository());
  GamificacionModel? _gamificacion;
  bool _isLoading = false;
  String _errorMessage = '';

  GamificacionModel? get gamificacion => _gamificacion;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Obtener datos de gamificación
  Future<void> fetchGamificacion(String usuarioId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _gamificacion = await _gamificacionUsecases.getGamificacion(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Canjear puntos por recompensa
  Future<void> canjearRecompensa(String usuarioId, String recompensa) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _gamificacionUsecases.canjearRecompensa(usuarioId, recompensa);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
