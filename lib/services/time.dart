import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:core';

class Time{
  String location; //location for Ui
  String time; //time in that location
  String date; //time in that location
  String flag; //url to an asset flag icon
  String url;  // location url for api end points
  bool isDaytime; // true or false
  int id;

  Time({this.location, this.flag, this.url, this.id});

  Future<void> initializeTime() async {
    try {
      Response response = await get(
          'http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);
      //get properties
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      var __temp = datetime.substring(0,19);
      //create a datetime object
      var now =  DateTime.parse(__temp);
      time = DateFormat.jm().format(now); //set time property
      date = new DateFormat.MMMEd().format(now);
      now = now.add(Duration(hours: int.parse(offset)));
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;

      return (date);
    }
    catch (e) {
      Future.error(e);
    }
  }

  String setupDateFormatted(int date) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: false);
    return new DateFormat.MMMEd().format(dateTime);
  }

  Future<void> getTime() async{
    try{
      Response response = await get('http://worldtimeapi.org/api/timezone/$url');
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        Map data  = jsonDecode(response.body);
        //set up time
        String datetime = data['datetime'];
        String offset = data['utc_offset'].substring(1, 3);

        //create a datetime object
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));
        isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
        return time = DateFormat.jm().format(now); //set time property
      }
      else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load weather');
      }
    }
    catch(e){
      throw Exception(e);
    }
  }

}

class Places{
  int id;
  String name;
  String region;
  String timezone;
  Places place;
  List<Places> places = [];

  Places({this.id, this.region, this.name, this.timezone, this.place});

  Future<void> getDifferentPlaces() async{
    try{
      Response response = await get('http://worldtimeapi.org/api/timezone/');
      List<dynamic> data  = jsonDecode(response.body);
      //get properties
      List<Places> holders = [];
      int index = 0;
      data.forEach((timezone){
        List<String> _name = timezone.toString().split('/');
        holders.add(
            Places(id: index, timezone: timezone, name: (_name.length <2)? '': _name[1], region: _name[0])
        );
        index++;
      });
      places = holders;
      return places;
    }
    catch(e){
      Future.error(e);
    }
  }

  /// In this sample, the watchlist is infinite, looping over [_Location].
  Places getById(int id)=>places.elementAt(id);


  /// Get time by its position in the watchlist.
  /// // In this simplified case, an weather's position in the weather
  //    // is also its id.
  Places getByPosition(int position) => getById(position);


  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Places && other.id == id;
}