import '../../data/repositories/suscripcion_repository.dart';

class SuscripcionUsecases {
  final SuscripcionRepository _suscripcionRepository;

  SuscripcionUsecases(this._suscripcionRepository);

  // Crear una suscripción
  Future<SuscripcionEntity> createSubscription(String plan) async {
    return await _suscripcionRepository.createSubscription(plan);
  }

  // Cancelar una suscripción
  Future<void> cancelSubscription(String subscriptionId) async {
    return await _suscripcionRepository.cancelSubscription(subscriptionId);
  }
}
