import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          _buildProfileSection(context),
          _buildAppearanceSection(context),
          _buildNotificationsSection(context),
          _buildSecuritySection(context),
          _buildLogoutSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: settingsProvider.userPhotoUrl != null
            ? NetworkImage(settingsProvider.userPhotoUrl!)
            : null,
        child: settingsProvider.userPhotoUrl == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(settingsProvider.userName),
      subtitle: Text(settingsProvider.userEmail),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navegar a editar perfil
      },
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return SwitchListTile(
      title: const Text('Modo oscuro'),
      value: themeProvider.isDarkMode,
      onChanged: (value) => themeProvider.toggleTheme(),
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    
    return SwitchListTile(
      title: const Text('Notificaciones'),
      value: settingsProvider.notificationsEnabled,
      onChanged: (value) => settingsProvider.toggleNotifications(),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Column(
      children: [
        ListTile(
          title: const Text('Autenticación de dos factores'),
          trailing: Switch(
            value: authProvider.is2FAEnabled,
            onChanged: (value) {
              if (value) {
                authProvider.enable2FA();
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Autenticación biométrica'),
          trailing: Switch(
            value: authProvider.isBiometricEnabled,
            onChanged: (value) {
              if (value) {
                authProvider.enableBiometrics();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return ListTile(
      title: const Text('Cerrar sesión'),
      leading: const Icon(Icons.logout),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pop(context);
                  // Navegar a login
                },
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        );
      },
    );
  }
} 