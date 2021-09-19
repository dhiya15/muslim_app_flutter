import 'package:flutter/material.dart';
import 'package:muslim_app/api/models.dart';
import 'package:muslim_app/tools/strings.dart';
import 'package:muslim_app/tools/tools.dart';

class DikrDetail extends StatefulWidget {

  List<DikrDetails> _dikrDetails = List<DikrDetails>();
  String _title;

  DikrDetail(List<DikrDetails> list, String title){
    this._dikrDetails = list;
    this._title = title;
  }

  @override
  _DikrDetailState createState() => _DikrDetailState();
}

class _DikrDetailState extends State<DikrDetail> {

  int curr = 0;
  String title = "";
  String content = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    content = widget._dikrDetails[curr].text;
    title = widget._title;
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
                Image.asset("images/icon_adkari.png", height: 100, width: 100,),
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(title, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(content, textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify),
                Padding(padding: EdgeInsets.only(top: 60)),
                Row(
                  //textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: RaisedButton(
                            onPressed: () => prev(),
                            child: Text(Strings.prev)
                        ),
                        flex: 1
                    ),
                    Padding(padding: EdgeInsets.only(left: 15, right: 15)),
                    Expanded(
                        child: RaisedButton(
                            onPressed: () => next(),
                            child: Text(Strings.next)
                        ),
                        flex: 1
                    ),
                  ],
                ),
              ],
            ),
          ))
    );
  }

  void prev(){
    curr = curr - 1;
    if(curr == -1)
      curr = 0;
    setState(() {
      content = widget._dikrDetails[curr].text;
    });
  }

  void next(){
    curr = curr + 1;
    if(curr == widget._dikrDetails.length)
      curr = widget._dikrDetails.length - 1;
    setState(() {
      content = widget._dikrDetails[curr].text;
    });
  }
}
