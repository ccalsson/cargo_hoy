import '../entities/perfil_entity.dart';
import '../../data/repositories/perfil_repository.dart';
import '../../data/models/perfil_model.dart';

class PerfilUsecases {
  final PerfilRepository _perfilRepository;

  PerfilUsecases(this._perfilRepository);

  // Obtener perfil
  Future<PerfilEntity> getPerfil(String usuarioId) async {
    final perfilModel = await _perfilRepository.getPerfil(usuarioId);
    return perfilModel.toEntity(); // Convertir PerfilModel a PerfilEntity
  }

  // Actualizar perfil
  Future<void> updatePerfil(PerfilEntity perfil) async {
    final perfilModel =
        PerfilModel.fromEntity(perfil); // Convertir PerfilEntity a PerfilModel
    return await _perfilRepository.updatePerfil(perfilModel);
  }
}
