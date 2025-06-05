enum TransactionType {
  commission,
  advance,
  penalty,
  refund,
  membership,
  withdrawal,
  deposit
}

class WalletTransaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime createdAt;
  final String? relatedTripId;
  final String? relatedUserId;
  final bool isPending;
  final DateTime? processedAt;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.relatedTripId,
    this.relatedUserId,
    this.isPending = false,
    this.processedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'relatedTripId': relatedTripId,
      'relatedUserId': relatedUserId,
      'isPending': isPending,
      'processedAt': processedAt?.toIso8601String(),
    };
  }

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'],
      userId: map['userId'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => TransactionType.commission,
      ),
      amount: map['amount'].toDouble(),
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      relatedTripId: map['relatedTripId'],
      relatedUserId: map['relatedUserId'],
      isPending: map['isPending'] ?? false,
      processedAt: map['processedAt'] != null
          ? DateTime.parse(map['processedAt'])
          : null,
    );
  }
}

class Wallet {
  final String userId;
  final double balance;
  final double pendingBalance;
  final DateTime lastUpdated;
  final List<WalletTransaction> recentTransactions;

  Wallet({
    required this.userId,
    required this.balance,
    required this.pendingBalance,
    required this.lastUpdated,
    this.recentTransactions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'balance': balance,
      'pendingBalance': pendingBalance,
      'lastUpdated': lastUpdated.toIso8601String(),
      'recentTransactions': recentTransactions.map((t) => t.toMap()).toList(),
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      userId: map['userId'],
      balance: map['balance'].toDouble(),
      pendingBalance: map['pendingBalance'].toDouble(),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      recentTransactions: (map['recentTransactions'] as List)
          .map((t) => WalletTransaction.fromMap(t))
          .toList(),
    );
  }

  // Verificar si hay saldo suficiente para una transacción
  bool hasSufficientBalance(double amount) {
    return balance >= amount;
  }

  // Verificar si hay saldo pendiente suficiente
  bool hasSufficientPendingBalance(double amount) {
    return pendingBalance >= amount;
  }

  // Calcular saldo total (disponible + pendiente)
  double get totalBalance => balance + pendingBalance;
}
