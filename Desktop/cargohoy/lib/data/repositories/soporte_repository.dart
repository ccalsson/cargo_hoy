import 'package:cargohoy/entities/soporte_entity.dart';

class SoporteRepository {
  final String _baseUrl = "https://api.cargohoy.com"; // URL de la API

  Future<void> enviarSoporte(String usuarioId, String mensaje) async {
    final url = '$_baseUrl/soporte/enviar'; // Example usage of _baseUrl
    // Implementar lógica de API usando la URL
  }

  Future<List<SoporteEntity>> obtenerHistorialSoporte(String usuarioId) async {
    final url =
        '$_baseUrl/soporte/historial/$usuarioId'; // Example usage of _baseUrl
    // Implementar lógica de API usando la URL
    return [];
  }

  Future<void> enviarMensajeSoporte(String usuarioId, String mensaje) async {
    // Implementar lógica de API
  }

  Future<List<SoporteEntity>> obtenerHistorialMensajesSoporte(
      String usuarioId) async {
    // Implementar lógica de API
    return [];
  }
}
