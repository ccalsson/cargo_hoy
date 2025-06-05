import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/documentacion_internacional_model.dart';

class DocumentacionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Verificar habilitación internacional
  Future<bool> verificarHabilitacionInternacional(
    String transportistaId,
    String vehiculoId,
    List<String> paisesDestino,
  ) async {
    try {
      final doc = await _firestore
          .collection('documentacion_internacional')
          .where('transportistaId', isEqualTo: transportistaId)
          .where('vehiculoId', isEqualTo: vehiculoId)
          .get();

      if (doc.docs.isEmpty) return false;

      final documentacion = doc.docs.first.data();
      
      // Verificar que todos los documentos estén vigentes
      bool documentosVigentes = true;
      final docs = documentacion['documentos'] as Map<String, dynamic>;
      for (var doc in docs.values) {
        if (doc['estado'] != 'vigente') {
          documentosVigentes = false;
          break;
        }
      }

      // Verificar habilitación para países destino
      final paisesHabilitados = List<String>.from(documentacion['paisesHabilitados']);
      bool paisesAutorizados = paisesDestino.every(
        (pais) => paisesHabilitados.contains(pais)
      );

      return documentosVigentes && paisesAutorizados;
    } catch (e) {
      throw Exception('Error al verificar habilitación: $e');
    }
  }

  // Notificar vencimientos próximos
  Future<List<DocumentoInternacional>> verificarVencimientosCercanos(
    String transportistaId,
  ) async {
    try {
      final docs = await _firestore
          .collection('documentacion_internacional')
          .where('transportistaId', isEqualTo: transportistaId)
          .get();

      List<DocumentoInternacional> documentosProximosVencer = [];
      final ahora = DateTime.now();

      for (var doc in docs.docs) {
        final documentacion = doc.data();
        final documentos = documentacion['documentos'] as Map<String, dynamic>;

        for (var documento in documentos.values) {
          final fechaVencimiento = DateTime.parse(documento['fechaVencimiento']);
          final diasHastaVencimiento = fechaVencimiento.difference(ahora).inDays;

          if (diasHastaVencimiento <= 30 && diasHastaVencimiento > 0) {
            documentosProximosVencer.add(DocumentoInternacional(
              tipo: documento['tipo'],
              numero: documento['numero'],
              fechaEmision: DateTime.parse(documento['fechaEmision']),
              fechaVencimiento: fechaVencimiento,
              entidadEmisora: documento['entidadEmisora'],
              estado: documento['estado'],
              urlDocumento: documento['urlDocumento'],
            ));
          }
        }
      }

      return documentosProximosVencer;
    } catch (e) {
      throw Exception('Error al verificar vencimientos: $e');
    }
  }
} 