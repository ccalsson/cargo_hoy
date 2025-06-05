import 'package:cargohoy/data/models/reporte_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/reporte_repository.dart';
import '../../domain/usecases/reporte_usecases.dart';

class ReporteProvider with ChangeNotifier {
  final ReporteUsecases _reporteUsecases = ReporteUsecases(ReporteRepository());
  ReporteModel? _reporteDesempeno;
  ReporteModel? _reporteSostenibilidad;
  bool _isLoading = false;
  String _errorMessage = '';

  ReporteModel? get reporteDesempeno => _reporteDesempeno;
  ReporteModel? get reporteSostenibilidad => _reporteSostenibilidad;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Obtener reporte de desempeño
  Future<void> fetchReporteDesempeno(String usuarioId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reporteDesempeno = await _reporteUsecases.getReporteDesempeno(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener reporte de sostenibilidad
  Future<void> fetchReporteSostenibilidad(String usuarioId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reporteSostenibilidad =
          await _reporteUsecases.getReporteSostenibilidad(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
