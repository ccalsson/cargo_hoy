import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/trip.dart';
import '../../domain/models/reservation.dart';
import '../../../auth/domain/models/user_model.dart';

class MatchingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Iniciar el proceso de matching para un viaje
  Future<void> startMatching(String tripId) async {
    try {
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists) {
        throw Exception('Viaje no encontrado');
      }

      final trip = Trip.fromFirestore(tripDoc);

      // Verificar que no haya reservas activas
      final activeReservations = await _firestore
          .collection('reservations')
          .where('tripId', isEqualTo: tripId)
          .where('status', whereIn: [
        ReservationStatus.confirmed.toString().split('.').last,
        ReservationStatus.standby.toString().split('.').last,
      ]).get();

      if (activeReservations.docs.isNotEmpty) {
        throw Exception('El viaje ya tiene reservas activas');
      }

      // Actualizar el estado del viaje
      await _firestore.collection('trips').doc(tripId).update({
        'matchingOpen': true,
        'status': TripStatus.available.toString().split('.').last,
      });

      // Buscar conductores cercanos
      await _findNearbyDrivers(trip);
    } catch (e) {
      debugPrint('Error al iniciar matching: $e');
      rethrow;
    }
  }

  // Buscar conductores cercanos al origen del viaje
  Future<void> _findNearbyDrivers(Trip trip) async {
    try {
      // TODO: Implementar búsqueda por distancia usando GeoFirestore
      // Por ahora, buscamos todos los conductores activos
      final drivers = await _firestore
          .collection('users')
          .where('membershipPlan', whereIn: [
            MembershipPlan.basic.toString().split('.').last,
            MembershipPlan.pro.toString().split('.').last,
            MembershipPlan.premium.toString().split('.').last,
          ])
          .where('location', isNull: false)
          .get();

      for (var driver in drivers.docs) {
        final user = UserModel.fromFirestore(driver);
        if (user.hasActivePenalty) continue;

        // TODO: Calcular distancia real
        // Por ahora, enviamos notificación a todos
        await _sendMatchingNotification(trip, user);
      }
    } catch (e) {
      debugPrint('Error al buscar conductores cercanos: $e');
      rethrow;
    }
  }

  // Enviar notificación de matching a un conductor
  Future<void> _sendMatchingNotification(Trip trip, UserModel driver) async {
    try {
      await _firestore.collection('matching_notifications').add({
        'tripId': trip.tripId,
        'userId': driver.id,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': FieldValue.serverTimestamp(), // 5 minutos
      });

      // TODO: Implementar notificación push
    } catch (e) {
      debugPrint('Error al enviar notificación: $e');
      rethrow;
    }
  }

  // Aceptar un viaje en matching
  Future<Reservation> acceptMatching({
    required String tripId,
    required String userId,
    required String notificationId,
  }) async {
    try {
      // Verificar que el matching sigue abierto
      final tripDoc = await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists) {
        throw Exception('Viaje no encontrado');
      }

      final trip = Trip.fromFirestore(tripDoc);
      if (!trip.matchingOpen) {
        throw Exception('El matching ya no está disponible');
      }

      // Verificar que no haya otras reservas activas
      final activeReservations = await _firestore
          .collection('reservations')
          .where('tripId', isEqualTo: tripId)
          .where('status', whereIn: [
        ReservationStatus.confirmed.toString().split('.').last,
        ReservationStatus.standby.toString().split('.').last,
      ]).get();

      if (activeReservations.docs.isNotEmpty) {
        throw Exception('El viaje ya fue asignado a otro conductor');
      }

      // Crear la reserva
      final reservation = Reservation(
        reservationId: _firestore.collection('reservations').doc().id,
        tripId: tripId,
        userId: userId,
        priority: 1,
        status: ReservationStatus.confirmed,
        createdAt: DateTime.now(),
        expiresAt: trip.startsAt,
        confirmed: true,
      );

      // Actualizar el viaje
      await _firestore.collection('trips').doc(tripId).update({
        'matchingOpen': false,
        'reservedBy1': userId,
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
      });

      // Marcar la notificación como aceptada
      await _firestore
          .collection('matching_notifications')
          .doc(notificationId)
          .update({
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      // Cancelar otras notificaciones pendientes
      await _firestore
          .collection('matching_notifications')
          .where('tripId', isEqualTo: tripId)
          .where('status', isEqualTo: 'pending')
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({
            'status': 'cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
          });
        }
      });

      return reservation;
    } catch (e) {
      debugPrint('Error al aceptar matching: $e');
      rethrow;
    }
  }

  // Rechazar un viaje en matching
  Future<void> rejectMatching({
    required String tripId,
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _firestore
          .collection('matching_notifications')
          .doc(notificationId)
          .update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error al rechazar matching: $e');
      rethrow;
    }
  }

  // Obtener notificaciones de matching pendientes para un usuario
  Stream<List<DocumentSnapshot>> getPendingMatchingNotifications(
      String userId) {
    return _firestore
        .collection('matching_notifications')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}
