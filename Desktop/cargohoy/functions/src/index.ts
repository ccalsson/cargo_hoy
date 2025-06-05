import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

// Función para limpiar reservas expiradas
export const cleanupExpiredReservations = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const batch = db.batch();

    // Obtener reservas expiradas
    const expiredReservations = await db
      .collection('reservations')
      .where('expiresAt', '<=', now)
      .where('status', 'in', ['confirmed', 'standby'])
      .get();

    for (const doc of expiredReservations.docs) {
      const reservation = doc.data();
      
      // Actualizar estado de la reserva
      batch.update(doc.ref, { status: 'expired' });

      // Actualizar el viaje
      const tripRef = db.collection('trips').doc(reservation.tripId);
      const tripDoc = await tripRef.get();
      
      if (tripDoc.exists) {
        const trip = tripDoc.data();
        const updates: any = {};

        if (trip?.reservedBy1 === reservation.userId) {
          updates.reservedBy1 = trip.reservedBy2;
          updates.reservedBy2 = null;
        } else if (trip?.reservedBy2 === reservation.userId) {
          updates.reservedBy2 = null;
        }

        if (Object.keys(updates).length > 0) {
          batch.update(tripRef, updates);
        }
      }

      // Actualizar el usuario
      const userRef = db.collection('users').doc(reservation.userId);
      batch.update(userRef, {
        activeReservations: admin.firestore.FieldValue.arrayRemove(doc.id)
      });
    }

    await batch.commit();
  });

// Función para iniciar matching automático
export const startAutoMatching = functions.pubsub
  .schedule('every 1 minutes')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const oneHourFromNow = new admin.firestore.Timestamp(
      now.seconds + 3600,
      now.nanoseconds
    );

    // Obtener viajes que empiezan en 1 hora y no tienen reservas
    const tripsToMatch = await db
      .collection('trips')
      .where('startsAt', '<=', oneHourFromNow)
      .where('status', '==', 'available')
      .where('matchingOpen', '==', false)
      .get();

    for (const doc of tripsToMatch.docs) {
      const trip = doc.data();

      // Verificar si hay reservas activas
      const activeReservations = await db
        .collection('reservations')
        .where('tripId', '==', doc.id)
        .where('status', 'in', ['confirmed', 'standby'])
        .get();

      if (activeReservations.empty) {
        // Iniciar matching
        await doc.ref.update({ matchingOpen: true });
        
        // Buscar conductores cercanos
        const drivers = await db
          .collection('users')
          .where('location', '!=', null)
          .get();

        for (const driver of drivers.docs) {
          const userData = driver.data();
          
          // Verificar penalizaciones
          if (userData.penalties?.endDate?.toDate() > new Date()) {
            continue;
          }

          // Crear notificación de matching
          await db.collection('matching_notifications').add({
            tripId: doc.id,
            userId: driver.id,
            status: 'pending',
            createdAt: now,
            expiresAt: new admin.firestore.Timestamp(
              now.seconds + 300, // 5 minutos
              now.nanoseconds
            )
          });

          // TODO: Enviar notificación push
        }
      }
    }
  });

// Función para manejar la expiración de notificaciones de matching
export const cleanupMatchingNotifications = functions.pubsub
  .schedule('every 1 minute')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();

    const expiredNotifications = await db
      .collection('matching_notifications')
      .where('expiresAt', '<=', now)
      .where('status', '==', 'pending')
      .get();

    const batch = db.batch();

    for (const doc of expiredNotifications.docs) {
      batch.update(doc.ref, { status: 'expired' });
    }

    await batch.commit();
  });

// Función para manejar la promoción automática de reservas
export const promoteReservations = functions.firestore
  .document('reservations/{reservationId}')
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const previousData = change.before.data();

    // Si la reserva fue cancelada y era prioridad 1
    if (
      newData.status === 'cancelled' &&
      previousData.status !== 'cancelled' &&
      previousData.priority === 1
    ) {
      // Buscar reserva de prioridad 2 para el mismo viaje
      const standbyReservation = await db
        .collection('reservations')
        .where('tripId', '==', newData.tripId)
        .where('priority', '==', 2)
        .where('status', '==', 'standby')
        .get();

      if (!standbyReservation.empty) {
        const doc = standbyReservation.docs[0];
        await doc.ref.update({
          priority: 1,
          status: 'confirmed',
          confirmed: true
        });

        // Actualizar el viaje
        await db.collection('trips').doc(newData.tripId).update({
          reservedBy1: doc.data().userId,
          reservedBy2: null
        });
      }
    }
  }); 