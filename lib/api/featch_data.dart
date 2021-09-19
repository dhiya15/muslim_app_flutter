import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:muslim_app/api/models.dart';
import 'package:http/http.dart' as http;
import 'package:muslim_app/api/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeatchData{

  static Future<List<Quari>> getAllQurraa() async {
    http.Response response = await http.post(Urls.ALL_QURRAA);
    List list = json.decode(response.body);
    List<Quari> ml = List<Quari>();
    list.forEach((element) {
      ml.add(Quari.fromMap(element));
    });
    return ml;
  }

  static Future<List<Sura>> getAllSuar() async {
    http.Response response = await http.get(Urls.ALL_SUAR);
    List list = json.decode(response.body)["data"];
    List<Sura> ml = List<Sura>();
    list.forEach((element) {
      ml.add(Sura(element["number"], element["name"]));
    });
    return ml;
  }

  static Future<List<Dikr>> getAllAdkar() async {
    http.Response response = await http.get(Urls.ADKAR_URL);
    List list = json.decode(utf8.decode(response.bodyBytes))["العربية"];
    List<Dikr> ml = List<Dikr>();
    list.forEach((element) {
      ml.add(Dikr(element["ID"], element["Title"], element["Text"]));
    });
    return ml;
  }

  static Future<List<DikrDetails>> getDikrDetails(String url) async {
    Response<List<int>> rs = await Dio().get<List<int>>(
      url, options: Options(responseType: ResponseType.bytes),
    );
    String data = utf8.decode(rs.data).toString();
    data = data.substring(data.indexOf("["), data.length-1);
    List list = json.decode(data);
    List<DikrDetails> ml = List<DikrDetails>();
    list.forEach((element) {
      ml.add(DikrDetails.fromMap(element));
    });
    return ml;
  }

  static Future<PrayingTimes> getPrayingTimes(bool city, {String place}) async {
    http.Response response;
    if(city && place.trim().isNotEmpty) {
      response = await http.get(Urls.PRAY_TIMES_CITY + place);
    }else {
      String url = await Urls.prayTimesLocation();
      response = await http.get(url);
    }
    List list = json.decode(response.body)["results"]["datetime"];
    if(list != null){
      PrayingTimes pt = PrayingTimes();
      list.forEach((element) {
        pt.imsak = element["times"]["Imsak"];
        pt.sunrise = element["times"]["Sunrise"];
        pt.fajr = element["times"]["Fajr"];
        pt.dhuhr = element["times"]["Dhuhr"];
        pt.asr = element["times"]["Asr"];
        pt.sunset = element["times"]["Sunset"];
        pt.maghrib = element["times"]["Maghrib"];
        pt.isha = element["times"]["Isha"];
        pt.gregorian = element["date"]["gregorian"];
        pt.hijri = element["date"]["hijri"];
      });
      await _saveDataTimes(pt);
      return pt;
    }
    return null;
  }

  static void _saveDataTimes( PrayingTimes pt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Imsak", pt.imsak);
    prefs.setString("Sunrise", pt.sunrise);
    prefs.setString("Fajr", pt.fajr);
    prefs.setString("Dhuhr", pt.dhuhr);
    prefs.setString("Asr", pt.asr);
    prefs.setString("Sunset", pt.sunset);
    prefs.setString("Maghrib", pt.maghrib);
    prefs.setString("Isha", pt.isha);
    prefs.setString("gregorian", pt.gregorian);
    prefs.setString("hijri", pt.hijri);
  }

  static Future<PrayingTimes> getLocalPrayingTimes() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PrayingTimes pt = PrayingTimes();
    pt.imsak = prefs.getString("Imsak") ?? "";
    print(prefs.getString("Imsak"));
    pt.sunrise = prefs.getString("Sunrise") ?? "";
    print(prefs.getString("Sunrise"));
    pt.fajr = prefs.getString("Fajr") ?? "";
    pt.dhuhr = prefs.getString("Dhuhr") ?? "";
    pt.asr = prefs.getString("Asr") ?? "";
    pt.sunset = prefs.getString("Sunset") ?? "";
    pt.maghrib = prefs.getString("Maghrib") ?? "";
    pt.isha = prefs.getString("Isha");
    pt.gregorian = prefs.getString("gregorian") ?? "";
    pt.hijri = prefs.getString("hijri") ?? "";
    return pt;
  }

}