import 'package:flutter/material.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/utils/constants.dart';
import 'package:kds/utils/user_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ResumeOrdersWidget extends StatefulWidget {
  ResumeOrdersWidget({Key? key, required this.lineasComandas, this.socket})
      : super(key: key);

  Socket? socket;
  final List<String>? lineasComandas;
  @override
  State<ResumeOrdersWidget> createState() => _ResumeOrdersWidgetState();
}

class _ResumeOrdersWidgetState extends State<ResumeOrdersWidget> {
  String? lastSelected;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double respWidth = MediaQuery.of(context).size.width;
    double respHeight = MediaQuery.of(context).size.height;
    //Widget que crea el resumen de las comandas
    return Container(
      margin: const EdgeInsets.all(5.0),
      height: respHeight - Styles.navbarHeight,
      decoration: BoxDecoration(
          border: Styles.borderSimple,
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              
              width: respWidth,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(color: Styles.black),
              child: Text(
                "Resumen",
                textAlign: TextAlign.center,
                style: Styles.resumeTitle,
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: ListView.builder(
              padding: Styles.zeroPadding,
              scrollDirection: Axis.vertical,
              itemCount: widget.lineasComandas!.length,
              itemBuilder: (context, index) {
                return OutlinedButton(
                  style: Styles.tileStyle,
                  onPressed: () {
                    var newValue = widget.lineasComandas!
                        .elementAt(index)
                        .split(" X ")
                        .last;

                    UserSharedPreferences.getResumeCall().then((value) {
                      if (value == '' || value != newValue) {
                        UserSharedPreferences.setResumeCall(newValue);
                        lastSelected = newValue;
                        
                      } else if (value == lastSelected) {
                        lastSelected = '';
                        
                        UserSharedPreferences.removeResumeCall();
                      }
                    });

                   
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    dense: true,
                    title: Text(
                      widget.lineasComandas!.elementAt(index),
                      style: Styles.textTitle(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
