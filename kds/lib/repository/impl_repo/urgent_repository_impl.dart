
import 'package:kds/models/status/urgente_dto.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/urgent_repository.dart';
import 'package:kds/utils/constants.dart';
import 'package:http/http.dart' as http;

class UrgentRepositoryImpl implements UrgenteRepository{
  
  @override
  Future<UrgenteDto> urgente(UrgenteDto urgenteDto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    String url = '$urlKDS/setUrgent';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    
    final response = 
    await http.post(Uri.parse(url), 
    headers: headers, 
    body: urgenteDto.toJson());
    
    if(response.statusCode == 200){
     
      return urgenteDto;
    }else{
      throw Exception('Fail to load');
    }
  }

  

}