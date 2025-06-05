import 'package:flutter/material.dart';
import '../../services/membership_service.dart';
import '../../models/user_model.dart';

class MembershipStatusScreen extends StatefulWidget {
  final String userId;

  const MembershipStatusScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<MembershipStatusScreen> createState() => _MembershipStatusScreenState();
}

class _MembershipStatusScreenState extends State<MembershipStatusScreen> {
  final MembershipService _membershipService = MembershipService();
  bool _isLoading = true;
  MembershipStatus? _membershipStatus;
  bool _isEligibleForFreeMonth = false;

  @override
  void initState() {
    super.initState();
    _loadMembershipStatus();
  }

  Future<void> _loadMembershipStatus() async {
    setState(() => _isLoading = true);
    try {
      final status =
          await _membershipService.getMembershipStatus(widget.userId);
      final isEligible =
          await _membershipService.checkFreeMonthEligibility(widget.userId);
      setState(() {
        _membershipStatus = status;
        _isEligibleForFreeMonth = isEligible;
      });
    } catch (e) {
      print('Error loading membership status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getPlanName(MembershipPlan plan) {
    switch (plan) {
      case MembershipPlan.basic:
        return 'Básico';
      case MembershipPlan.pro:
        return 'Pro';
      case MembershipPlan.premium:
        return 'Premium';
    }
  }

  Map<String, dynamic> _getPlanBenefits(MembershipPlan plan) {
    return _membershipService.getPlanBenefits(plan);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Membresía'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_membershipStatus == null)
              _buildNoMembership()
            else
              _buildActiveMembership(),
            const SizedBox(height: 24),
            _buildPlanComparison(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMembership() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'No tienes una membresía activa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isEligibleForFreeMonth)
              const Text(
                '¡Buenas noticias! Eres elegible para un mes gratis.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navegar a la pantalla de activación de membresía
              },
              child: const Text('Activar Membresía'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveMembership() {
    final plan = _membershipStatus!.plan;
    final benefits = _getPlanBenefits(plan);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plan ${_getPlanName(plan)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: const Text('Activo'),
                  backgroundColor: Colors.green,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Reservaciones restantes',
              '${_membershipStatus!.reservationsRemaining}',
            ),
            _buildInfoRow(
              'Fecha de pago',
              _membershipStatus!.paidAt.toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            const Text(
              'Beneficios del plan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildBenefitRow(
              'Reservaciones por mes',
              '${benefits['reservationsPerMonth']}',
            ),
            _buildBenefitRow(
              'Porcentaje de anticipo',
              '${(benefits['advancePercentage'] * 100).toInt()}%',
            ),
            _buildBenefitRow(
              'Descuento en comisión',
              '${(benefits['commissionDiscount'] * 100).toInt()}%',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navegar a la pantalla de extensión de membresía
              },
              child: const Text('Extender Membresía'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparación de Planes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          MembershipPlan.basic,
          'Plan Básico',
          _membershipService.getPlanPrice(MembershipPlan.basic),
        ),
        const SizedBox(height: 8),
        _buildPlanCard(
          MembershipPlan.pro,
          'Plan Pro',
          _membershipService.getPlanPrice(MembershipPlan.pro),
        ),
        const SizedBox(height: 8),
        _buildPlanCard(
          MembershipPlan.premium,
          'Plan Premium',
          _membershipService.getPlanPrice(MembershipPlan.premium),
        ),
      ],
    );
  }

  Widget _buildPlanCard(MembershipPlan plan, String name, double price) {
    final benefits = _getPlanBenefits(plan);
    final isCurrentPlan = _membershipStatus?.plan == plan;

    return Card(
      color: isCurrentPlan ? Colors.blue.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}/mes',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildBenefitRow(
              'Reservaciones por mes',
              '${benefits['reservationsPerMonth']}',
            ),
            _buildBenefitRow(
              'Porcentaje de anticipo',
              '${(benefits['advancePercentage'] * 100).toInt()}%',
            ),
            _buildBenefitRow(
              'Descuento en comisión',
              '${(benefits['commissionDiscount'] * 100).toInt()}%',
            ),
            if (!isCurrentPlan)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navegar a la pantalla de cambio de plan
                    },
                    child: const Text('Cambiar a este plan'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
