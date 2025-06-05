       class DocumentoModel {
         final String id;
         final String usuarioId;
         final String nombre;
         final String url;
         final DateTime fechaSubida;
       
         DocumentoModel({
           required this.id,
           required this.usuarioId,
           required this.nombre,
           required this.url,
           required this.fechaSubida,
         });
       
         Map<String, dynamic> toJson() {
           return {
             'id': id,
             'usuarioId': usuarioId,
             'nombre': nombre,
             'url': url,
             'fechaSubida': fechaSubida.toIso8601String(),
           };
         }
       
         factory DocumentoModel.fromJson(Map<String, dynamic> json) {
           return DocumentoModel(
             id: json['id'],
             usuarioId: json['usuarioId'],
             nombre: json['nombre'],
             url: json['url'],
             fechaSubida: DateTime.parse(json['fechaSubida']),
           );
         }
       }