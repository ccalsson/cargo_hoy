import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/anticipo_model.dart';

class AnticipoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear una nueva solicitud de anticipo
  Future<Anticipo> createAnticipo({
    required String userId,
    required String tripId,
    required double monto,
    required double comision,
  }) async {
    final docRef = _firestore.collection('anticipos').doc();

    final anticipo = Anticipo(
      id: docRef.id,
      userId: userId,
      tripId: tripId,
      monto: monto,
      comision: comision,
      estado: AnticipoEstado.pendiente,
      fechaSolicitud: DateTime.now(),
    );

    await docRef.set(anticipo.toMap());
    return anticipo;
  }

  // Obtener todos los anticipos de un usuario
  Stream<List<Anticipo>> getAnticiposByUser(String userId) {
    return _firestore
        .collection('anticipos')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Anticipo.fromMap(doc.data())).toList());
  }

  // Obtener todos los anticipos pendientes (para admin)
  Stream<List<Anticipo>> getAnticiposPendientes() {
    return _firestore
        .collection('anticipos')
        .where('estado', isEqualTo: AnticipoEstado.pendiente.toString())
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Anticipo.fromMap(doc.data())).toList());
  }

  // Actualizar estado de un anticipo
  Future<void> updateAnticipoEstado({
    required String anticipoId,
    required AnticipoEstado nuevoEstado,
    DateTime? fechaPago,
    String? notas,
  }) async {
    final updates = {
      'estado': nuevoEstado.toString(),
      if (fechaPago != null) 'fechaPago': fechaPago.toIso8601String(),
      if (notas != null) 'notas': notas,
    };

    await _firestore.collection('anticipos').doc(anticipoId).update(updates);
  }

  // Calcular comisión según plazo
  double calcularComision(int diasPlazo) {
    if (diasPlazo <= 7) return 0.03; // 3%
    if (diasPlazo <= 15) return 0.05; // 5%
    return 0.10; // 10%
  }

  // Obtener resumen de anticipos para un usuario
  Future<Map<String, dynamic>> getResumenAnticipos(String userId) async {
    final snapshot = await _firestore
        .collection('anticipos')
        .where('userId', isEqualTo: userId)
        .get();

    double totalSolicitado = 0;
    double totalComision = 0;
    double totalPendiente = 0;

    for (var doc in snapshot.docs) {
      final anticipo = Anticipo.fromMap(doc.data());
      totalSolicitado += anticipo.monto;
      totalComision += anticipo.monto * anticipo.comision;

      if (anticipo.estado == AnticipoEstado.pendiente) {
        totalPendiente += anticipo.montoNeto;
      }
    }

    return {
      'totalSolicitado': totalSolicitado,
      'totalComision': totalComision,
      'totalPendiente': totalPendiente,
      'saldoDisponible': totalSolicitado - totalComision - totalPendiente,
    };
  }
}
