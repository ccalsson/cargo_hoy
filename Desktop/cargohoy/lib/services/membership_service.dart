import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import 'wallet_service.dart';

class MembershipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WalletService _walletService = WalletService();
  final String _collection = 'memberships';

  // Precios de las membresías
  static const Map<MembershipPlan, double> _planPrices = {
    MembershipPlan.basic: 29.99,
    MembershipPlan.pro: 49.99,
    MembershipPlan.premium: 79.99,
  };

  // Beneficios por plan
  static const Map<MembershipPlan, Map<String, dynamic>> _planBenefits = {
    MembershipPlan.basic: {
      'reservationsPerMonth': 5,
      'advancePercentage': 0.0,
      'commissionDiscount': 0.0,
    },
    MembershipPlan.pro: {
      'reservationsPerMonth': 15,
      'advancePercentage': 0.3,
      'commissionDiscount': 0.1,
    },
    MembershipPlan.premium: {
      'reservationsPerMonth': 30,
      'advancePercentage': 0.5,
      'commissionDiscount': 0.2,
    },
  };

  // Activar membresía
  Future<Map<String, dynamic>> activateMembership({
    required String userId,
    required MembershipPlan plan,
    required int months,
  }) async {
    try {
      // Calcular el costo total
      final totalCost = _planPrices[plan]! * months;

      // Verificar si el usuario tiene saldo suficiente
      final hasBalance =
          await _walletService.hasSufficientBalance(userId, totalCost);
      if (!hasBalance) {
        throw Exception('Insufficient balance for membership');
      }

      // Crear la transacción de membresía
      final transaction = WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: TransactionType.membership,
        amount: totalCost,
        description: 'Membership activation: $plan for $months months',
        createdAt: DateTime.now(),
      );

      // Guardar la membresía
      final membershipRef = await _firestore.collection(_collection).add({
        'userId': userId,
        'plan': plan.toString(),
        'months': months,
        'startDate': DateTime.now().toIso8601String(),
        'endDate':
            DateTime.now().add(Duration(days: 30 * months)).toIso8601String(),
        'status': 'active',
        'reservationsUsed': 0,
        'reservationsRemaining':
            _planBenefits[plan]!['reservationsPerMonth'] * months,
        'transactionId': transaction.id,
      });

      // Agregar la transacción a la billetera
      await _walletService.addTransaction(transaction);

      return {
        'success': true,
        'membershipId': membershipRef.id,
        'transactionId': transaction.id,
      };
    } catch (e) {
      print('Error activating membership: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Extender membresía
  Future<Map<String, dynamic>> extendMembership({
    required String membershipId,
    required int additionalMonths,
  }) async {
    try {
      final membershipRef =
          _firestore.collection(_collection).doc(membershipId);

      await _firestore.runTransaction((transaction) async {
        final membershipDoc = await transaction.get(membershipRef);
        if (!membershipDoc.exists) {
          throw Exception('Membership not found');
        }

        final membershipData = membershipDoc.data()!;
        if (membershipData['status'] != 'active') {
          throw Exception('Membership is not active');
        }

        final plan = MembershipPlan.values.firstWhere(
          (e) => e.toString() == membershipData['plan'],
          orElse: () => MembershipPlan.basic,
        );

        // Calcular el costo de la extensión
        final extensionCost = _planPrices[plan]! * additionalMonths;

        // Verificar si el usuario tiene saldo suficiente
        final hasBalance = await _walletService.hasSufficientBalance(
          membershipData['userId'],
          extensionCost,
        );
        if (!hasBalance) {
          throw Exception('Insufficient balance for membership extension');
        }

        // Crear la transacción de extensión
        final extensionTransaction = WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: membershipData['userId'],
          type: TransactionType.membership,
          amount: extensionCost,
          description:
              'Membership extension: $plan for $additionalMonths months',
          createdAt: DateTime.now(),
        );

        // Actualizar la membresía
        final currentEndDate = DateTime.parse(membershipData['endDate']);
        final newEndDate =
            currentEndDate.add(Duration(days: 30 * additionalMonths));
        final additionalReservations =
            _planBenefits[plan]!['reservationsPerMonth'] * additionalMonths;

        transaction.update(membershipRef, {
          'endDate': newEndDate.toIso8601String(),
          'reservationsRemaining':
              membershipData['reservationsRemaining'] + additionalReservations,
        });

        // Agregar la transacción a la billetera
        await _walletService.addTransaction(extensionTransaction);
      });

      return {
        'success': true,
        'message': 'Membership extended successfully',
      };
    } catch (e) {
      print('Error extending membership: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Verificar elegibilidad para mes gratis
  Future<bool> checkFreeMonthEligibility(String userId) async {
    try {
      final lastMembership = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('endDate', descending: true)
          .limit(1)
          .get();

      if (lastMembership.docs.isEmpty) return false;

      final membershipData = lastMembership.docs.first.data();
      final endDate = DateTime.parse(membershipData['endDate']);
      final now = DateTime.now();

      // Verificar si han pasado al menos 30 días desde que expiró la última membresía
      return now.difference(endDate).inDays >= 30;
    } catch (e) {
      print('Error checking free month eligibility: $e');
      return false;
    }
  }

  // Obtener estado de membresía
  Future<MembershipStatus?> getMembershipStatus(String userId) async {
    try {
      final activeMembership = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .orderBy('endDate', descending: true)
          .limit(1)
          .get();

      if (activeMembership.docs.isEmpty) return null;

      final membershipData = activeMembership.docs.first.data();
      final plan = MembershipPlan.values.firstWhere(
        (e) => e.toString() == membershipData['plan'],
        orElse: () => MembershipPlan.basic,
      );

      return MembershipStatus(
        plan: plan,
        paidAt: DateTime.parse(membershipData['startDate']),
        hasUsedBenefit: membershipData['reservationsUsed'] > 0,
        eligibleForFreeMonth: false,
        reservationsRemaining: membershipData['reservationsRemaining'],
      );
    } catch (e) {
      print('Error getting membership status: $e');
      return null;
    }
  }

  // Obtener precio del plan
  double getPlanPrice(MembershipPlan plan) {
    return _planPrices[plan] ?? 0.0;
  }

  // Obtener beneficios del plan
  Map<String, dynamic> getPlanBenefits(MembershipPlan plan) {
    return _planBenefits[plan] ?? {};
  }
}
