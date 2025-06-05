       import 'dart:convert';
       import 'package:http/http.dart' as http;
       import '../models/ruta_model.dart';
       
       class RutaRepository {
         final String _baseUrl = "https://api.cargohoy.com"; // URL de la API
       
         Future<RutaModel> getRuta(String origen, String destino) async {
           final response = await http.get(Uri.parse('$_baseUrl/rutas?origen=$origen&destino=$destino'));
           if (response.statusCode == 200) {
             return RutaModel.fromJson(jsonDecode(response.body));
           } else {
             throw Exception('Error al obtener la ruta');
           }
         }
       }