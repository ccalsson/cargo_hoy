import 'package:cargohoy/data/models/gamificacion_model.dart';

import '../../data/repositories/gamificacion_repository.dart';

class GamificacionUsecases {
  final GamificacionRepository _gamificacionRepository;

  GamificacionUsecases(this._gamificacionRepository);

  // Obtener datos de gamificación
  Future<GamificacionModel> getGamificacion(String usuarioId) async {
    return await _gamificacionRepository.getGamificacion(usuarioId);
  }

  // Canjear puntos por recompensa
  Future<void> canjearRecompensa(String usuarioId, String recompensa) async {
    return await _gamificacionRepository.canjearRecompensa(
        usuarioId, recompensa);
  }
}
