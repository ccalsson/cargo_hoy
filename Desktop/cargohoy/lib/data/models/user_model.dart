class UserModel {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String tipo; // conductor, empresa, dueño_flota
  final List<String> documentos; // URLs de documentos
  final double calificacion; // 0.0 - 5.0
  final DateTime fechaRegistro;
  final DateTime ultimoAcceso;

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.tipo,
    this.documentos = const [],
    this.calificacion = 0.0,
    required this.fechaRegistro,
    required this.ultimoAcceso,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'tipo': tipo,
      'documentos': documentos,
      'calificacion': calificacion,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'ultimoAcceso': ultimoAcceso.toIso8601String(),
    };
  }

  // Crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono: json['telefono'],
      tipo: json['tipo'],
      documentos: List<String>.from(json['documentos']),
      calificacion: json['calificacion'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
      ultimoAcceso: DateTime.parse(json['ultimoAcceso']),
    );
  }
}