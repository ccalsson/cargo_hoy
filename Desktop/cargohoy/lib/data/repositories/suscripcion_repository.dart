import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/suscripcion_model.dart';

class SuscripcionRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  // Crear una suscripción
  Future<SuscripcionModel> createSubscription(String plan) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/subscriptions'),
      body: jsonEncode({'plan': plan}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return SuscripcionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear la suscripción');
    }
  }

  // Cancelar una suscripción
  Future<void> cancelSubscription(String subscriptionId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/subscriptions/$subscriptionId'));

    if (response.statusCode != 200) {
      throw Exception('Error al cancelar la suscripción');
    }
  }
}