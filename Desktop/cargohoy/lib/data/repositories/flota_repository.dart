import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cargohoy/domain/entities/flota_entity.dart';
import 'package:cargohoy/domain/entities/camion_entity.dart';

class FlotaRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  Future<List<FlotaEntity>> getFlotas(String duenoId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/flotas?duenoId=$duenoId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FlotaEntity.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener flotas');
    }
  }

  Future<FlotaEntity> getFlotaById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/flotas/$id'));
    if (response.statusCode == 200) {
      return FlotaEntity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la flota');
    }
  }

  Future<CamionEntity> getCamionById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/camiones/$id'));
    if (response.statusCode == 200) {
      return CamionEntity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el camión');
    }
  }
}
