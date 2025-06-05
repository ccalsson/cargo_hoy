       import 'dart:convert';
       import 'package:http/http.dart' as http;
       import '../models/perfil_model.dart';
       
       class PerfilRepository {
         final String _baseUrl = "https://api.cargohoy.com"; // URL de la API
       
         Future<PerfilModel> getPerfil(String usuarioId) async {
           final response = await http.get(Uri.parse('$_baseUrl/perfil?usuarioId=$usuarioId'));
           if (response.statusCode == 200) {
             return PerfilModel.fromJson(jsonDecode(response.body));
           } else {
             throw Exception('Error al obtener el perfil');
           }
         }
       
         Future<void> updatePerfil(PerfilModel perfil) async {
           final response = await http.put(
             Uri.parse('$_baseUrl/perfil'),
             body: jsonEncode(perfil.toJson()),
             headers: {'Content-Type': 'application/json'},
           );
           if (response.statusCode != 200) {
             throw Exception('Error al actualizar el perfil');
           }
         }
       }