import 'package:cargohoy/domain/entities/pago_entity.dart';

import '../../data/repositories/pago_repository.dart';

class PagoUsecases {
  final PagoRepository _pagoRepository;

  PagoUsecases(this._pagoRepository);

  // Crear un pago
  Future<PagoEntity> createPayment(
      double monto, String moneda, String descripcion) async {
    final pagoModel = await _pagoRepository.createPayment(monto, moneda, descripcion);
    return PagoEntity(
      id: pagoModel.id,
      monto: pagoModel.monto,
      moneda: pagoModel.moneda,
      descripcion: pagoModel.descripcion,
      fecha: pagoModel.fecha,
    );
  }

  // Obtener historial de pagos
  Future<List<PagoEntity>> getPaymentHistory(String usuarioId) async {
    final pagoModels = await _pagoRepository.getPaymentHistory(usuarioId);
    return pagoModels.map((pagoModel) => PagoEntity(
      id: pagoModel.id,
      monto: pagoModel.monto,
      moneda: pagoModel.moneda,
      descripcion: pagoModel.descripcion,
      fecha: pagoModel.fecha,
    )).toList();
  }
}
