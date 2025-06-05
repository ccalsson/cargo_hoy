import 'package:cargohoy/data/models/documento_model.dart';
import 'package:cargohoy/data/repositories/documento_repositoriy.dart';

class DocumentoUsecases {
  final DocumentoRepository _documentoRepository;

  DocumentoUsecases(this._documentoRepository);

  Future<List<DocumentoModel>> getDocumentos(String usuarioId) async {
    return await _documentoRepository.getDocumentos(usuarioId);
  }

  Future<void> uploadDocumento(
      String usuarioId, String nombre, String url) async {
    return await _documentoRepository.uploadDocumento(usuarioId, nombre, url);
  }
}

class DocumentoEntity {}
