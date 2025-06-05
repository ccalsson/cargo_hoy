       import 'dart:convert';
       import 'package:http/http.dart' as http;
       import '../models/configuracion_model.dart';
       
       class ConfiguracionRepository {
         final String _baseUrl = "https://api.cargohoy.com"; // URL de la API
       
         Future<ConfiguracionModel> getConfiguracion(String usuarioId) async {
           final response = await http.get(Uri.parse('$_baseUrl/configuracion?usuarioId=$usuarioId'));
           if (response.statusCode == 200) {
             return ConfiguracionModel.fromJson(jsonDecode(response.body));
           } else {
             throw Exception('Error al obtener la configuración');
           }
         }
       
         Future<void> updateConfiguracion(ConfiguracionModel configuracion) async {
           final response = await http.put(
             Uri.parse('$_baseUrl/configuracion'),
             body: jsonEncode(configuracion.toJson()),
             headers: {'Content-Type': 'application/json'},
           );
           if (response.statusCode != 200) {
             throw Exception('Error al actualizar la configuración');
           }
         }
       }