import 'package:flutter/material.dart';
import '../../data/models/carga_model.dart';
import '../../data/repositories/carga_repository.dart';
import '../../domain/usecases/carga_usecases.dart';

class CargaProvider with ChangeNotifier {
  final CargaUsecases _cargaUsecases = CargaUsecases(CargaRepository());
  bool _isLoading = false;
  String _errorMessage = '';
  List<CargaModel> _cargas = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<CargaModel> get cargas => _cargas;

  Future<void> fetchCargas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cargasEntities = await _cargaUsecases.getCargas();
      _cargas = cargasEntities.map((entity) => CargaModel(
        id: entity.id,
        tipoCarga: entity.tipoCarga,
        peso: entity.peso,
        dimensiones: entity.dimensiones,
        origen: entity.origen,
        destino: entity.destino,
        fechaRecogida: DateTime.now(), // Valor temporal
        fechaEntrega: entity.fechaEntrega,
        estado: entity.estado,
        empresaId: entity.empresaId,
        conductorId: entity.conductorId,
        tarifa: 0.0, // Valor temporal
        metodoPago: '', // Valor temporal
        requisitosEspeciales: const [],
        imagenes: entity.imagenes,
        documentos: entity.documentos,
        tracking: const {},
        calificacion: 0.0,
        comentarios: const [],
        urgente: false,
        seguro: const {},
        restricciones: const {},
      )).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCarga(CargaModel carga) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _cargaUsecases.createCarga(carga);
      await fetchCargas(); // Actualizar la lista después de crear
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
