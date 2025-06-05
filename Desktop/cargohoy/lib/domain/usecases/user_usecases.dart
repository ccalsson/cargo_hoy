import '../entities/user_entity.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UserUsecases {
  final UserRepository _userRepository;

  UserUsecases(this._userRepository);

  // Iniciar sesión
  Future<UserEntity> login(String email, String password) async {
    return await _userRepository.login(email, password);
  }

  // Registrar usuario
  Future<UserEntity> register(UserEntity user, String password) async {
    final userModel = UserModel(
      id: user.id,
      nombre: user.nombre,
      apellido: user.apellido,
      email: user.email,
      telefono: user.telefono,
      tipo: user.tipo,
      documentos: user.documentos,
      calificacion: user.calificacion,
      fechaRegistro: user.fechaRegistro,
      ultimoAcceso: user.ultimoAcceso,
    );
    return await _userRepository.register(userModel, password);
  }

  // Verificar usuario
  Future<void> verify(String userId, String code) async {
    return await _userRepository.verify(userId, code);
  }
}
