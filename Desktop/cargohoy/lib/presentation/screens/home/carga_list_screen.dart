import 'package:cargohoy/presentation/providers/carga_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'carga_detail_screen.dart';

class CargaListScreen extends StatelessWidget {
  const CargaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cargaProvider = Provider.of<CargaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Cargas')),
      body: cargaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cargaProvider.cargas.length,
              itemBuilder: (context, index) {
                final carga = cargaProvider.cargas[index];
                return ListTile(
                  title: Text(carga.tipoCarga),
                  subtitle: Text('${carga.origen} → ${carga.destino}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String? value) {
                      // Handle the selected value
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Tipo 1', 'Tipo 2', 'Tipo 3']
                          .map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CargaDetailScreen(carga: carga),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_carga');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
