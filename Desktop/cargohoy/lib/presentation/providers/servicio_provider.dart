import 'package:cargohoy/data/models/servicio_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/servicio_repository.dart';
import '../../domain/usecases/servicio_usecases.dart';

class ServicioProvider with ChangeNotifier {
  final ServicioUsecases _servicioUsecases =
      ServicioUsecases(ServicioRepository());
  List<ServicioModel> _servicios = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ServicioModel> get servicios => _servicios;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Obtener lista de servicios
  Future<void> fetchServicios() async {
    _isLoading = true;
    notifyListeners();

    try {
      _servicios = await _servicioUsecases.getServicios();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reservar un servicio
  Future<void> reserveServicio(String servicioId, String usuarioId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _servicioUsecases.reserveServicio(servicioId, usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
