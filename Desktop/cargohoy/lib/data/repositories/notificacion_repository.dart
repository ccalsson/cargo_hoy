import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notificacion_model.dart';

class NotificacionRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  // Obtener lista de notificaciones
  Future<List<NotificacionModel>> getNotificaciones(String usuarioId) async {
    final response = await http.get(Uri.parse('$_baseUrl/notificaciones?usuarioId=$usuarioId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NotificacionModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener notificaciones');
    }
  }

  // Marcar notificación como leída
  Future<void> markAsRead(String notificacionId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/notificaciones/$notificacionId/mark-as-read'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar la notificación como leída');
    }
  }
}