import 'package:kds/models/status/print_order_dto.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/print_order_repository.dart';
import 'package:http/http.dart' as http;

class PrintOrderRepositoryImpl extends PrintOrderRepository{


  @override
  Future<PrintOrderDto> printOrder(PrintOrderDto printOrderDto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    
    String url = '$urlKDS/printOrderKDS';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    
    final response = 
    await http.post(Uri.parse(url), 
    headers: headers, 
    body: printOrderDto.toJson());
    
    if(response.statusCode == 200){
     
      return printOrderDto;
    }else{
      throw Exception('Fail to load');
    }
  }

  @override
  Future<PrintOrderDto> printAccount(PrintOrderDto printOrderDto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    
    String url = '$urlKDS/printAccountKDS';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    
    final response = 
    await http.post(Uri.parse(url), 
    headers: headers, 
    body: printOrderDto.toJson());
    
    if(response.statusCode == 200){
     
      return printOrderDto;
    }else{
      throw Exception('Fail to load');
    }
  }
  
}