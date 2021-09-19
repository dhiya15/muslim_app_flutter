import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:muslim_app/api/featch_data.dart';
import 'package:muslim_app/api/models.dart';
import 'package:muslim_app/tools/strings.dart';
import 'package:muslim_app/tools/tools.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:file_utils/file_utils.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Quari> _allQurraa = List<Quari>();
  List<Sura> _allSuar = List<Sura>();
  Quari _currentQuari;
  int _allSuarLength = 0, _prev = 1, _next = 1;
  int _min = 0, _max = 0, _valueHolder = 0;
  AudioPlayer _audioPlayer = AudioPlayer();
  IconData _prIcon = Icons.pause_circle_filled;
  double _downloadPourcent = 0.0;
  String _currentSura = "-----", _currentSuraFullTime = "-----", _currentSuraTime = "-----";
  ProgressDialog _pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fill();
    _audioPlayer.onAudioPositionChanged.listen((Duration d) {
      int x = d.inMilliseconds;
      setState(() {
        _currentSuraTime = d.toString().substring(0, 7);
        if(x < _max && x > _min)
          _valueHolder = x;
      });
    });

  }

  void _fill() async {
    _allQurraa = await FeatchData.getAllQurraa();
    _allSuar = await FeatchData.getAllSuar();
    setState(() {
      _allSuarLength = _allSuar.length;
      _currentQuari = _allQurraa[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 30, 5, 5),
        child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 5)),
          Row(
              children: [
                Text(Strings.quari),
                Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                _quraaList(),
              ],
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Row(
              children: [
                Text(_currentSura),
                Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                Text(_currentSuraFullTime),
                Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                Text(_currentSuraTime),
              ],
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          _seekBar(),
          _mediaControls(),
          Padding(padding: EdgeInsets.only(top: 5)),
          _listOfSuar(),
        ]));
  }

  Widget _quraaList() {
    return DropdownButton<Quari>(
      value: _currentQuari,
      icon: Icon(Icons.arrow_drop_down_circle),
      onChanged: (Quari newValue) {
        setState(() {
          _currentQuari = newValue;
        });
      },
      items: _allQurraa.map<DropdownMenuItem<Quari>>((Quari value) {
        return DropdownMenuItem<Quari>(
            value: value,
            child: Center(
                child: Text(
              value.toString(),
              textAlign: TextAlign.right,
            )));
      }).toList(),
    );
  }

  Widget _seekBar() {
    return Center(
        child: Slider(
            value: _valueHolder.toDouble(),
            min: _min.toDouble(),
            max: _max.toDouble(),
            activeColor: Tools.backColor,
            inactiveColor: Colors.grey,
            label: '${_valueHolder.round()}',
            onChanged: (double newValue) {
              setState(() {
                _valueHolder = newValue.round();
              });
            }
        )
    );
  }

  Widget _mediaControls(){
    return Container(
        child: Row(
            children: [
              Expanded(child: RaisedButton(child: Icon(_prIcon), onPressed: _pauseOrResume), flex: 1),
              Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
              Expanded(child: RaisedButton(child: Icon(Icons.skip_previous), onPressed: ()=>_play(_next)), flex: 1),
              Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
              Expanded(child: RaisedButton(child: Icon(Icons.skip_next), onPressed: ()=>_play(_prev)), flex: 1),
              Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
              Expanded(child: RaisedButton(child: Icon(Icons.stop_circle), onPressed: _stop), flex: 1),
            ],
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.center
        )
    );
  }

  Widget _listOfSuar(){
    return Expanded(
      //height: 200.0,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _allSuarLength,
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
                            Expanded(child: Image.asset("images/mushaf.png", height: 32, width: 32)),
                            Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                            Expanded(child: Text(_allSuar[position].name, textAlign: TextAlign.right), flex:3),
                            Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                            Expanded(child: Listener(
                              child: Icon(Icons.speaker),
                              onPointerDown: (pointerevent){ _play(_allSuar[position].id); },
                            ), flex: 1),
                            Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                            Expanded(child: Listener(
                              child: Icon(Icons.download_sharp),
                              onPointerDown: (pointerevent){ _download(_allSuar[position].id); },
                            ), flex: 1)
                          ],
                        ),
                      )
                  )
              );
            }
            )
    );
  }

  void _play(int position) async{
    _next = Tools.updateNext(position);
    _prev = Tools.updatePrev(position);
    String sura = Tools.transformeNumberOfSura(position);
    String url = _currentQuari.quariurl + sura + ".mp3";

    just_audio.AudioPlayer audio = just_audio.AudioPlayer();
     await audio.load(
         just_audio.ConcatenatingAudioSource(
           children: [
             just_audio.AudioSource.uri(Uri.parse(url)),
           ],
         )
    );
    setState(() {
      _currentSura = _allSuar[position-1].name;
      _currentSuraFullTime = audio.duration.toString().substring(0, 7);
      _max = audio.duration.inMilliseconds;
    });

    _audioPlayer.play(url);
  }

  void _stop() {
    if(_audioPlayer.state == AudioPlayerState.PLAYING) {
      _audioPlayer.stop();
      setState(() {
        _currentSura = "-----";
        _currentSuraFullTime = "-----";
        _currentSuraTime = "-----";
        _valueHolder = 0;
      });
    }
  }

  void _pauseOrResume(){
    if(_audioPlayer.state == AudioPlayerState.PLAYING) {
      _audioPlayer.pause();
      setState(() {
        _prIcon = Icons.play_circle_fill;
      });
    }else if(_audioPlayer.state == AudioPlayerState.PAUSED){
      _audioPlayer.resume();
        setState(() {
          _prIcon = Icons.pause_circle_filled;
        });
    }
  }

  void _download(int position) async{
    String sura = Tools.transformeNumberOfSura(position);
    String url = _currentQuari.quariurl + sura + ".mp3";
    String savedDir = _currentQuari.quariname + "/" + sura + ".mp3";
    bool status = await Tools.requestPermissions();
    if(status){
      Dio dio = Dio();
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }
      try {
        FileUtils.mkdir([dirloc]);
        _pr = new ProgressDialog(context, type: ProgressDialogType.Download, isDismissible: false, textDirection: TextDirection.rtl);
        _pr.show();
        await dio.download(url, dirloc + savedDir, onReceiveProgress: _showDownloadProgress);
        _pr.hide();
      } catch (e) {
        print(e);
      }
    }
  }

  void _showDownloadProgress(received, total) {
    if (total != -1) {
      _downloadPourcent = (received / total * 100);
      double d = double.parse(_downloadPourcent.toStringAsFixed(2));
      _pr.update(progress: d, message: Strings.download_status + " %");
    }
  }

}