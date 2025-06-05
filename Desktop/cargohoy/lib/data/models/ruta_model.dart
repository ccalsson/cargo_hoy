       class RutaModel {
         final String id;
         final String origen;
         final String destino;
         final List<Map<String, double>> puntos; // Lista de puntos (lat, lng)
       
         RutaModel({
           required this.id,
           required this.origen,
           required this.destino,
           required this.puntos,
         });
       
         Map<String, dynamic> toJson() {
           return {
             'id': id,
             'origen': origen,
             'destino': destino,
             'puntos': puntos,
           };
         }
       
         factory RutaModel.fromJson(Map<String, dynamic> json) {
           return RutaModel(
             id: json['id'],
             origen: json['origen'],
             destino: json['destino'],
             puntos: List<Map<String, double>>.from(json['puntos']),
           );
         }
       }