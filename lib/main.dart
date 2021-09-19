import 'package:flutter/material.dart';
import 'package:muslim_app/api/featch_data.dart';
import 'package:muslim_app/tools/strings.dart';
import 'package:muslim_app/ui/adkar.dart';
import 'package:muslim_app/ui/praying_times.dart';
import 'package:workmanager/workmanager.dart';
import 'ui/quran.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async{
    print("service is called ! " + task.toString());
    await FeatchData.getPrayingTimes(false);
    return Future.value(true);
  });
}

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "1",
    "Getting Praying Times",
    frequency: Duration(minutes: 15),
    initialDelay: Duration(minutes: 1),
    constraints: Constraints(
      networkType: NetworkType.connected
    )
  );

  runApp(MaterialApp(
    title: Strings.app_title,
    home: Main(),
    locale: Locale("ar", "DZ"),
  ));

}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  Widget _body;
  int currentIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _body = Home();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        title: Text(Strings.app_title),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => print("cicked !"),
          ),
        ],
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
       // backgroundColor: Tools.backColor,
      //  selectedItemColor: Colors.white70,
        //unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("images/mushaf.png", height: 29, width: 29),
              label: Strings.quran,
          ),
          BottomNavigationBarItem(
              icon: Image.asset("images/icon_adkari.png", height: 29, width: 29),
              label: Strings.adkar,
          ),
          BottomNavigationBarItem(
              icon: Image.asset("images/prayer_time.jpg", height: 29, width: 29),
              label: Strings.praying_time,
          ),
        ],
        onTap: (value) => _showScreen(value),
        currentIndex: currentIndex,

      ),
      body: _body,
    );
  }

  void _showScreen(value){
    setState(() {
      switch (value) {
        case 0:
          _body = Home();
          break;
        case 1:
          _body = Adkar();
          break;
        case 2:
          _body = Praying();
          break;
      }
      currentIndex = value;
    });
  }

}
