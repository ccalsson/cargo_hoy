import '../../data/repositories/carga_repository.dart';
import '../../data/models/carga_model.dart';
import '../entities/carga_entity.dart';

class CargaUsecases {
  final CargaRepository _repository;

  CargaUsecases(this._repository);

  Future<List<CargaEntity>> getCargas() async {
    final cargas = await _repository.getCargas();
    return cargas.map((carga) => CargaEntity(
      id: carga.id,
      tipoCarga: carga.tipoCarga,
      peso: carga.peso,
      dimensiones: carga.dimensiones,
      origen: carga.origen,
      destino: carga.destino,
      fechaEntrega: carga.fechaEntrega,
      estado: carga.estado,
      empresaId: carga.empresaId,
      conductorId: carga.conductorId,
      imagenes: carga.imagenes,
      documentos: carga.documentos,
    )).toList();
  }

  Future<void> createCarga(CargaModel carga) async {
    await _repository.createCarga(carga);
  }
}
