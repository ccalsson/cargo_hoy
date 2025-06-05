import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/documento_provider.dart';

class DocumentoUploadScreen extends StatelessWidget {
  final _nombreController = TextEditingController();
  final _urlController = TextEditingController();

  DocumentoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documentoProvider = Provider.of<DocumentoProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(title: const Text('Subir Documento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del Documento'),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL del Documento'),
            ),
            const SizedBox(height: 20),
            if (documentoProvider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  final nombre = _nombreController.text;
                  final url = _urlController.text;
                  await documentoProvider.uploadDocumento(
                      usuarioId, nombre, url);
                  if (documentoProvider.errorMessage.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(documentoProvider.errorMessage)),
                    );
                  }
                },
                child: const Text('Subir Documento'),
              ),
          ],
        ),
      ),
    );
  }
}
