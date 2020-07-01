import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:osappw/screens/settings_screen.dart';
import 'package:osappw/screens/share_screen.dart';
import 'package:osappw/screens/time_screen.dart';
import 'package:osappw/screens/weather_screen.dart';
import 'package:osappw/services/config.dart';
import 'package:osappw/services/startup_service.dart';
import 'package:osappw/services/time.dart';
import 'package:osappw/services/weather.dart';
import 'package:osappw/widgets/weather_icon.dart';
import 'package:osappw/widgets/weather_notifier.dart';
import 'package:osappw/widgets/weather_stats.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'WatchList_Screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey globalKey = new GlobalKey();

  Config config = new Config();
  Weather _weather;
  Time _time;
  Map data = new Map();
  List<bool> settings = new List();
  @override
  void initState() {
    super.initState();
//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => refreshIndicatorKey.currentState.show());
  }

  bool inside = false;
  Uint8List imageInMemory;
  Future<Uint8List> capturePage() async {
    try {
      inside = true;
      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      setState(() {
        imageInMemory = pngBytes;
        inside = false;
      });
      return pngBytes;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _getSettings() async{
    await config.loadSettings();
    setState(() {
      settings =  config.settings;
    });
  }

  @override
  void didChangeDependencies() {
    data = ModalRoute.of(context).settings.arguments;
    _weather = data['_weather'];
    _time =data['_time'];
    settings = data['_settings'];
    _getSettings();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    _getSettings();

    return RepaintBoundary(
      key: globalKey,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        drawer: _buildSideMenu(context),
        body:RefreshIndicator(
                  key: refreshIndicatorKey,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  onRefresh: () async {
                    StartUpService startUp = new StartUpService();
                    await startUp.getReadyData();
                    setState(() {
                      data = startUp.service;
                      _weather = data['_weather'];
                      _time =data['_time'];
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 400.0,
                            decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                borderRadius: BorderRadius.circular(4.0),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(34, 201, 190, 1),
                                      Color.fromRGBO(34, 201, 190, 0.9),
                                      Color.fromRGBO(34, 201, 190, 0.8),
                                      Color.fromRGBO(34, 201, 190, 0.5),
                                      Color.fromRGBO(34, 201, 190, 0.9),
                                    ]
                                )
                            ),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 40.0,
                                    left: 20.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          scaffoldKey.currentState.openDrawer();
                                        });
                                      },
                                      child: Icon(Icons.sort,
                                        color: Colors.white,
                                        size: 36.0,)
                                      ,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40.0,
                                    left: _weather.city.length<12? 120.0 : 100.0,
                                    child: Text('${_weather.city}, ${_weather.country}',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w400,
                                          fontSize: _weather.city.length<12?23.0 : 17.0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 45.0,
                                    right: 15.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                          await capturePage();
                                          if(imageInMemory != null)
                                            return Navigator.push(context, MaterialPageRoute(builder:(_)=>ShareScreen( image : imageInMemory) ));
                                          else
                                            return null;
//
                                      },
                                      child: Icon(Icons.share,
                                        color: Colors.white,
                                        size: 36.0,),
                                    ),
                                  ),
                                  Positioned(
                                    top: 90.0,
                                    right: 15.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          refreshIndicatorKey.currentState.show();
                                        });
                                      },
                                      child: Icon(Icons.sync,
                                        color: Colors.white,
                                        size: 36.0,),
                                    ),
                                  ),
                                  Positioned(
                                      top: 150.0,
                                      left: 125.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            return Navigator.push(context, MaterialPageRoute(
                                              builder: (_) => WeatherScreen(weather: _weather),));
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text('${_weather.weatherData.weatherMain} ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 1.0,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 30.0
                                              ),
                                            ),
                                            SizedBox(width: 25.0,),
                                            WeatherIconWidget(code:_weather.weatherData.weatherId, size: 55, color: Colors.orangeAccent.withOpacity(0.7),)
                                          ],
                                        ),
                                      )
                                  ),
                                  Positioned(
                                    top: 210.0,
                                    left: 120.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        return Navigator.push(context, MaterialPageRoute(
                                          builder: (_) => WeatherScreen(weather: _weather, settings: this.settings),));
                                      },
                                      child: Hero(
                                        tag: 'Weather',
                                        child: Text('${(config.setTemperatureUnits(_weather.temperature.tempCurrent, settings )).floor()}°',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 100.0
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildBottomText()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Expanded(
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 389.0,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: 383.63,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0))
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            _buildWeatherIcons(FontAwesomeIcons.tint,
                                                'Humidity', _weather.temperature.humidity,'%',
                                                Color.fromRGBO(34, 201, 190, 1)),
                                            _buildWeatherIcons(FontAwesomeIcons.wind, 'Wind',
                                                config.setVelocityUnits(_weather.wind.windSpeed,!settings[1] ), '',
                                                Colors.orangeAccent),
                                            _buildWeatherIcons(FontAwesomeIcons.tachometerAlt,
                                                'Pressure', _weather.temperature.pressure,' hPa',
                                                Colors.blue[500])

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20.0,
                                      child: WeatherStatsWidget(weather: _weather.weatherHourly, config: config, settings:settings)
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
      ),
    );
  }

  Widget _buildWeatherIcons(IconData icon, String text, dynamic values, String units, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 12.0),
      child: Container(
        height: 110.0,
        width: 110.0,
        decoration: BoxDecoration(
            color: Colors.grey[100].withOpacity(0.5),
            borderRadius: BorderRadius.circular(50.0)
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: Column(
            children: <Widget>[
              FaIcon(icon,
                color: color,
                size: 40.0,
              ),
              Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.grey
                ),
              ),
              Text('$values$units',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: Colors.grey
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, Route route ) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Icon(icon,
          size: 30.0,
          color: Colors.grey[800],
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            letterSpacing: 0.5
          ),
        ),
      ),
      onTap: () => (text=='Exit') ?
       SystemChannels.platform.invokeMethod('SystemNavigator.pop', true)
      :Navigator.push(context,  route),
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    return Container(
      width: 280.0,
      height: MediaQuery
          .of(context)
          .size
          .height,
      color: Colors.white.withOpacity(0.8),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Container(
                    height: 70.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(image: AssetImage("assets/icon.png"),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text('OS APP',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400,
                      color: Theme
                          .of(context)
                          .primaryColor
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0,),
          _buildMenuItem(Icons.message, 'Watch List', MaterialPageRoute(builder: (_)=>WatchListScreen())),
          _buildMenuItem(Icons.settings, 'Settings', MaterialPageRoute(builder: (_)=>SettingScreen(settings: this.settings,))),
          _buildMenuItem(Icons.power_settings_new, 'Exit', MaterialPageRoute(builder: (_)=>WatchListScreen()))
        ],
      ),
    );
  }

  Widget _buildBottomText() {
    return Positioned(
      bottom: 15.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 20.0),
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>TimeScreen(time: _time,), )),
          child: Hero(
            tag: 'time',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('${_time.date}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(width: 20.0,),
                Text('${_time.time}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}