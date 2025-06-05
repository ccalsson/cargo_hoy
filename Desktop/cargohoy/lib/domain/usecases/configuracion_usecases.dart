import 'package:cargohoy/data/models/configuracion_model.dart';
import 'package:cargohoy/data/models/configuracion_repository.dart';
import 'package:cargohoy/domain/entities/configuracion%20entity.dart';

class ConfiguracionUsecases {
  final ConfiguracionRepository _configuracionRepository;

  ConfiguracionUsecases(this._configuracionRepository);

  Future<ConfiguracionModel> getConfiguracion(String usuarioId) async {
    return await _configuracionRepository.getConfiguracion(usuarioId);
  }

  Future<void> updateConfiguracion(ConfiguracionEntity configuracion) async {
    return await _configuracionRepository
        .updateConfiguracion(configuracion as ConfiguracionModel);
  }
}
