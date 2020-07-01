import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osappw/services/config.dart';
import 'package:osappw/services/weather.dart';
import 'package:osappw/widgets/weather_icon.dart';
import 'package:osappw/widgets/weather_notifier.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  final Weather weather ;
  final settings;
  WeatherScreen({ this.weather, this.settings, });
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather currentWeather;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController itemsController =  new ScrollController();
  Config config = new Config();
  Weather dataWeather;
  dynamic currentTemp;
  var listOfWeather;
  int firstItems = 10;
  int countrySize = 100;
  List<bool> settings = new List<bool>();
  Map favourite = new Map();

  @override
  void initState() {
    super.initState();
    _getSettings();
    itemsController.addListener(scrollListener);
  }

  Future<void> _getSettings() async{
    await config.loadSettings();
    setState(() {
      settings =  config.settings ?? widget.settings;
      favourite = config.favourite;
    });
  }

  scrollListener() async {
      if (itemsController.offset >= itemsController.position.maxScrollExtent &&
          !itemsController.position.outOfRange) {
        setState(() {
          if(firstItems < countrySize)
              firstItems +=10;
          else
            firstItems = countrySize;
        });
      }
      if (itemsController.offset <= itemsController.position.minScrollExtent &&
          !itemsController.position.outOfRange) {
        setState(() {
          if(firstItems < countrySize)
            firstItems +=1;
          else
            firstItems = countrySize;
        });
        await listOfWeather.getAllWeather(firstItems);
        countrySize = listOfWeather.countrySize;
      }
  }

  @override
  void didChangeDependencies() {
    currentTemp = (widget.weather.temperature.tempCurrent).floor() < 10 ? '.0':'';
    listOfWeather = Provider.of<Weather>(context)??[];
    dataWeather = widget.weather;
    _getSettings();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    settings =settings.isNotEmpty?settings: widget.settings;

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            height: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(34, 201, 190, 1),
                    Color.fromRGBO(34, 201, 190, 0.8),
                    Color.fromRGBO(34, 201, 190, 0.6),
                    Color.fromRGBO(34, 201, 190, 0.5),
                    Color.fromRGBO(34, 201, 190, 0.4)
              ]
              )
            ),
            child: Column(
              children: <Widget>[
                Hero(
                  tag:'Weathers',
                  child: Container(
                    height: 265.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 45.0,
                          left: 10.0,
                          child: GestureDetector(
                            onTap: () {
                                setState(() {
                                  return Navigator.pop(context);
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 26.0,)
                            ,
                          ),
                        ),
                        Positioned(
                          top: 40.0,
                          left: dataWeather.city.length<11? 150.0 : 100.0,
                          child: Row(
                            children: <Widget>[
                              Text('${(dataWeather.city)}, ${dataWeather.country}',
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.30,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(Icons.location_on,
                                size: 15.0,
                                color: Colors.white.withOpacity(0.7),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 45.0,
                          right: 10.0,
                          child: GestureDetector(
                            onTap: () async {
                              Map fav = await config.setDefaultLocation(dataWeather.lat, dataWeather.lon);
                              setState(() {
                                  print(fav);
                                favourite = fav;
                              });
                            },
                            child: Icon(
                              (favourite['lat']==dataWeather.lat && favourite['lng']==dataWeather.lon)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: (favourite['lat']==dataWeather.lat && favourite['lng']==dataWeather.lon)
                                  ?Colors.orangeAccent.withOpacity(0.9)
                                  :Colors.white.withOpacity(0.5),
                              size: 26.0,)
                            ,
                          ),
                        ),
                        Positioned(
                          top: 90.0,
                          left: 53.0,
                          child: Text('${((config.setTemperatureUnits(dataWeather.temperature.tempCurrent, settings))).floor()}$currentTemp',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.30,
                                fontWeight: FontWeight.w300,
                                fontSize: 100.0
                            ),
                          ),
                        ),
                        Positioned(
                          top: 99.0,
                          left: 165.0,
                          child: Text('  o',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w400,
                                fontSize: 25.0
                            ),
                          ),
                        ),
                        Positioned(
                          top: 102.0,
                          left: 176.0,
                          child: Text( settings[0] ?'  C': '  F',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w400,
                                fontSize: 38.0
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200.0,
                          left: 70.0,
                          child: Row(
                            children: <Widget>[
                              Text('${(config.setTemperatureUnits(dataWeather.temperature.tempMin, settings)).floor()}\u1d52',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 28.0
                                ),
                              ),
                              Text('/',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 28.0
                                ),
                              ),
                              Text('${(config.setTemperatureUnits(dataWeather.temperature.tempMax, settings)).floor()}\u1d52',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 28.0
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 90.0,
                          right: 90.0,
                          child: Column(
                            children: <Widget>[
                              WeatherIconWidget(code: (dataWeather.weatherData.weatherId),size: 50, color: Colors.orangeAccent.withOpacity(0.7)),
                              SizedBox(width: 10.0,),
                              Padding(
                                padding: EdgeInsets.only(left:18.0),
                                child: Text('${(dataWeather.weatherData.weatherMain)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25.0,
                                  color: Colors.white
                                ),),
                              )
                            ],
                          ),
                        )
                      ],
                    ) ,
                  ),
                ),
                Container(
                  height: 128.0,
                  padding: EdgeInsets.only(left: 7.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:dataWeather.weatherForecast
                        .asMap()
                        .entries
                        .map((MapEntry map) =>_buildCards(map.value),)
                        .toList()

                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: listOfWeather.getAllWeather(firstItems),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                return RefreshIndicator(
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                      onRefresh: () async {
                          await listOfWeather.getAllWeather(firstItems);
                      },
                      child: ListView.builder(
                        controller: itemsController,
                        itemCount: (firstItems == listOfWeather.countryWeathers.length)? firstItems: listOfWeather.countryWeathers.length,
                          itemExtent: 85.0,
                          cacheExtent: 3 ,
                          itemBuilder: (context, index){
                              return _buildWeatherCards(listOfWeather, index,context);
                        }
                        ),
                );
                }
                else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width:MediaQuery.of(context).size.width,
                          height: 30,
                          decoration:BoxDecoration(
                              color: Colors.grey[100].withOpacity(0.7),
                              borderRadius:     BorderRadius.circular(10)
                          ),
                          child: Text("${snapshot.error}", style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0
                          ),)
                      ),
                    ],
                  );
                }
                return Padding(
                  padding:  EdgeInsets.all(180.0),
                  child: Container(
                    height: 33.0,
                    width: MediaQuery.of(context).size.width,
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                    ),
                  ),
                );
              }
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCards(Weather listOfWeather,int index, BuildContext context){
    var watchlist = Provider.of<WeatherNotifier>(context);
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: 3.0, horizontal: 8.00),
        child: Container(
          height: 70.0,
          padding: EdgeInsets.only(top: 4.0, bottom: 10.0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -2.0,
                left: 2.0,
                child: Icon(
                  watchlist.weathers.contains(listOfWeather.countryWeathers.elementAt(index))
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.orangeAccent.withOpacity(0.9),
                  size: 14,),
              ),
              Container(
                child: ListTile(
                  leading: WeatherIconWidget(
                      code: listOfWeather.countryWeathers.elementAt(index).weatherData.weatherId ,
                      size: 38,
                      color: Colors.orangeAccent.withOpacity(
                          0.8)),
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 18.0,
                        color: Colors.grey[600].withOpacity(
                            0.6),
                      ),
                      SizedBox(width: 10.0,),
                      Text('${listOfWeather.countryWeathers.elementAt(index).city.toUpperCase()}, ',
                        style: TextStyle(
                            color: Colors.grey[700].withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0
                        ),
                      ),
                      Text('${listOfWeather.countryWeathers.elementAt(index).country.toUpperCase()}, ',
                        style: TextStyle(
                            color: Colors.grey[500].withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.0, top: 4.0),
                        child: Text('${(config.setTemperatureUnits(listOfWeather.countryWeathers.elementAt(index).temperature.tempMin, settings)) .floor()}\u1d52',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
//                                  fontSize: 16.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0, top: 4.0),
                        child: Text('/',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
//                                  fontSize: 16.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0, top: 4.0),
                        child: Text('${(config.setTemperatureUnits(listOfWeather.countryWeathers.elementAt(index).temperature.tempMax, settings)).floor()}\u1d52',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
//                                  fontSize: 16.0
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, top: 10.0),
                        child: Text('${listOfWeather.countryWeathers.elementAt(index).weatherData.weatherMain}',
                          style: TextStyle(
                              fontSize: 8.0,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).primaryColor
                          ),),
                      )
                    ],
                  ),
                  trailing: Text('${(config.setTemperatureUnits(listOfWeather.countryWeathers.elementAt(index).temperature.tempCurrent, settings)).floor()}\u1d52',
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey
                    ),
                  ),
                  onTap: ()  async{
                var item =listOfWeather.countryWeathers.elementAt(index);
                Weather _weather = new Weather(lat: item.lat, lon: item.lon);
                await _weather.initialize();
                await _weather.getCityWeather(_weather.lat, _weather.lon);
                setState(() {
                dataWeather = _weather;
                });

                  },
                  selected: watchlist.weathers.contains(listOfWeather.countryWeathers.elementAt(index)),
                  onLongPress: () {
                    setState(() {
                      watchlist.weathers.contains(listOfWeather.countryWeathers.elementAt(index)) ? ()=>null :
                      watchlist.add(listOfWeather.countryWeathers.elementAt(index));
                      scaffoldKey.currentState.showSnackBar(_buildSnack('Added to Watchlist',));
                    });
                  },),
              ),
            ],),)
    );
  }

  Widget _buildCards(Weather data){
    return Padding(
      padding: EdgeInsets.only(left:5.0),
      child: Container(
        width: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white.withOpacity(0.2)
            ]
          )
        ),
        child: Column(
          children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text( data.day == 'Wednesday'?'Wednes':'${data.day}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top:2.0),
                  child: Text('${data.dateFullFormatted}',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8)
                    ),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top:12.0),
                child: WeatherIconWidget(code: data.weatherData.weatherId, size:20, color: Colors.orangeAccent.withOpacity(0.5))
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top:5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${(config.setTemperatureUnits(data.temperature.tempMin, settings)).floor()}\u1d52 / ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8)
                      ),
                    ),
                    Text('${(config.setTemperatureUnits(data.temperature.tempMax, settings)).floor()}\u1d52 ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top:2.0),
                child: Text('${data.weatherData.weatherMain}',
                  style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSnack(String s) {
    return  SnackBar(content: Container(
      width: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Padding(
        padding:  EdgeInsets.only(left:100.0),
        child: Text(s,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, ), ),
      ),
    ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom:Radius.circular(20),
        ),
      ),
    );
  }


}



