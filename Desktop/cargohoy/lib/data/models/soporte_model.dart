       class SoporteModel {
         final String id;
         final String usuarioId;
         final String mensaje;
         final DateTime fecha;
       
         SoporteModel({
           required this.id,
           required this.usuarioId,
           required this.mensaje,
           required this.fecha,
         });
       
         Map<String, dynamic> toJson() {
           return {
             'id': id,
             'usuarioId': usuarioId,
             'mensaje': mensaje,
             'fecha': fecha.toIso8601String(),
           };
         }
       
         factory SoporteModel.fromJson(Map<String, dynamic> json) {
           return SoporteModel(
             id: json['id'],
             usuarioId: json['usuarioId'],
             mensaje: json['mensaje'],
             fecha: DateTime.parse(json['fecha']),
           );
         }
       }
       