import 'package:cargohoy/domain/entities/configuracion%20entity.dart';

class ConfiguracionModel {
  final String id;
  final String usuarioId;
  final bool notificacionesActivas;
  final String tema; // claro, oscuro

  ConfiguracionModel({
    required this.id,
    required this.usuarioId,
    required this.notificacionesActivas,
    required this.tema,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'notificacionesActivas': notificacionesActivas,
      'tema': tema,
    };
  }

  factory ConfiguracionModel.fromJson(Map<String, dynamic> json) {
    return ConfiguracionModel(
      id: json['id'],
      usuarioId: json['usuarioId'],
      notificacionesActivas: json['notificacionesActivas'],
      tema: json['tema'],
    );
  }

  Future<ConfiguracionEntity> get toEntity async {
    return ConfiguracionEntity(
      id: id,
      usuarioId: usuarioId,
      notificacionesActivas: notificacionesActivas,
      tema: tema,
    );
  }
}
