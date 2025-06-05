import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/carga_provider.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CargoHoy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navegar a notificaciones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatsCard(),
            _buildActiveLoads(),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Cargas Activas', '5'),
                _buildStatItem('En Tránsito', '3'),
                _buildStatItem('Completadas', '12'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }

  Widget _buildActiveLoads() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Cargas Activas', style: TextStyle(fontSize: 20)),
        ),
        SizedBox(
          height: 200,
          child: Consumer<CargaProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.cargas.length,
                itemBuilder: (context, index) {
                  final carga = provider.cargas[index];
                  return _buildLoadCard(carga);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadCard(carga) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(carga.tipoCarga,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${carga.origen} → ${carga.destino}'),
            Text('\$${carga.tarifa}'),
            Chip(
              label: Text(carga.estado),
              backgroundColor: _getStatusColor(carga.estado),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'pendiente':
        return Colors.orange;
      case 'en_progreso':
        return Colors.blue;
      case 'completada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acciones Rápidas', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.search,
                label: 'Buscar Cargas',
                onTap: () {
                  // Navegar a búsqueda
                },
              ),
              _buildActionButton(
                icon: Icons.add_box,
                label: 'Nueva Carga',
                onTap: () {
                  // Navegar a crear carga
                },
              ),
              _buildActionButton(
                icon: Icons.account_balance_wallet,
                label: 'Pagos',
                onTap: () {
                  // Navegar a pagos
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppTheme.primaryColor),
          Text(
            label,
            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),
        ],
      ),
    );
  }
}
