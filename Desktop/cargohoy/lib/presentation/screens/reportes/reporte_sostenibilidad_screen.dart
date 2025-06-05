import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reporte_provider.dart';

class ReporteSostenibilidadScreen extends StatelessWidget {
  const ReporteSostenibilidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reporteProvider = Provider.of<ReporteProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de Sostenibilidad')),
      body: reporteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reporteProvider.reporteSostenibilidad == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Huella de Carbono: ${reporteProvider.reporteSostenibilidad!.datos['huellaCarbono']} kg CO2',
                          style: const TextStyle(fontSize: 18)),
                      Text(
                          'Combustible Consumido: ${reporteProvider.reporteSostenibilidad!.datos['combustible']} litros',
                          style: const TextStyle(fontSize: 18)),
                      Text(
                          'Rutas Ecológicas: ${reporteProvider.reporteSostenibilidad!.datos['rutasEcologicas']}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await reporteProvider.fetchReporteSostenibilidad(usuarioId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
