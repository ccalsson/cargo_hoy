import 'package:cargohoy/data/models/servicio_model.dart';

import '../../data/repositories/servicio_repository.dart';

class ServicioUsecases {
  final ServicioRepository _servicioRepository;

  ServicioUsecases(this._servicioRepository);

  // Obtener lista de servicios
  Future<List<ServicioModel>> getServicios() async {
    return await _servicioRepository.getServicios();
  }

  // Obtener detalles de un servicio
  Future<ServicioModel> getServicioById(String id) async {
    return await _servicioRepository.getServicioById(id);
  }

  // Reservar un servicio
  Future<void> reserveServicio(String servicioId, String usuarioId) async {
    return await _servicioRepository.reserveServicio(servicioId, usuarioId);
  }
}
