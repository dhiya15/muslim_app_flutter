class Quari {
  int _id;
  String _quariname;
  String _quariurl;

  int get id => _id;
  String get quariname => _quariname;
  String get quariurl => _quariurl;

  Quari.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._quariname = map["quariname"];
    this._quariurl = map["quariurl"];
  }

  @override
  String toString() {
    return _quariname;
  }
}

class Sura{
  int _id;
  String _name;

  int get id => _id;
  String get name => _name;

  Sura(int id, String name){
    this._id = id;
    this._name = name;
  }

  Sura.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
  }
}

class Dikr{
  int _id;
  String _title;
  String _url;

  int get id => _id;
  String get title => _title;
  String get url => _url;

  Dikr(this._id, this._title, this._url);

  Dikr.fromMap(Map<String, dynamic> map){
    this._id = map["ID"];
    this._title = map["Title"];
    this._url = map["Text"];
  }
}

class DikrDetails{
  int _id;
  String _text;
  int _repeat;

  int get id => _id;
  String get text => _text;
  int get repeat => _repeat;

  DikrDetails.fromMap(Map<String, dynamic> map){
    this._id = map["ID"];
    this._text = map["Text"];
    this._repeat = map["repeat"];
  }
}

class PrayingTimes{
  String imsak;
  String sunrise;
  String fajr;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String gregorian;
  String hijri;

  PrayingTimes(){
    this.imsak = "";
    this.sunrise = "";
    this.fajr = "";
    this.dhuhr = "";
    this.asr = "";
    this.sunset = "";
    this.maghrib = "";
    this.isha = "";
    this.gregorian = "";
    this.hijri = "";
  }

  @override
  String toString() {
    return 'PrayingTimes{imsak: $imsak, sunrise: $sunrise, fajr: $fajr, dhuhr: $dhuhr, asr: $asr, sunset: $sunset, maghrib: $maghrib, isha: $isha, gregorian: $gregorian, hijri: $hijri}';
  }
}