import 'package:flutter/material.dart';
import '../../services/terms_service.dart';
import '../../models/user_model.dart';

class TermsScreen extends StatefulWidget {
  final String userId;
  final UserRole userRole;
  final VoidCallback onAccept;

  const TermsScreen({
    Key? key,
    required this.userId,
    required this.userRole,
    required this.onAccept,
  }) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final TermsService _termsService = TermsService();
  bool _isLoading = true;
  List<String> _pendingDocuments = [];
  Map<String, bool> _acceptedDocuments = {};

  @override
  void initState() {
    super.initState();
    _loadPendingDocuments();
  }

  Future<void> _loadPendingDocuments() async {
    setState(() => _isLoading = true);
    try {
      final documents = await _termsService.getPendingDocuments(
        widget.userId,
        widget.userRole,
      );
      setState(() {
        _pendingDocuments = documents;
        _acceptedDocuments = {
          for (var doc in documents) doc: false,
        };
      });
    } catch (e) {
      print('Error loading pending documents: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _acceptDocument(String type) async {
    setState(() => _isLoading = true);
    try {
      bool success = false;
      switch (type) {
        case 'terms':
          success = await _termsService.acceptTerms(widget.userId);
          break;
        case 'contract':
          success = await _termsService.acceptContract(widget.userId);
          break;
        case 'company_policies':
          success = await _termsService.acceptCompanyPolicies(widget.userId);
          break;
      }

      if (success) {
        setState(() {
          _acceptedDocuments[type] = true;
        });

        // Verificar si todos los documentos han sido aceptados
        if (_acceptedDocuments.values.every((accepted) => accepted)) {
          widget.onAccept();
        }
      }
    } catch (e) {
      print('Error accepting document: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingDocuments.length,
        itemBuilder: (context, index) {
          final documentType = _pendingDocuments[index];
          final documentName = _termsService.getDocumentTypeName(documentType);
          final isAccepted = _acceptedDocuments[documentType] ?? false;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documentName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _termsService.getLegalDocument(documentType),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text(
                          'Error al cargar el documento. Por favor, intente nuevamente.',
                          style: TextStyle(color: Colors.red),
                        );
                      }

                      final document = snapshot.data!;
                      return Text(
                        document['content'] ?? 'Contenido no disponible',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (!isAccepted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _acceptDocument(documentType),
                        child: const Text('Aceptar'),
                      ),
                    )
                  else
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Documento aceptado',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
