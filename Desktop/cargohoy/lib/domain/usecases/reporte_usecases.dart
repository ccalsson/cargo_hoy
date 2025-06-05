import '../entities/reporte_entity.dart';
import '../../data/repositories/reporte_repository.dart';

class ReporteUsecases {
  final ReporteRepository _reporteRepository;

  ReporteUsecases(this._reporteRepository);

  // Obtener reporte de desempeño
  Future<ReporteEntity> getReporteDesempeno(String usuarioId) async {
    return await _reporteRepository.getReporteDesempeno(usuarioId);
  }

  // Obtener reporte de sostenibilidad
  Future<ReporteEntity> getReporteSostenibilidad(String usuarioId) async {
    return await _reporteRepository.getReporteSostenibilidad(usuarioId);
  }
}