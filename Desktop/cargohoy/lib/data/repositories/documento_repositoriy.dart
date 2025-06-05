import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/documento_model.dart';

class DocumentoRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  Future<List<DocumentoModel>> getDocumentos(String usuarioId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/documentos?usuarioId=$usuarioId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DocumentoModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener documentos');
    }
  }

  Future<void> uploadDocumento(
      String usuarioId, String nombre, String url) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/documentos'),
      body: jsonEncode({'usuarioId': usuarioId, 'nombre': nombre, 'url': url}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Error al subir el documento');
    }
  }
}
