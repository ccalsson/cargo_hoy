import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const checkAndExtendMemberships = functions.pubsub
  .schedule('every 7 days')
  .onRun(async (context) => {
    const db = admin.firestore();
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    try {
      // Obtener usuarios que:
      // 1. No han usado el beneficio
      // 2. Pagaron hace más de 30 días
      // 3. Son elegibles para mes gratis
      const snapshot = await db
        .collection('users')
        .where('membershipStatus.hasUsedBenefit', '==', false)
        .where('membershipStatus.eligibleForFreeMonth', '==', true)
        .where('membershipStatus.paidAt', '<', thirtyDaysAgo)
        .get();

      const batch = db.batch();
      let batchCount = 0;
      const maxBatchSize = 500;

      for (const doc of snapshot.docs) {
        // Extender membresía por 30 días
        batch.update(doc.ref, {
          'membershipStatus.eligibleForFreeMonth': false,
          'membershipStatus.paidAt': admin.firestore.FieldValue.serverTimestamp(),
        });

        batchCount++;

        // Firebase tiene un límite de 500 operaciones por batch
        if (batchCount >= maxBatchSize) {
          await batch.commit();
          batchCount = 0;
        }
      }

      // Commit final si quedan operaciones pendientes
      if (batchCount > 0) {
        await batch.commit();
      }

      console.log(`Extended memberships for ${snapshot.size} users`);
      return null;
    } catch (error) {
      console.error('Error extending memberships:', error);
      throw error;
    }
  }); 