import '../entities/soporte_entity.dart';
import '../../data/repositories/soporte_repository.dart';

class SoporteUsecases {
  final SoporteRepository _soporteRepository;

  SoporteUsecases(this._soporteRepository);

  // Enviar una solicitud de soporte
  Future<void> enviarSoporte(String usuarioId, String mensaje) async {
    try {
      await _soporteRepository.enviarSoporte(usuarioId, mensaje);
    } catch (e) {
      throw Exception('Error al enviar la solicitud de soporte: $e');
    }
  }

  // Obtener el historial de solicitudes de soporte (opcional)
  Future<List<SoporteEntity>> obtenerHistorialSoporte(String usuarioId) async {
    try {
      final historial =
          await _soporteRepository.obtenerHistorialSoporte(usuarioId);
      return historial;
    } catch (e) {
      throw Exception('Error al obtener el historial de soporte: $e');
    }
  }
}
