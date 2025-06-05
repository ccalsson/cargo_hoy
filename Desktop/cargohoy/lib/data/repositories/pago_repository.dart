import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pago_model.dart';

class PagoRepository {
  final String _baseUrl = "https://api.cargohoy.com";

  Future<PagoModel> createPayment(
      double monto, String moneda, String descripcion) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pagos'),
      body: jsonEncode({
        'monto': monto,
        'moneda': moneda,
        'descripcion': descripcion,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return PagoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear el pago');
    }
  }

  Future<List<PagoModel>> getPaymentHistory(String usuarioId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/pagos?usuarioId=$usuarioId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PagoModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener el historial de pagos');
    }
  }
}
