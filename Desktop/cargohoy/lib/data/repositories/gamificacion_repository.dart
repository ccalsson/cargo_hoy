import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gamificacion_model.dart';

class GamificacionRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  // Obtener datos de gamificación
  Future<GamificacionModel> getGamificacion(String usuarioId) async {
    final response = await http.get(Uri.parse('$_baseUrl/gamificacion?usuarioId=$usuarioId'));

    if (response.statusCode == 200) {
      return GamificacionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener datos de gamificación');
    }
  }

  // Canjear puntos por recompensa
  Future<void> canjearRecompensa(String usuarioId, String recompensa) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/gamificacion/canjear'),
      body: jsonEncode({'usuarioId': usuarioId, 'recompensa': recompensa}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al canjear recompensa');
    }
  }
}