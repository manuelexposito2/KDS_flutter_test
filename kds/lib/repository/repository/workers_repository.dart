
import 'package:kds/models/get_workers_response.dart';
import 'package:kds/models/set_dealers_response.dart';
import 'package:kds/models/status/config.dart';

abstract class WorkersRepository{

  //getWorkers
  Future<List<GetWorkers>> getWorkers(Config config);
  
  //setDealer
  Future<SetDealersResponse> setDealer(Config config, String idOrder, String idWorker);
//setDealer({'status':'OK'})

Future<void> inicioTurno(Config config, String codigo, String isInicioTurno);


}