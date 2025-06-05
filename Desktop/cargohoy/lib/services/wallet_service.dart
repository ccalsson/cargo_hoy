import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_model.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'wallets';
  final String _transactionsCollection = 'wallet_transactions';

  // Obtener billetera de un usuario
  Future<Wallet?> getUserWallet(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (!doc.exists) return null;
      return Wallet.fromMap(doc.data()!);
    } catch (e) {
      print('Error getting user wallet: $e');
      return null;
    }
  }

  // Crear nueva billetera
  Future<Wallet> createWallet(String userId) async {
    try {
      final wallet = Wallet(
        userId: userId,
        balance: 0.0,
        pendingBalance: 0.0,
        lastUpdated: DateTime.now(),
      );

      await _firestore.collection(_collection).doc(userId).set(wallet.toMap());
      return wallet;
    } catch (e) {
      print('Error creating wallet: $e');
      rethrow;
    }
  }

  // Agregar transacción
  Future<WalletTransaction> addTransaction(
      WalletTransaction walletTransaction) async {
    try {
      // Crear la transacción
      final docRef = await _firestore
          .collection(_transactionsCollection)
          .add(walletTransaction.toMap());

      // Actualizar la billetera
      final walletRef =
          _firestore.collection(_collection).doc(walletTransaction.userId);

      await _firestore.runTransaction((firestoreTransaction) async {
        final walletDoc = await firestoreTransaction.get(walletRef);
        if (!walletDoc.exists) {
          throw Exception('Wallet not found');
        }

        final wallet = Wallet.fromMap(walletDoc.data()!);
        double newBalance = wallet.balance;
        double newPendingBalance = wallet.pendingBalance;

        // Actualizar saldos según el tipo de transacción
        switch (walletTransaction.type) {
          case TransactionType.commission:
            newBalance -= walletTransaction.amount;
            break;
          case TransactionType.advance:
            newBalance += walletTransaction.amount;
            newPendingBalance -= walletTransaction.amount;
            break;
          case TransactionType.penalty:
            newBalance -= walletTransaction.amount;
            break;
          case TransactionType.refund:
            newBalance += walletTransaction.amount;
            break;
          case TransactionType.membership:
            newBalance -= walletTransaction.amount;
            break;
          case TransactionType.withdrawal:
            newBalance -= walletTransaction.amount;
            break;
          case TransactionType.deposit:
            newBalance += walletTransaction.amount;
            break;
        }

        // Actualizar la billetera
        firestoreTransaction.update(walletRef, {
          'balance': newBalance,
          'pendingBalance': newPendingBalance,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      });

      return walletTransaction;
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  // Obtener historial de transacciones
  Future<List<WalletTransaction>> getTransactionHistory(
    String userId, {
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection(_transactionsCollection)
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
          .map((doc) =>
              WalletTransaction.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting transaction history: $e');
      return [];
    }
  }

  // Procesar transacciones pendientes
  Future<void> processPendingTransactions(String userId) async {
    try {
      final pendingTransactions = await _firestore
          .collection(_transactionsCollection)
          .where('userId', isEqualTo: userId)
          .where('isPending', isEqualTo: true)
          .get();

      for (var doc in pendingTransactions.docs) {
        final transaction = WalletTransaction.fromMap(doc.data());
        await addTransaction(transaction);
      }
    } catch (e) {
      print('Error processing pending transactions: $e');
      rethrow;
    }
  }

  // Verificar saldo suficiente
  Future<bool> hasSufficientBalance(String userId, double amount) async {
    try {
      final wallet = await getUserWallet(userId);
      if (wallet == null) return false;
      return wallet.hasSufficientBalance(amount);
    } catch (e) {
      print('Error checking balance: $e');
      return false;
    }
  }
}
