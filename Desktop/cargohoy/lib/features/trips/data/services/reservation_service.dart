import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/trip.dart';
import '../../../auth/domain/models/user_model.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reservar un viaje
  Future<Reservation> reserveTrip({
    required String userId,
    required String tripId,
    required int priority,
  }) async {
    try {
      // Obtener el usuario y el viaje
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();

      if (!userDoc.exists || !tripDoc.exists) {
        throw Exception('Usuario o viaje no encontrado');
      }

      final user = UserModel.fromFirestore(userDoc);
      final trip = Trip.fromFirestore(tripDoc);

      // Verificar si el usuario puede reservar
      if (!user.canReserve) {
        throw Exception('Usuario no puede realizar reservas');
      }

      // Verificar si el viaje está disponible
      if (trip.status != TripStatus.available) {
        throw Exception('El viaje no está disponible');
      }

      // Verificar si hay espacio para la reserva
      if (priority == 1 && trip.reservedBy1 != null) {
        throw Exception('El primer lugar ya está reservado');
      }
      if (priority == 2 && trip.reservedBy2 != null) {
        throw Exception('El segundo lugar ya está reservado');
      }

      // Verificar límite de reservas del usuario
      if (user.maxReservations != -1 &&
          user.activeReservations.length >= user.maxReservations) {
        throw Exception('Límite de reservas alcanzado');
      }

      // Verificar tokens si es necesario
      if (!user.hasUnlimitedTokens && user.reservationTokens <= 0) {
        throw Exception('No hay tokens disponibles');
      }

      // Crear la reserva
      final reservation = Reservation(
        reservationId: _firestore.collection('reservations').doc().id,
        tripId: tripId,
        userId: userId,
        priority: priority,
        status: ReservationStatus.standby,
        createdAt: DateTime.now(),
        expiresAt: trip.startsAt.subtract(const Duration(hours: 1)),
        confirmed: false,
      );

      // Actualizar el viaje
      await _firestore.collection('trips').doc(tripId).update({
        priority == 1 ? 'reservedBy1' : 'reservedBy2': userId,
        'status': TripStatus.reserved.toString().split('.').last,
      });

      // Guardar la reserva
      await _firestore
          .collection('reservations')
          .doc(reservation.reservationId)
          .set(reservation.toMap());

      // Actualizar el usuario
      await _firestore.collection('users').doc(userId).update({
        'activeReservations':
            FieldValue.arrayUnion([reservation.reservationId]),
        if (!user.hasUnlimitedTokens)
          'reservationTokens': FieldValue.increment(-1),
      });

      return reservation;
    } catch (e) {
      debugPrint('Error al reservar viaje: $e');
      rethrow;
    }
  }

  // Cancelar una reserva
  Future<void> cancelReservation({
    required String reservationId,
    required String userId,
  }) async {
    try {
      final reservationDoc =
          await _firestore.collection('reservations').doc(reservationId).get();

      if (!reservationDoc.exists) {
        throw Exception('Reserva no encontrada');
      }

      final reservation = Reservation.fromFirestore(reservationDoc);
      if (reservation.userId != userId) {
        throw Exception('No autorizado para cancelar esta reserva');
      }

      if (!reservation.canBeCancelled) {
        throw Exception('La reserva no puede ser cancelada');
      }

      final tripDoc =
          await _firestore.collection('trips').doc(reservation.tripId).get();

      if (!tripDoc.exists) {
        throw Exception('Viaje no encontrado');
      }

      final trip = Trip.fromFirestore(tripDoc);
      final now = DateTime.now();
      final hoursUntilTrip = trip.startsAt.difference(now).inHours;

      // Calcular penalización
      Map<String, dynamic> penalty = {};
      if (hoursUntilTrip < 12) {
        penalty = {
          'type': 'block',
          'endDate': Timestamp.fromDate(
            now.add(const Duration(hours: 48)),
          ),
        };
      } else if (hoursUntilTrip < 24) {
        penalty = {
          'type': 'lowPriority',
          'endDate': Timestamp.fromDate(
            now.add(const Duration(days: 3)),
          ),
        };
      }

      // Actualizar la reserva
      await _firestore.collection('reservations').doc(reservationId).update({
        'status': ReservationStatus.cancelled.toString().split('.').last,
      });

      // Actualizar el viaje
      final updates = <String, dynamic>{};
      if (reservation.priority == 1) {
        updates['reservedBy1'] = trip.reservedBy2;
        updates['reservedBy2'] = null;
      } else {
        updates['reservedBy2'] = null;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('trips').doc(trip.tripId).update(updates);
      }

      // Actualizar el usuario
      final userUpdates = <String, dynamic>{
        'activeReservations': FieldValue.arrayRemove([reservationId]),
      };

      if (penalty.isNotEmpty) {
        userUpdates['penalties'] = penalty;
      }

      await _firestore.collection('users').doc(userId).update(userUpdates);

      // Si era la primera reserva, promover la segunda
      if (reservation.priority == 1 && trip.reservedBy2 != null) {
        final secondReservation = await _firestore
            .collection('reservations')
            .where('tripId', isEqualTo: trip.tripId)
            .where('userId', isEqualTo: trip.reservedBy2)
            .get();

        if (secondReservation.docs.isNotEmpty) {
          await _firestore
              .collection('reservations')
              .doc(secondReservation.docs.first.id)
              .update({
            'priority': 1,
            'status': ReservationStatus.confirmed.toString().split('.').last,
            'confirmed': true,
          });
        }
      }
    } catch (e) {
      debugPrint('Error al cancelar reserva: $e');
      rethrow;
    }
  }

  // Obtener reservas activas de un usuario
  Stream<List<Reservation>> getUserActiveReservations(String userId) {
    return _firestore
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: [
          ReservationStatus.confirmed.toString().split('.').last,
          ReservationStatus.standby.toString().split('.').last,
        ])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromFirestore(doc))
            .toList());
  }

  // Obtener viajes disponibles
  Stream<List<Trip>> getAvailableTrips({
    GeoPoint? userLocation,
    double? maxDistance,
  }) {
    Query query = _firestore
        .collection('trips')
        .where('status',
            isEqualTo: TripStatus.available.toString().split('.').last)
        .where('startsAt', isGreaterThan: Timestamp.now());

    if (userLocation != null && maxDistance != null) {
      // TODO: Implementar búsqueda por distancia usando GeoFirestore
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Trip.fromFirestore(doc)).toList());
  }
}
