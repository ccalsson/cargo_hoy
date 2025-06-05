import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/metrics_provider.dart';

class MetricsDashboardScreen extends StatefulWidget {
  const MetricsDashboardScreen({super.key});

  @override
  State<MetricsDashboardScreen> createState() => _MetricsDashboardScreenState();
}

class _MetricsDashboardScreenState extends State<MetricsDashboardScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métricas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: Consumer<MetricsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(provider),
                const SizedBox(height: 24),
                _buildDistanceChart(provider),
                const SizedBox(height: 24),
                _buildFuelChart(provider),
                const SizedBox(height: 24),
                _buildEarningsChart(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(MetricsProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildSummaryCard(
          'Distancia Total',
          '${provider.metrics.fold(0.0, (sum, m) => sum + m.distance).toStringAsFixed(1)} km',
          Icons.route,
        ),
        _buildSummaryCard(
          'Consumo Total',
          '${provider.metrics.fold(0.0, (sum, m) => sum + m.fuelConsumption).toStringAsFixed(1)} L',
          Icons.local_gas_station,
        ),
        _buildSummaryCard(
          'Ganancias',
          '\$${provider.metrics.fold(0.0, (sum, m) => sum + m.earnings).toStringAsFixed(2)}',
          Icons.attach_money,
        ),
        _buildSummaryCard(
          'Eficiencia',
          '${(provider.metrics.fold(0.0, (sum, m) => sum + m.distance) / provider.metrics.fold(0.0, (sum, m) => sum + m.fuelConsumption)).toStringAsFixed(1)} km/L',
          Icons.speed,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceChart(MetricsProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distancia Diaria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  // Configuración del gráfico
                  // ... (implementar configuración del gráfico)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Implementar _buildFuelChart y _buildEarningsChart de manera similar

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await context.read<MetricsProvider>().fetchMetrics(
        userId: 'CURRENT_USER_ID',
        startDate: _startDate,
        endDate: _endDate,
      );
    }
  }
} 