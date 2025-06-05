import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/carga_provider.dart';
import '../../../data/models/carga_model.dart';
import 'load_search_screen.dart';
import '../../../core/theme/app_theme.dart';

class LoadsScreen extends StatelessWidget {
  const LoadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cargas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadSearchScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Disponibles'),
              Tab(text: 'En Progreso'),
              Tab(text: 'Completadas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LoadList(status: 'pendiente'),
            _LoadList(status: 'en_progreso'),
            _LoadList(status: 'completada'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navegar a crear carga
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _LoadList extends StatelessWidget {
  final String status;

  const _LoadList({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<CargaProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredLoads =
            provider.cargas.where((carga) => carga.estado == status).toList();

        return ListView.builder(
          itemCount: filteredLoads.length,
          itemBuilder: (context, index) {
            final carga = filteredLoads[index];
            return _LoadCard(carga: carga);
          },
        );
      },
    );
  }
}

class _LoadCard extends StatelessWidget {
  final CargaModel carga;

  const _LoadCard({required this.carga});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              carga.tipoCarga,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${carga.origen} → ${carga.destino}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Entrega: ${_formatDate(carga.fechaEntrega)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${carga.tarifa}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (carga.urgente)
                  Chip(
                    label: const Text('Urgente'),
                    backgroundColor: AppTheme.errorColor.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppTheme.errorColor),
                  ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Navegar al detalle de la carga
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
