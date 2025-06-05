import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_model.dart';
import 'wallet_service.dart';

class AdvanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WalletService _walletService = WalletService();
  final String _collection = 'advances';

  // Solicitar anticipo
  Future<Map<String, dynamic>> requestAdvance({
    required String userId,
    required String tripId,
    required double amount,
    required String reason,
  }) async {
    try {
      // Verificar si el usuario tiene saldo suficiente
      final hasBalance =
          await _walletService.hasSufficientBalance(userId, amount);
      if (!hasBalance) {
        throw Exception('Insufficient balance for advance');
      }

      // Crear la transacción de anticipo
      final transaction = WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: TransactionType.advance,
        amount: amount,
        description: 'Advance for trip $tripId: $reason',
        createdAt: DateTime.now(),
        relatedTripId: tripId,
        isPending: true,
      );

      // Guardar la solicitud de anticipo
      final advanceRef = await _firestore.collection(_collection).add({
        'userId': userId,
        'tripId': tripId,
        'amount': amount,
        'reason': reason,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
        'transactionId': transaction.id,
      });

      // Agregar la transacción a la billetera
      await _walletService.addTransaction(transaction);

      return {
        'success': true,
        'advanceId': advanceRef.id,
        'transactionId': transaction.id,
      };
    } catch (e) {
      print('Error requesting advance: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Aprobar anticipo
  Future<bool> approveAdvance(String advanceId) async {
    try {
      final advanceRef = _firestore.collection(_collection).doc(advanceId);

      await _firestore.runTransaction((transaction) async {
        final advanceDoc = await transaction.get(advanceRef);
        if (!advanceDoc.exists) {
          throw Exception('Advance not found');
        }

        final advanceData = advanceDoc.data()!;
        if (advanceData['status'] != 'pending') {
          throw Exception('Advance is not pending');
        }

        // Actualizar estado del anticipo
        transaction.update(advanceRef, {
          'status': 'approved',
          'approvedAt': DateTime.now().toIso8601String(),
        });

        // Procesar la transacción pendiente
        final transactionId = advanceData['transactionId'];
        if (transactionId != null) {
          await _walletService
              .processPendingTransactions(advanceData['userId']);
        }
      });

      return true;
    } catch (e) {
      print('Error approving advance: $e');
      return false;
    }
  }

  // Rechazar anticipo
  Future<bool> rejectAdvance(String advanceId, String reason) async {
    try {
      final advanceRef = _firestore.collection(_collection).doc(advanceId);

      await _firestore.runTransaction((transaction) async {
        final advanceDoc = await transaction.get(advanceRef);
        if (!advanceDoc.exists) {
          throw Exception('Advance not found');
        }

        final advanceData = advanceDoc.data()!;
        if (advanceData['status'] != 'pending') {
          throw Exception('Advance is not pending');
        }

        // Actualizar estado del anticipo
        transaction.update(advanceRef, {
          'status': 'rejected',
          'rejectedAt': DateTime.now().toIso8601String(),
          'rejectionReason': reason,
        });

        // Revertir la transacción pendiente
        final transactionId = advanceData['transactionId'];
        if (transactionId != null) {
          // Crear transacción de reembolso
          final refundTransaction = WalletTransaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: advanceData['userId'],
            type: TransactionType.refund,
            amount: advanceData['amount'],
            description: 'Refund for rejected advance: $reason',
            createdAt: DateTime.now(),
            relatedTripId: advanceData['tripId'],
          );

          await _walletService.addTransaction(refundTransaction);
        }
      });

      return true;
    } catch (e) {
      print('Error rejecting advance: $e');
      return false;
    }
  }

  // Obtener historial de anticipos
  Future<List<Map<String, dynamic>>> getAdvanceHistory(
    String userId, {
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startDate != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.where('createdAt',
            isLessThanOrEqualTo: endDate.toIso8601String());
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting advance history: $e');
      return [];
    }
  }
}
