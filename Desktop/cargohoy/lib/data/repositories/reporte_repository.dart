import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reporte_model.dart';

class ReporteRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  // Obtener reporte de desempeño
  Future<ReporteModel> getReporteDesempeno(String usuarioId) async {
    final response = await http.get(Uri.parse('$_baseUrl/reportes/desempeno?usuarioId=$usuarioId'));

    if (response.statusCode == 200) {
      return ReporteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el reporte de desempeño');
    }
  }

  // Obtener reporte de sostenibilidad
  Future<ReporteModel> getReporteSostenibilidad(String usuarioId) async {
    final response = await http.get(Uri.parse('$_baseUrl/reportes/sostenibilidad?usuarioId=$usuarioId'));

    if (response.statusCode == 200) {
      return ReporteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el reporte de sostenibilidad');
    }
  }
}