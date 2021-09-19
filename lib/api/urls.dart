import 'package:geolocator/geolocator.dart';

class Urls {

  static final String _ROOT = "http://192.168.1.4:8080/";
  static final String ALL_QURRAA = _ROOT + "Quari/All";
  static final String ALL_SUAR = "http://api.alquran.cloud/v1/surah";
  static final String ADKAR_URL = "http://mp3quran.net/api/husn/ar/husn_ar.json";
  static final String PRAY_TIMES_CITY = "https://api.pray.zone/v2/times/today.json?city=";

  static Future<String> prayTimesLocation() async{
    Geolocator geolocator = new Geolocator();
    Position position = await geolocator.getCurrentPosition();
    if(position == null)
      position = await geolocator.getLastKnownPosition();
    return "https://api.pray.zone/v2/times/today.json?longitude=${position.longitude}&latitude=${position.latitude}&elevation=333";
  }

}