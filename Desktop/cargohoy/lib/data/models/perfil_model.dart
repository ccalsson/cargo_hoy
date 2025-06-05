import '../../domain/entities/perfil_entity.dart';

class PerfilModel {
  final String id;
  final String name;
  final String email;
  final String phone;

  PerfilModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // Convertir PerfilModel a PerfilEntity
  PerfilEntity toEntity() {
    return PerfilEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
    );
  }

  // Crear PerfilModel desde PerfilEntity
  factory PerfilModel.fromEntity(PerfilEntity entity) {
    return PerfilModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
    );
  }

  // Crear PerfilModel desde JSON
  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  // Convertir PerfilModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
