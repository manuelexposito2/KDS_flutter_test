import 'package:kds/models/status/cambiar_peso_dto.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/cambiar_peso_repository.dart';
import 'package:http/http.dart' as http;

class CambiarPesoRepositoryImpl extends CambiarPesoRepository{

  @override
  Future<CambiarPesoDto> urgente(CambiarPesoDto cambiarPesoDto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    String url = '$urlKDS/cambiarPeso';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    
    final response = 
    await http.post(Uri.parse(url), 
    headers: headers, 
    body: cambiarPesoDto.toJson());
    
    if(response.statusCode == 200){
     
      return cambiarPesoDto;
    }else{
      throw Exception('Fail to load');
    }
  }
  
}