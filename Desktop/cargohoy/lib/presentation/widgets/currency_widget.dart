import 'package:flutter/material.dart';

class CurrencyWidget extends StatelessWidget {
  final bool compact;

  const CurrencyWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Card(
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: const [
              Text('USD/BRL'),
              Text('4.95'),
              Icon(Icons.trending_up, color: Colors.green),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Tipo de Cambio'),
            trailing: Text('Actualizado: 12:30'),
          ),
          const Divider(),
          _buildCurrencyGrid(),
        ],
      ),
    );
  }

  Widget _buildCurrencyGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: [
        _buildCurrencyItem('USD/BRL', '4.95', true),
        _buildCurrencyItem('USD/ARS', '850.0', false),
        _buildCurrencyItem('USD/UYU', '39.5', true),
        // Más pares de divisas...
      ],
    );
  }

  Widget _buildCurrencyItem(String pair, String rate, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(pair, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(rate),
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
