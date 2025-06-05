class ServicioEntity {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final DateTime fechaCreacion;

  ServicioEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.fechaCreacion,
  });

  @override
  String toString() {
    return 'ServicioEntity{id: $id, nombre: $nombre, descripcion: $descripcion, precio: $precio, fechaCreacion: $fechaCreacion}';
  }
}
