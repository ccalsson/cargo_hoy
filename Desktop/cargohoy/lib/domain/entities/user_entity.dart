class UserEntity {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final String? avatarUrl; // URL opcional para la imagen de perfil

  UserEntity({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    this.avatarUrl,
  });

  // Crear una instancia desde un JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      avatarUrl: json['avatarUrl'],
    );
  }

  // Convertir la instancia a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'avatarUrl': avatarUrl,
    };
  }
}
