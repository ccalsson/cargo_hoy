import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioRutaModel {
  final String id;
  final String tipo; // auxilio, gomeria, combustible, mecanico, etc.
  final String nombre;
  final String descripcion;
  final GeoPoint ubicacion;
  final String direccion;
  final String telefono;
  final bool disponible24h;
  final List<String> serviciosOfrecidos;
  final Map<String, dynamic> horarios;
  final double calificacionPromedio;
  final List<String> metodoPago;
  final Map<String, dynamic> precios;
  final bool servicioMovil; // Si ofrece servicio en ruta
  final double radioCobertura; // En kilómetros para servicio móvil
  final List<String> certificaciones;
  final Map<String, dynamic> convenios; // Convenios con aseguradoras/empresas

  ServicioRutaModel({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.direccion,
    required this.telefono,
    required this.disponible24h,
    required this.serviciosOfrecidos,
    required this.horarios,
    required this.calificacionPromedio,
    required this.metodoPago,
    required this.precios,
    required this.servicioMovil,
    required this.radioCobertura,
    required this.certificaciones,
    required this.convenios,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'nombre': nombre,
        'descripcion': descripcion,
        'ubicacion': ubicacion,
        'direccion': direccion,
        'telefono': telefono,
        'disponible24h': disponible24h,
        'serviciosOfrecidos': serviciosOfrecidos,
        'horarios': horarios,
        'calificacionPromedio': calificacionPromedio,
        'metodoPago': metodoPago,
        'precios': precios,
        'servicioMovil': servicioMovil,
        'radioCobertura': radioCobertura,
        'certificaciones': certificaciones,
        'convenios': convenios,
      };
}
