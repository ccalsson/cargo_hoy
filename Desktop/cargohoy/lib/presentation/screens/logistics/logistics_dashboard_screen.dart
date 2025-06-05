class LogisticsDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel de Control Logístico')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFleetOverview(),
            _buildActiveShipments(),
            _buildPerformanceMetrics(),
            _buildDockSchedule(),
            _buildAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildFleetOverview() {
    return Card(
      child: Column(
        children: [
          Text('Estado de la Flota'),
          Row(
            children: [
              _buildStatCard('Vehículos Activos', '42/50'),
              _buildStatCard('En Mantenimiento', '5'),
              _buildStatCard('Disponibles', '3'),
            ],
          ),
          _buildFleetMap(),
        ],
      ),
    );
  }

  Widget _buildActiveShipments() {
    return Card(
      child: Column(
        children: [
          Text('Envíos Activos'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) => _buildShipmentCard(),
          ),
        ],
      ),
    );
  }
} 