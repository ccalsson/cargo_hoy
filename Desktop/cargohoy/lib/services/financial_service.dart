import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/servicio_financiero_model.dart';

class FinancialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Solicitar adelanto de pago con quita
  Future<ServicioFinancieroModel> solicitarAdelanto({
    required String cargaId,
    required double montoTotal,
    required double montoAdelanto,
    required String metodoPago,
  }) async {
    try {
      // Calcular porcentaje de quita basado en el plazo y monto
      final porcentajeQuita = _calcularQuita(montoTotal, montoAdelanto);
      
      // Crear solicitud de servicio financiero
      final servicio = ServicioFinancieroModel(
        id: DateTime.now().toString(),
        cargaId: cargaId,
        transportistaId: 'current_user_id',
        montoTotal: montoTotal,
        montoAdelanto: montoAdelanto,
        porcentajeQuita: porcentajeQuita,
        metodoPago: metodoPago,
        diasPlazo: 0, // Pago inmediato
        estado: 'pendiente',
        fechaSolicitud: DateTime.now(),
        documentosRespaldo: [],
        datosFacturacion: {},
      );

      // Guardar en Firestore
      await _firestore
          .collection('servicios_financieros')
          .doc(servicio.id)
          .set(servicio.toJson());

      return servicio;
    } catch (e) {
      throw Exception('Error al solicitar adelanto: $e');
    }
  }

  // Calcular porcentaje de quita basado en diferentes factores
  double _calcularQuita(double montoTotal, double montoAdelanto) {
    double porcentajeBase = 5.0; // 5% base
    
    // Ajustar según el monto total
    if (montoTotal > 10000) porcentajeBase -= 0.5;
    if (montoTotal > 50000) porcentajeBase -= 0.5;
    
    // Ajustar según el porcentaje solicitado como adelanto
    double porcentajeSolicitado = (montoAdelanto / montoTotal) * 100;
    if (porcentajeSolicitado <= 50) porcentajeBase -= 1.0;
    
    return porcentajeBase;
  }

  // Procesar pago a plazo (15 o 30 días)
  Future<void> procesarPagoAPlazo({
    required String cargaId,
    required double montoTotal,
    required int diasPlazo,
    required Map<String, dynamic> datosFacturacion,
  }) async {
    try {
      final servicio = ServicioFinancieroModel(
        id: DateTime.now().toString(),
        cargaId: cargaId,
        transportistaId: 'current_user_id',
        montoTotal: montoTotal,
        montoAdelanto: 0,
        porcentajeQuita: 0,
        metodoPago: 'cheque',
        diasPlazo: diasPlazo,
        estado: 'pendiente',
        fechaSolicitud: DateTime.now(),
        documentosRespaldo: [],
        datosFacturacion: datosFacturacion,
      );

      await _firestore
          .collection('servicios_financieros')
          .doc(servicio.id)
          .set(servicio.toJson());
    } catch (e) {
      throw Exception('Error al procesar pago a plazo: $e');
    }
  }
} 