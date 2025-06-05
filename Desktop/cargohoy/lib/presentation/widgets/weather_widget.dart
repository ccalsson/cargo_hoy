import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final bool compact;

  const WeatherWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Card(
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: const [
              Icon(Icons.wb_sunny, size: 32),
              Text('28°C'),
              Text('Buenos Aires'),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text('Clima en Ruta'),
            subtitle: Text('Buenos Aires → São Paulo'),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherPoint('Buenos Aires', '28°C', 'Soleado'),
              _buildWeatherPoint('Uruguaiana', '25°C', 'Nublado'),
              _buildWeatherPoint('São Paulo', '22°C', 'Lluvia'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherPoint(String city, String temp, String condition) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(temp),
          Text(condition),
        ],
      ),
    );
  }
}
