import 'package:shared_preferences/shared_preferences.dart';

class Config{
  List<bool> settings ;
  List<Map> switchedOn = [
    {'name': 'temperature', 'value': false },
    {'name': 'velocity', 'value': false },
    {'name': 'location', 'value': false }
  ];
  var favourite ={
  'lat': 39.13,
  'lng': 117.2,
  };

  Config({this.favourite}){
    this.favourite = this.favourite ??{
      'lat': 39.13,
      'lng': 117.2,
    };
  }

  //Loading settings value on start
initSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<bool> tempSet = [];
    switchedOn.asMap().entries.map((MapEntry map) async {
     await prefs.setBool(map.value['name'], map.value['value']);
    }).toList();
  }


  //Loading settings value on start
  Future<List<bool>> loadSettings() async {
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<bool> tempSet = [];
    switchedOn.asMap().entries.map((MapEntry map){
      tempSet.add(prefs.getBool(map.value['name']) ?? map.value['value']);
    }).toList();
    settings = tempSet;
    if(settings.isEmpty){
      this.initSettings();
      return this.loadSettings();
    }
    return settings;
  }catch(e){
    this.initSettings();
    return settings=[false, false, false];
  }
  }

  //Set settings after click
  Future<void> setSettings(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switchedOn[index]['value'] = !switchedOn[index]['value'];
    prefs.setBool(switchedOn[index]['name'], switchedOn[index]['value']);
    settings[index] = switchedOn[index]['value'];
    return  settings[index];
  }


  //Loading default location on start
  Future<void> getDefaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double lat = prefs.getDouble('lat' ?? favourite['lat']);
    double lng = prefs.getDouble('lng' ?? favourite['lng']);
    this.favourite = {
      'lat':lat??Config().favourite['lat'],
      'lng':lng??Config().favourite['lng']
    };
    return this.favourite;
  }

  //Set default location
  Future<Map> setDefaultLocation(dynamic lat, dynamic lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat' , lat);
    prefs.setDouble('lng' , lng);
    this.favourite = {
      'lat':lat,
      'lng':lng
    };
    return this.favourite;
  }


  dynamic setTemperatureUnits(dynamic temperature, List<bool> setting) {
    if(setting[0])
      return (temperature) ;
    else {
      dynamic temp = temperature ;
      dynamic answer = (temp * 9/5) + 32;
      return answer;
    }
  }

  dynamic setVelocityUnits(dynamic velocity, bool setting) {
    if(setting) {
      return (double.parse((velocity).toStringAsFixed(2)).toString()+' m/s');
    }
    else {
      dynamic speed = (velocity * 3.6);
      dynamic vel = double.parse((speed).toStringAsFixed(1));
      return vel.toString()+'km/h';
    }
  }
}