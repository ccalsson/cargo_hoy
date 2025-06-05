import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reporte_provider.dart';

class ReporteDesempenoScreen extends StatelessWidget {
  const ReporteDesempenoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reporteProvider = Provider.of<ReporteProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de Desempeño')),
      body: reporteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reporteProvider.reporteDesempeno == null
              ? const Center(child: Text('No hay datos disponibles'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Eficiencia de Rutas: ${reporteProvider.reporteDesempeno!.datos['eficiencia']}%',
                          style: const TextStyle(fontSize: 18)),
                      Text(
                          'Costos Totales: \$${reporteProvider.reporteDesempeno!.datos['costos']}',
                          style: const TextStyle(fontSize: 18)),
                      Text(
                          'Tiempo Promedio de Entrega: ${reporteProvider.reporteDesempeno!.datos['tiempoPromedio']} horas',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await reporteProvider.fetchReporteDesempeno(usuarioId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
