import 'package:cargohoy/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late UserRole selectedRole;
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () => _nextStep(),
        onStepCancel: () => _previousStep(),
        steps: [
          _buildRoleSelectionStep(),
          _buildBasicInfoStep(),
          _buildDocumentationStep(),
          _buildVerificationStep(),
        ],
      ),
    );
  }

  Step _buildRoleSelectionStep() {
    return Step(
      title: const Text('Tipo de Usuario'),
      content: Column(
        children: [
          _buildRoleCard(
            role: UserRole.transportista,
            title: 'Transportista',
            description: 'Para conductores individuales',
            icon: Icons.local_shipping,
          ),
          _buildRoleCard(
            role: UserRole.propietarioFlota,
            title: 'Propietario de Flota',
            description: 'Para empresas con múltiples vehículos',
            icon: Icons.directions_bus,
          ),
          _buildRoleCard(
            role: UserRole.remitente,
            title: 'Remitente',
            description: 'Para empresas que envían carga',
            icon: Icons.business,
          ),
          _buildRoleCard(
            role: UserRole.operadorLogistico,
            title: 'Operador Logístico',
            description: 'Para empresas de logística',
            icon: Icons.account_balance,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentationStep() {
    return Step(
      title: const Text('Documentación'),
      content: _buildDocumentUploadForm(),
    );
  }

  Widget _buildDocumentUploadForm() {
    // Documentos requeridos según el rol
    final requiredDocs = _getRequiredDocuments(selectedRole);

    return Column(
      children: [
        for (var doc in requiredDocs)
          DocumentUploadField(
            label: doc.label,
            type: doc.type,
            required: doc.required,
            onUpload: (file) => _handleDocumentUpload(doc.type, file),
          ),
      ],
    );
  }
}
