import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servicio_model.dart';

class ServicioRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  // Obtener lista de servicios
  Future<List<ServicioModel>> getServicios() async {
    final response = await http.get(Uri.parse('$_baseUrl/servicios'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ServicioModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener servicios');
    }
  }

  // Obtener detalles de un servicio
  Future<ServicioModel> getServicioById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/servicios/$id'));

    if (response.statusCode == 200) {
      return ServicioModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el servicio');
    }
  }

  // Reservar un servicio
  Future<void> reserveServicio(String servicioId, String usuarioId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/servicios/reserve'),
      body: jsonEncode({'servicioId': servicioId, 'usuarioId': usuarioId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al reservar el servicio');
    }
  }
}