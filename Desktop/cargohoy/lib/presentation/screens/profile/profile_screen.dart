import 'package:cargohoy/data/models/perfil_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/perfil_provider.dart';
import 'edit_profile_screen.dart'; // Importar la pantalla de edición de perfil
import '../../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilProvider = Provider.of<PerfilProvider>(context);
    const usuarioId = 'usuarioId'; // Reemplazar con ID real del usuario

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegar a configuración
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatsSection(),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryLightColor,
            backgroundImage: const NetworkImage('URL_DE_LA_IMAGEN'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nombre del Usuario',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Conductor Verificado',
            style: TextStyle(color: Colors.green),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber),
              Text('4.8 (120 reseñas)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Cargas\nCompletadas', '156'),
          _buildStatItem('Kilómetros\nRecorridos', '23,450'),
          _buildStatItem('Ganancias\nTotales', '\$45,678'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.history,
          title: 'Historial de Viajes',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.account_balance_wallet,
          title: 'Pagos y Facturación',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.description,
          title: 'Documentos',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.star_border,
          title: 'Reseñas',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Ayuda y Soporte',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.exit_to_app,
          title: 'Cerrar Sesión',
          onTap: () {
            // Implementar logout
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: AppTheme.textPrimaryColor),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }
}
