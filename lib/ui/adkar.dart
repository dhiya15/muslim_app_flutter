import 'package:flutter/material.dart';
import 'package:muslim_app/api/featch_data.dart';
import 'package:muslim_app/api/models.dart';
import 'dikr_detail.dart';


class Adkar extends StatefulWidget {
  @override
  _AdkarState createState() => _AdkarState();
}

class _AdkarState extends State<Adkar> {

  List<Dikr> _allAdkar = List<Dikr>();
  List<Dikr> _oldList = List<Dikr>();
  List<DikrDetails> _dikrDetails = List<DikrDetails>();
  TextEditingController  _dikrSearch = TextEditingController();
  int _allAdkarLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fill();
  }

  void _fill() async {
    _allAdkar = await FeatchData.getAllAdkar();
    //_oldList = _allAdkar;
    for(Dikr d in _allAdkar)
      _oldList.add(d);
    setState(() {
      _allAdkarLength = _allAdkar.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 30, 15, 5),
        child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 5)),
          _searchBar(),
          Padding(padding: EdgeInsets.only(top: 5)),
          _listOfAdkar(),
        ]));
  }

  Widget _searchBar(){
    return Container(
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              textDirection: TextDirection.rtl,
              controller: _dikrSearch,
              keyboardType: TextInputType.text,
              onSubmitted: (String value) {
                _searchInList(value);
              },
              onChanged: (String value) {
                if(value.trim().isEmpty){
                  _searchInList(value);
                }
              },
              maxLength: 50,
            ), flex: 5,
          ),
          Padding(padding: EdgeInsets.all(10),),
          Expanded(child: RaisedButton(
            //color: Colors.lightBlueAccent,
            child: Icon(Icons.search),
            onPressed: () => _searchInList(_dikrSearch.text),
          ), flex: 1,
          )
        ],
      ),
    );
  }

  Widget _listOfAdkar(){
    return Expanded(
      //height: 200.0,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _allAdkarLength,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                  borderOnForeground: true,
                  shadowColor: Colors.white70,
                  margin: EdgeInsets.only(left: 6, right: 6, bottom: 6),
                  color: Colors.white70,
                  child: new Container(
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      child: ListTile(
                        title: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Image.asset("images/icon_adkari.png", height: 32, width: 32)),
                            Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                            Expanded(child: Text(_allAdkar[position].title, textAlign: TextAlign.right), flex:3),
                            Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                            Expanded(child: Listener(
                              child: Icon(Icons.more),
                              onPointerDown: (pointerevent){ _showDikrIn(_allAdkar[position].url, _allAdkar[position].title); },
                            ), flex: 1),
                          ],
                        ),
                      )
                  )
              );
            }
        )
    );
  }

  void _showDikrIn(String url, String title) async{
    _dikrDetails = await FeatchData.getDikrDetails(url);
    var router = new MaterialPageRoute(
        builder: (BuildContext context) => DikrDetail(_dikrDetails, title)
    );
    Navigator.of(context).push(router);
  }

  void _searchInList(String name){
    if(name.trim().isNotEmpty){
      List<Dikr> result = List<Dikr>();
      for(int i=0; i<_allAdkar.length; i++){
        if(_allAdkar[i].title.contains(name)){
          result.add(_allAdkar[i]);
        }
      }
      setState(() {
        _allAdkar = result;
        _allAdkarLength = result.length;
      });
    }else{
      setState(() {
        _allAdkar = _oldList;
        _allAdkarLength = _oldList.length;
      });
    }
  }

}