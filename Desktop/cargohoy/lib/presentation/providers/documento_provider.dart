import 'package:cargohoy/data/models/documento_model.dart';
import 'package:cargohoy/data/repositories/documento_repositoriy.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/documento_usecases.dart';

class DocumentoProvider with ChangeNotifier {
  final DocumentoUsecases _documentoUsecases =
      DocumentoUsecases(DocumentoRepository());
  List<DocumentoModel> _documentos = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<DocumentoModel> get documentos => _documentos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchDocumentos(String usuarioId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _documentos = await _documentoUsecases.getDocumentos(usuarioId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadDocumento(
      String usuarioId, String nombre, String url) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _documentoUsecases.uploadDocumento(usuarioId, nombre, url);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
