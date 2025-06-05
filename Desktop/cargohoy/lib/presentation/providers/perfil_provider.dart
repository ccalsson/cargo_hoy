import 'package:cargohoy/data/models/perfil_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/perfil_repository.dart';
import '../../domain/usecases/perfil_usecases.dart';

class PerfilProvider with ChangeNotifier {
  final PerfilUsecases _perfilUsecases = PerfilUsecases(PerfilRepository());
  PerfilModel? _perfil;
  bool _isLoading = false;
  String _errorMessage = '';

  PerfilModel? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPerfil(String usuarioId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _perfil = await _perfilUsecases.getPerfil(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePerfil(PerfilModel perfil) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _perfilUsecases.updatePerfil(perfil);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
