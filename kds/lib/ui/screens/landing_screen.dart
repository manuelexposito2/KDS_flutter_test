import 'package:flutter/material.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/ui/screens/error_screen.dart';
import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/widgets/orders_list.dart';
import 'package:kds/utils/user_shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    //Primero buscamos la UrlKDS del fichero numierKDS.ini, y cuando la tengamos, hacemos la conexión
    //con websocket y buscamos la configuración.

    //TODO: Quedaría gestionar los errores y una mejor pantalla de carga.
    UserSharedPreferences.removeResumeCall();
    ConfigRepository.getUrlKDS().then(
      (url) {
        Socket socket = io(
            url,
            OptionBuilder()
                
                .setTransports(['websocket'])
                .disableAutoConnect()
                .build());
      
        socket.onConnect((_) {
          print("Connected");

          ConfigRepository.readConfig().then((config) {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomeScreen(
                        socket: socket,
                        config: config,
                      )),
            );
          }).onError((error, stackTrace) {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => ErrorScreen()),
            );
          });
        });
        socket.connect();
        socket.onDisconnect((_) => print('disconnect'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
