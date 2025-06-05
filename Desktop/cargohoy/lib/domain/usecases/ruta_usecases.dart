       import '../entities/ruta_entity.dart';
       import '../../data/repositories/ruta_repository.dart';
       
       class RutaUsecases {
         final RutaRepository _rutaRepository;
       
         RutaUsecases(this._rutaRepository);
       
         Future<RutaEntity> getRuta(String origen, String destino) async {
           return await _rutaRepository.getRuta(origen, destino);
         }
       }