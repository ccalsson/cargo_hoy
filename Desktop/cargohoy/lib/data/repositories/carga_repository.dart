import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carga_model.dart';

class CargaRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // Reemplazar con tu URL real

  Future<List<CargaModel>> getCargas() async {
    try {
      // Simulación de llamada API
      await Future.delayed(const Duration(seconds: 1));
      return [];
    } catch (e) {
      throw Exception('Error al obtener las cargas: $e');
    }
  }

  Future<CargaModel> getCargaById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/cargas/$id'));
    if (response.statusCode == 200) {
      return CargaModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la carga');
    }
  }

  Future<CargaModel> createCarga(CargaModel carga) async {
    try {
      // Simulación de llamada API
      await Future.delayed(const Duration(seconds: 1));
      return carga;
    } catch (e) {
      throw Exception('Error al crear la carga: $e');
    }
  }
}
