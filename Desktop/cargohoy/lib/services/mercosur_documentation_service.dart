class MercosurDocumentationService {
  Future<Map<String, bool>> verificarDocumentosMercosur({
    required String transportistaId,
    required String vehiculoId,
  }) async {
    return {
      'permiso_mercosur': await _verificarPermisoMercosur(transportistaId),
      'seguro_internacional': await _verificarSeguroInternacional(vehiculoId),
      'licencia_mercosur': await _verificarLicenciaMercosur(transportistaId),
      'certificado_origen': await _verificarCertificadoOrigen(),
      'manifesto_internacional': await _verificarManifiestoInternacional(),
      'mic_dta': await _verificarMICDTA(), // Manifiesto Internacional de Carga
    };
  }

  Future<Map<String, dynamic>> getRequisitosPais(String pais) async {
    // Requisitos específicos por país del Mercosur
    final requisitos = {
      'BRASIL': {
        'documentos_requeridos': [
          'CRLV',
          'RNTRC',
          'OCC',
        ],
        'permisos_especiales': [
          'ANTT',
        ],
      },
      'ARGENTINA': {
        'documentos_requeridos': [
          'CENT',
          'LNH',
        ],
        'permisos_especiales': [
          'RUT',
          'RUTA',
        ],
      },
      'URUGUAY': {
        'documentos_requeridos': [
          'DGT',
          'Permiso Nacional',
        ],
      },
      'PARAGUAY': {
        'documentos_requeridos': [
          'DINATRAN',
          'Habilitación Técnica',
        ],
      },
    };

    return requisitos[pais] ?? {};
  }
} 