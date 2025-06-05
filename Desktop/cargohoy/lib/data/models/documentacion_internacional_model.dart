class DocumentacionInternacionalModel {
  final String id;
  final String transportistaId;
  final String vehiculoId;
  final Map<String, DocumentoInternacional> documentos;
  final List<String> paisesHabilitados;
  final DateTime fechaUltimaActualizacion;
  final String estado; // vigente, por_vencer, vencido
  final Map<String, dynamic> segurosInternacionales;
  final Map<String, dynamic> permisosMercosur;

  DocumentacionInternacionalModel({
    required this.id,
    required this.transportistaId,
    required this.vehiculoId,
    required this.documentos,
    required this.paisesHabilitados,
    required this.fechaUltimaActualizacion,
    required this.estado,
    required this.segurosInternacionales,
    required this.permisosMercosur,
  });
}

class DocumentoInternacional {
  final String tipo;
  final String numero;
  final DateTime fechaEmision;
  final DateTime fechaVencimiento;
  final String entidadEmisora;
  final String estado;
  final String urlDocumento;

  DocumentoInternacional({
    required this.tipo,
    required this.numero,
    required this.fechaEmision,
    required this.fechaVencimiento,
    required this.entidadEmisora,
    required this.estado,
    required this.urlDocumento,
  });
} 