import 'package:flutter/material.dart';
import 'package:cargohoy/data/models/perfil_model.dart';
import 'package:provider/provider.dart';
import 'package:cargohoy/presentation/providers/perfil_provider.dart';

class EditProfileScreen extends StatelessWidget {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilProvider = Provider.of<PerfilProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    // Cargar los datos del perfil al iniciar la pantalla
    if (perfilProvider.perfil == null) {
      perfilProvider.fetchPerfil(usuarioId);
    }

    // Si el perfil ya está cargado, llenar los controladores con los datos actuales
    if (perfilProvider.perfil != null) {
      _nombreController.text = perfilProvider.perfil!.nombre;
      _apellidoController.text = perfilProvider.perfil!.apellido;
      _emailController.text = perfilProvider.perfil!.email;
      _telefonoController.text = perfilProvider.perfil!.telefono;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final perfilActualizado = PerfilModel(
                id: perfilProvider.perfil!.id,
                nombre: _nombreController.text,
                apellido: _apellidoController.text,
                email: _emailController.text,
                telefono: _telefonoController.text,
                tipo: perfilProvider.perfil!.tipo,
                documentos: perfilProvider.perfil!.documentos,
                calificacion: perfilProvider.perfil!.calificacion,
                fechaRegistro: perfilProvider.perfil!.fechaRegistro,
                ultimoAcceso: DateTime.now(),
              );

              await perfilProvider.updatePerfil(perfilActualizado);

              if (perfilProvider.errorMessage.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil actualizado exitosamente')),
                );
                Navigator.pop(context); // Regresar a la pantalla anterior
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(perfilProvider.errorMessage)),
                );
              }
            },
          ),
        ],
      ),
      body: perfilProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: _apellidoController,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
    );
  }
}
