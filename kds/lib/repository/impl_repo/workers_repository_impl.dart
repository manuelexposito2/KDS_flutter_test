import 'dart:convert';
import './../../utils/string_extension.dart';
import 'package:kds/models/set_dealers_response.dart';
import 'package:kds/models/get_workers_response.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/repository/repository/workers_repository.dart';
import 'package:http/http.dart' as http;

class WorkersRepositoryImpl implements WorkersRepository {
  @override
  Future<List<GetWorkers>> getWorkers(Config config) async {
    String url = '${config.urlPDA}/KDS/getWorkers.htm';

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return GetWorkersResponse.fromJson(
              jsonDecode(_jsonpToJson(request, "getWorkers")))
          .getWorkers;
    } else {
      throw Exception(request.statusCode);
    }
  }

  @override
  Future<SetDealersResponse> setDealer(
      Config config, String idOrder, String idWorker) async {
    String url =
        '${config.urlPDA}/KDS/setDealer.htm?idOrder=$idOrder&idWorker=$idWorker';

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return SetDealersResponse.fromJson(
          jsonDecode(_jsonpToJson(request, "setDealer")));
    } else {
      throw Exception(request.statusCode);
    }
  }

  _jsonpToJson(http.Response request, String callback) {
    //var callback = "getWorkers";
    var dataBody = request.body.strip("(").strip(")");
    var json = "{${dataBody.replaceAll(callback, '"$callback":')}}";

    if (json.contains('ï»¿')) {
      return json.replaceAll('ï»¿', "");
    }

    return json;
  }
}
