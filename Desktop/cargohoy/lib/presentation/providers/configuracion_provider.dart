import 'package:cargohoy/data/models/configuracion_model.dart';
import 'package:cargohoy/data/repositories/configuracion_repository.dart';
import 'package:cargohoy/domain/entities/configuracion_entity.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/configuracion_usecases.dart';

class ConfiguracionProvider with ChangeNotifier {
  final ConfiguracionUsecases _configuracionUsecases =
      ConfiguracionUsecases(ConfiguracionRepository());
  ConfiguracionModel? _configuracion;
  bool _isLoading = false;
  String _errorMessage = '';

  ConfiguracionModel? get configuracion => _configuracion;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchConfiguracion(String usuarioId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _configuracion = await _configuracionUsecases.getConfiguracion(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConfiguracion(ConfiguracionModel configuracion) async {
    _isLoading = true;
    notifyListeners();
    try {
      final configuracionEntity = ConfiguracionEntity(
        id: configuracion.id,
        usuarioId: configuracion.usuarioId,
        notificacionesActivas: configuracion.notificacionesActivas,
        tema: configuracion.tema,
      );
      await _configuracionUsecases.updateConfiguracion(configuracionEntity);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
