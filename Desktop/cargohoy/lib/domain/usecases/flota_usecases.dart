import '../entities/camion_entity.dart';
import '../../data/repositories/flota_repository.dart';
import '../entities/flota_entity.dart';

class FlotaUsecases {
  final FlotaRepository _flotaRepository;

  FlotaUsecases(this._flotaRepository);

  // Obtener lista de flotas
  Future<List<FlotaEntity>> getFlotas(String duenoId) async {
    return _flotaRepository.getFlotas(duenoId);
  }

  // Obtener detalles de una flota
  Future<FlotaEntity> getFlotaById(String id) async {
    return Future.value(_flotaRepository.getFlotaById(id));
  }

  // Obtener detalles de un camión
  Future<CamionEntity> getCamionById(String id) async {
    return await _flotaRepository.getCamionById(id);
  }
}

// Removed duplicate FlotaEntity definition to avoid conflicts.
