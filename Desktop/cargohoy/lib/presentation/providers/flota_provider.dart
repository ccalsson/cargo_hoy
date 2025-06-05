import 'package:flutter/material.dart';
import '../../data/models/flota_model.dart';

class FlotaProvider with ChangeNotifier {
  bool _isLoading = false;
  List<FlotaModel> _flotas = [];

  bool get isLoading => _isLoading;
  List<FlotaModel> get flotas => _flotas;

  Future<void> fetchFlotas(String duenoId) async {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement actual API call
    _flotas = [
      FlotaModel(
        id: '1',
        duenoId: duenoId,
        membresia: 'Premium',
        camiones: ['1', '2', '3'],
        fechaRegistro: DateTime.now(),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Define your state variables here
  final List<String> _flota = [];

  // Getter for the state variables
  List<String> get flota => _flota;

  // Method to add a new item to the flota
  void addFlota(String item) {
    _flota.add(item);
    notifyListeners();
  }

  // Method to remove an item from the flota
  void removeFlota(String item) {
    _flota.remove(item);
    notifyListeners();
  }

  Future<FlotaModel> getFlotaById(String flotaId) async {
    // TODO: Implement actual API call
    return FlotaModel(
      id: flotaId,
      duenoId: 'user123', // TODO: Get from auth
      membresia: 'Premium',
      camiones: ['1', '2', '3'],
      fechaRegistro: DateTime.now(),
    );
  }

  getCamionById(String camionId) {}
}
