import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  // Iniciar sesión
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Registrar usuario
  Future<UserModel> register(UserModel user, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      body: jsonEncode(user.toJson()..['password'] = password),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar usuario');
    }
  }
}
