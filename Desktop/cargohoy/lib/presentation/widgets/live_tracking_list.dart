class LiveTrackingList extends StatelessWidget {
  final List<Vehicle> vehicles;

  const LiveTrackingList({required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTrackingFilters(),
        Expanded(
          child: ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) => _buildVehicleTrackingCard(vehicles[index]),
          ),
        ),
        _buildTrackingStats(),
      ],
    );
  }

  Widget _buildVehicleTrackingCard(Vehicle vehicle) {
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.local_shipping),
        title: Text(vehicle.id),
        subtitle: Text('${vehicle.origin} → ${vehicle.destination}'),
        children: [
          _buildTrackingDetails(vehicle),
          _buildTrackingMap(vehicle),
          _buildTrackingActions(vehicle),
        ],
      ),
    );
  }

  Widget _buildTrackingStats() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('En Tiempo', '85%'),
          _buildStat('Demorados', '10%'),
          _buildStat('Detenidos', '5%'),
        ],
      ),
    );
  }
} 