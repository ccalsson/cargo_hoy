import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/documento_provider.dart';

class DocumentoListScreen extends StatelessWidget {
  const DocumentoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documentoProvider = Provider.of<DocumentoProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Documentos')),
      body: documentoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: documentoProvider.documentos.length,
              itemBuilder: (context, index) {
                final documento = documentoProvider.documentos[index];
                return ListTile(
                  title: Text(documento.nombre),
                  subtitle: Text(documento.fechaSubida.toString()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await documentoProvider.fetchDocumentos(usuarioId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
