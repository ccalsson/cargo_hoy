import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class TermsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'legal_documents';

  // Tipos de documentos legales
  static const Map<String, String> _documentTypes = {
    'terms': 'Términos y Condiciones',
    'privacy': 'Política de Privacidad',
    'contract': 'Contrato de Servicio',
    'company_policies': 'Políticas de Empresa',
  };

  // Obtener documento legal
  Future<Map<String, dynamic>?> getLegalDocument(String type) async {
    try {
      final doc = await _firestore.collection(_collection).doc(type).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      print('Error getting legal document: $e');
      return null;
    }
  }

  // Aceptar términos y condiciones
  Future<bool> acceptTerms(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'termsAccepted': true,
        'termsAcceptedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error accepting terms: $e');
      return false;
    }
  }

  // Aceptar contrato
  Future<bool> acceptContract(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'contractAccepted': true,
        'contractAcceptedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error accepting contract: $e');
      return false;
    }
  }

  // Aceptar políticas de empresa
  Future<bool> acceptCompanyPolicies(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'companyPoliciesAccepted': true,
        'companyPoliciesAcceptedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error accepting company policies: $e');
      return false;
    }
  }

  // Verificar si el usuario ha aceptado todos los documentos requeridos
  Future<bool> hasAcceptedAllRequiredDocuments(
      String userId, UserRole role) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data()!;
      final termsAccepted = userData['termsAccepted'] ?? false;
      final contractAccepted = userData['contractAccepted'] ?? false;
      final companyPoliciesAccepted =
          userData['companyPoliciesAccepted'] ?? false;

      // Todos los usuarios deben aceptar términos y condiciones
      if (!termsAccepted) return false;

      // Conductores deben aceptar el contrato
      if ((role == UserRole.conductor_propietario ||
              role == UserRole.conductor_empleado) &&
          !contractAccepted) {
        return false;
      }

      // Empresas y flotas deben aceptar políticas de empresa
      if ((role == UserRole.empresa_admin || role == UserRole.dueno_flota) &&
          !companyPoliciesAccepted) {
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking document acceptance: $e');
      return false;
    }
  }

  // Obtener documentos pendientes por aceptar
  Future<List<String>> getPendingDocuments(String userId, UserRole role) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return _documentTypes.keys.toList();

      final userData = userDoc.data()!;
      final List<String> pendingDocs = [];

      // Verificar términos y condiciones
      if (!(userData['termsAccepted'] ?? false)) {
        pendingDocs.add('terms');
      }

      // Verificar contrato para conductores
      if ((role == UserRole.conductor_propietario ||
              role == UserRole.conductor_empleado) &&
          !(userData['contractAccepted'] ?? false)) {
        pendingDocs.add('contract');
      }

      // Verificar políticas de empresa para empresas y flotas
      if ((role == UserRole.empresa_admin || role == UserRole.dueno_flota) &&
          !(userData['companyPoliciesAccepted'] ?? false)) {
        pendingDocs.add('company_policies');
      }

      return pendingDocs;
    } catch (e) {
      print('Error getting pending documents: $e');
      return _documentTypes.keys.toList();
    }
  }

  // Obtener nombre legible del tipo de documento
  String getDocumentTypeName(String type) {
    return _documentTypes[type] ?? type;
  }
}
