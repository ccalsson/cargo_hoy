import 'package:flutter/material.dart';
import '../../services/membership_service.dart';
import '../../models/user_model.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final MembershipService _membershipService = MembershipService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membresía'),
      ),
      body: FutureBuilder<MembershipStatus?>(
        future: _membershipService.getMembershipStatus(
            'CURRENT_USER_ID'), // TODO: Obtener del AuthProvider
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final membershipStatus = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(membershipStatus),
                const SizedBox(height: 24),
                _buildBenefitsCard(membershipStatus),
                const SizedBox(height: 24),
                _buildSubscriptionButton(membershipStatus),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(MembershipStatus? status) {
    final bool isActive =
        status != null && DateTime.now().difference(status.paidAt).inDays <= 30;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  color: isActive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isActive ? 'Membresía Activa' : 'Membresía Inactiva',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (status != null) ...[
              const SizedBox(height: 16),
              Text('Fecha de pago: ${_formatDate(status.paidAt)}'),
              Text(
                  'Beneficio utilizado: ${status.hasUsedBenefit ? 'Sí' : 'No'}'),
              Text(
                  'Elegible para mes gratis: ${status.eligibleForFreeMonth ? 'Sí' : 'No'}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsCard(MembershipStatus? status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beneficios de la Membresía',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBenefitItem(
              'Acceso a contactos directos',
              status?.hasUsedBenefit ?? false,
            ),
            _buildBenefitItem(
              'Reserva de viajes prioritarios',
              status?.hasUsedBenefit ?? false,
            ),
            _buildBenefitItem(
              'Soporte premium',
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String title, bool isUsed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isUsed ? Icons.check_circle : Icons.circle_outlined,
            color: isUsed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildSubscriptionButton(MembershipStatus? status) {
    final bool isActive =
        status != null && DateTime.now().difference(status.paidAt).inDays <= 30;

    return Center(
      child: Column(
        children: [
          if (!isActive)
            ElevatedButton(
              onPressed: _isLoading ? null : _activateMembership,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Activar Membresía'),
            ),
          if (isActive && status.eligibleForFreeMonth)
            TextButton(
              onPressed: _isLoading ? null : _extendMembership,
              child: const Text('Solicitar extensión gratuita'),
            ),
        ],
      ),
    );
  }

  Future<void> _activateMembership() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _membershipService.activateMembership(
          'CURRENT_USER_ID'); // TODO: Obtener del AuthProvider

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membresía activada exitosamente'),
          ),
        );
        setState(() {}); // Recargar la pantalla
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al activar membresía: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _extendMembership() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _membershipService.extendMembership(
          'CURRENT_USER_ID'); // TODO: Obtener del AuthProvider

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membresía extendida exitosamente'),
          ),
        );
        setState(() {}); // Recargar la pantalla
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al extender membresía: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
