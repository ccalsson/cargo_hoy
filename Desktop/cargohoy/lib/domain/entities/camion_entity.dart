class CamionEntity {
  final String id;
  final String modelo;
  final String placa;
  final String flotaId;

  CamionEntity({
    required this.id,
    required this.modelo,
    required this.placa,
    required this.flotaId,
  });

  factory CamionEntity.fromJson(Map<String, dynamic> json) {
    return CamionEntity(
      id: json['id'],
      modelo: json['modelo'],
      placa: json['placa'],
      flotaId: json['flotaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'placa': placa,
      'flotaId': flotaId,
    };
  }
}
