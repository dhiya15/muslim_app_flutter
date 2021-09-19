import 'package:flutter/material.dart';
import 'package:muslim_app/api/featch_data.dart';
import 'package:muslim_app/api/models.dart';
import 'package:muslim_app/tools/strings.dart';
import 'package:muslim_app/tools/tools.dart';

class Praying extends StatefulWidget {
  @override
  _PrayingState createState() => _PrayingState();
}

class _PrayingState extends State<Praying> {

  PrayingTimes _prayingTimes = PrayingTimes();
  TextEditingController  _timeSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillObject(false);
  }

  void fillObject(bool city) async {
    PrayingTimes pt;
    if(city)
      pt = await FeatchData.getPrayingTimes(city, place: _timeSearch.text);
    else
      // pt = await FeatchData.getPrayingTimes(city);
      pt = await FeatchData.getLocalPrayingTimes();
    if(pt != null){
      setState((){
        _prayingTimes = pt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        Tools.getScrollWidget(Container(
          margin: EdgeInsets.fromLTRB(30, 120, 30, 40),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Image.asset("images/prayer_time.jpg", height: 100, width: 100,),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text(Strings.praying_time, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text("${_prayingTimes.hijri} / ${_prayingTimes.gregorian}"),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text("${Strings.fajr} : ${_prayingTimes.fajr}", textDirection: TextDirection.rtl),
              Text("${Strings.dhuhr} : ${_prayingTimes.dhuhr}", textDirection: TextDirection.rtl),
              Text("${Strings.asr} : ${_prayingTimes.asr}", textDirection: TextDirection.rtl),
              Text("${Strings.maghrib} : ${_prayingTimes.maghrib}", textDirection: TextDirection.rtl),
              Text("${Strings.isha} : ${_prayingTimes.isha}", textDirection: TextDirection.rtl),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text("${Strings.sunrise} : ${_prayingTimes.sunrise} "
                  "\t "
                  "${Strings.sunset} : ${_prayingTimes.sunset}",
                  textDirection: TextDirection.rtl),
              Padding(padding: EdgeInsets.only(top: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _timeSearch,
                      keyboardType: TextInputType.text,
                      onSubmitted: (String value) {
                        fillObject(true);
                      },
                      onChanged: (String value) {
                        if(value.trim().isEmpty){
                          fillObject(false);
                        }
                      },
                      maxLength: 50,
                    ), flex: 3,
                  ),
                  Padding(padding: EdgeInsets.all(10),),
                  Expanded(child: RaisedButton(
                    //color: Colors.lightBlueAccent,
                    child: Icon(Icons.search),
                    onPressed: () => fillObject(true),
                  ), flex: 1,),
                  Padding(padding: EdgeInsets.all(10),),
                  Expanded(child: RaisedButton(
                    //color: Colors.lightBlueAccent,
                    child: Icon(Icons.my_location),
                    onPressed: () => fillObject(false),
                  ), flex: 1,),
                ],
              ),
            ],
          ),
        ))
    );
  }
}
