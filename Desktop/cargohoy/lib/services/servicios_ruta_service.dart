import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/models/servicio_ruta_model.dart';

class ServiciosRutaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Buscar servicios cercanos por tipo
  Future<List<ServicioRutaModel>> buscarServiciosCercanos({
    required LatLng ubicacionActual,
    required String tipo,
    double radioKm = 50.0,
    bool solo24h = false,
  }) async {
    try {
      // Crear un bounds para la búsqueda
      final center = GeoPoint(ubicacionActual.latitude, ubicacionActual.longitude);
      final bounds = _calculateBounds(center, radioKm);

      var query = _firestore
          .collection('servicios_ruta')
          .where('tipo', isEqualTo: tipo)
          .where('ubicacion',
              isGreaterThan: GeoPoint(bounds['south']!, bounds['west']!))
          .where('ubicacion',
              isLessThan: GeoPoint(bounds['north']!, bounds['east']!));

      if (solo24h) {
        query = query.where('disponible24h', isEqualTo: true);
      }

      final snapshot = await query.get();
      final servicios = snapshot.docs
          .map((doc) => ServicioRutaModel.fromJson(doc.data()))
          .toList();

      // Filtrar por distancia exacta
      return servicios.where((servicio) {
        final distancia = _calcularDistancia(
          ubicacionActual,
          LatLng(
            servicio.ubicacion.latitude,
            servicio.ubicacion.longitude,
          ),
        );
        return distancia <= radioKm;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar servicios cercanos: $e');
    }
  }

  // Solicitar servicio de emergencia
  Future<void> solicitarServicioEmergencia({
    required String servicioId,
    required String transportistaId,
    required LatLng ubicacion,
    required String tipoEmergencia,
    required String descripcion,
    List<String>? imagenes,
  }) async {
    try {
      await _firestore.collection('solicitudes_servicio').add({
        'servicioId': servicioId,
        'transportistaId': transportistaId,
        'ubicacion': GeoPoint(ubicacion.latitude, ubicacion.longitude),
        'tipoEmergencia': tipoEmergencia,
        'descripcion': descripcion,
        'imagenes': imagenes ?? [],
        'estado': 'pendiente',
        'fechaSolicitud': DateTime.now(),
        'fechaAtencion': null,
        'costoEstimado': null,
      });
    } catch (e) {
      throw Exception('Error al solicitar servicio de emergencia: $e');
    }
  }

  // Obtener estado de la solicitud
  Stream<Map<String, dynamic>> obtenerEstadoSolicitud(String solicitudId) {
    return _firestore
        .collection('solicitudes_servicio')
        .doc(solicitudId)
        .snapshots()
        .map((doc) => doc.data() ?? {});
  }

  // Calificar servicio
  Future<void> calificarServicio({
    required String servicioId,
    required String transportistaId,
    required double calificacion,
    String? comentario,
  }) async {
    try {
      await _firestore.collection('calificaciones_servicio').add({
        'servicioId': servicioId,
        'transportistaId': transportistaId,
        'calificacion': calificacion,
        'comentario': comentario,
        'fecha': DateTime.now(),
      });

      // Actualizar calificación promedio
      final servicioRef = _firestore.collection('servicios_ruta').doc(servicioId);
      await _firestore.runTransaction((transaction) async {
        final servicioDoc = await transaction.get(servicioRef);
        final calificaciones = await _firestore
            .collection('calificaciones_servicio')
            .where('servicioId', isEqualTo: servicioId)
            .get();

        final promedio = calificaciones.docs
            .map((doc) => doc.data()['calificacion'] as double)
            .reduce((a, b) => a + b) / calificaciones.docs.length;

        transaction.update(servicioRef, {'calificacionPromedio': promedio});
      });
    } catch (e) {
      throw Exception('Error al calificar servicio: $e');
    }
  }

  // Reportar problema con servicio
  Future<void> reportarProblema({
    required String servicioId,
    required String transportistaId,
    required String tipoProblema,
    required String descripcion,
    List<String>? evidencias,
  }) async {
    try {
      await _firestore.collection('reportes_servicio').add({
        'servicioId': servicioId,
        'transportistaId': transportistaId,
        'tipoProblema': tipoProblema,
        'descripcion': descripcion,
        'evidencias': evidencias ?? [],
        'estado': 'pendiente',
        'fecha': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error al reportar problema: $e');
    }
  }

  // Métodos auxiliares
  Map<String, double> _calculateBounds(GeoPoint center, double radiusKm) {
    // Aproximación simple: 1 grado = 111km
    final lat = radiusKm / 111.0;
    final lon = radiusKm / (111.0 * cos(center.latitude * pi / 180));

    return {
      'north': center.latitude + lat,
      'south': center.latitude - lat,
      'east': center.longitude + lon,
      'west': center.longitude - lon,
    };
  }

  double _calcularDistancia(LatLng start, LatLng end) {
    // Implementar fórmula de Haversine
    // Retorna distancia en kilómetros
    return 0.0; // Implementar cálculo real
  }
} 