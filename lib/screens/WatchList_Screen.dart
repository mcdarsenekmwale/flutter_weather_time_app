import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:osappw/screens/time_screen.dart';
import 'package:osappw/screens/weather_screen.dart';
import 'package:osappw/services/config.dart';
import 'package:osappw/services/time.dart';
import 'package:osappw/services/weather.dart';
import 'package:osappw/widgets/place_notifier.dart';
import 'package:osappw/widgets/weather_icon.dart';
import 'package:osappw/widgets/weather_notifier.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:provider/provider.dart';

class WatchListScreen extends StatefulWidget {

  @override
  _WatchListScreenState createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> with SingleTickerProviderStateMixin{

  TabController _tabController;
  Config config;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  bool selectedValue = false;
  List selected = [];
  var weatherList,listOfPlace;
  List<bool> settings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }


  @override
  void dispose() {
    _tabController.dispose();
        super.dispose();
  }

  void onSelected(int index) {
    setState(() {
      selectedIndex = index;
      if(!selected.contains(index))
        selected.add(index);
      else
        selected.remove(selectedIndex);
      selectedValue = selected.contains(selectedIndex);
    });
  }

  @override
  void didChangeDependencies() {
    weatherList = Provider.of<WeatherNotifier>(context);
    listOfPlace = Provider.of<PlaceNotifier>(context);
    settings = weatherList.settings;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
            icon:Icon(Icons.arrow_back_ios,size: 26.0, color: Colors.white,)
            , onPressed: ()=>Navigator.pop(context)
        ),
        centerTitle: true,
        title: Text('WatchList'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white ),),
        bottom: TabBar(tabs: [
          Tab(
            text: 'Weather', icon: BoxedIcon(WeatherIcons.cloud,size: 28.0,) ,
          ),
          Tab(
            text: 'Time', icon: FaIcon(FontAwesomeIcons.clock, size: 28.0,),
          ),
        ],
          controller: _tabController,
          unselectedLabelColor: Colors.grey[100],
//          isScrollable: true,
          labelColor: Colors.white.withOpacity(0.6),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          onTap: (index){

          },
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverList(delegate: SliverChildBuilderDelegate(
                       (context, index){
                         return Padding(
                            padding:EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.00),
                            child: Container(
                              height: 70.0,
                              padding: EdgeInsets.only(top:4.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: ListTile(
                                leading: WeatherIconWidget(
                                    code: 500,
                                    size: 38,
                                    color: Colors.orangeAccent.withOpacity(0.8)
                                ),
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      size: 18.0,
                                      color: Colors.grey[600].withOpacity(0.6),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Text('${weatherList.weathers.elementAt(index).city}',
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17.0
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0, top: 4.0),
                                      child: Text('${(weatherList.weathers.elementAt(index).temperature.tempMin).floor()}\u1d52',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w500,
      //                                  fontSize: 16.0
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3.0, top: 4.0),
                                      child: Text('/',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w500,
      //                                  fontSize: 16.0
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3.0, top: 4.0),
                                      child: Text('${(weatherList.weathers.elementAt(index).temperature.tempMax).floor()}\u1d52',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w500,
      //                                  fontSize: 16.0
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text('${(weatherList.weathers.elementAt(index).temperature.tempCurrent).floor()}\u1d52',
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey
                                  ),
                                ),
                                onTap: () async{
                                  var item =weatherList.weathers.elementAt(index);
                                  Weather _weather = new Weather(lat: item.lat, lon: item.lon);
                                  await _weather.initialize();
                                  await _weather.getCityWeather(_weather.lat, _weather.lon);
                                  return Navigator.push(context, MaterialPageRoute(builder: (_)=>WeatherScreen(weather: _weather,)));
                                },
                                onLongPress: (){
                                  setState(() {
                                    weatherList.removePlace(weatherList.weathers.elementAt(index));
                                    scaffoldKey.currentState.showSnackBar(
                                        _buildSnack('${weatherList.weathers.elementAt(index).city} removed from the List')
                                    );
                                  });
                                },
                              ),
                            ),
                        );
                      },
                    childCount: weatherList.weathers.length,

                  ))
                ],
              ),
            ),
            Padding(
          padding: EdgeInsets.only(top:16.0),
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate(
                    (context, index){
                      var placeName = listOfPlace.places.elementAt(index).name.isEmpty ?
                                    listOfPlace.places.elementAt(index).region.toUpperCase() :
                                    listOfPlace.places.elementAt(index).name.toUpperCase();
                  return Padding(
                    padding:EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.00),
                    child: Container(
                      height: 70.0,
                      padding: EdgeInsets.only(top:4.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: selected.contains(index) ? Colors.grey[400].withOpacity(0.5):Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: ListTile(
                        leading: Container(
                          height: 60.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(image: AssetImage('assets/stock.jpg'),
                                  fit: BoxFit.cover)
                          ),
                        ),
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 18.0,
                              color: Colors.grey[600].withOpacity(0.6),
                            ),
                            SizedBox(width: 10.0,),
                            Text('$placeName',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(left: 5.0, top: 4.0),
                          child: Text('${listOfPlace.places.elementAt(index).region}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0
                            ),
                          ),
                        ),
                        selected: (selected.contains(index)),
                        trailing: GestureDetector(
                          onTap: (){
                                listOfPlace.removePlace(listOfPlace.places.elementAt(index));
                                scaffoldKey.currentState.showSnackBar(_buildSnack('$placeName removed from the List'));
                            },
                          child: Icon(selected.contains(index) ? Icons.clear : Icons.chevron_right,
                            color: Colors.grey.withOpacity(0.9),
                            size: 24,),
                        ),
                        onTap: () async {
                            var url =listOfPlace.places.elementAt(index).timezone;
                            Time _time = new Time(url: url, location: placeName);
                           await _time.initializeTime();
                            return Navigator.push(context, MaterialPageRoute(builder: (_)=>TimeScreen(time: _time,)));
                        },
                        onLongPress: () => onSelected(index),
                      ),
                    ),
                  );
                },
                childCount: listOfPlace.places.length,
              ))
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        child: Icon(Icons.clear_all,
          color: Colors.white.withOpacity(0.9),
          size: 34.0,
        ),
        onPressed: (){
          String s ='';

            if (_tabController.index == 0 && weatherList.totalWatchWeathers>0) {
              weatherList.removeAll();
              s = 'All weathers on your List have been cleared';
            } else if (_tabController.index == 1 && listOfPlace.totalPlaceCount>0){
              listOfPlace.removeAll();
              s = 'All places on your List have been cleared';
            }else
              s="The list is already empty ";
            scaffoldKey.currentState.showSnackBar(_buildSnack(s));

        },
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      ),
    );
  }

  SnackBar  _buildSnack(String message) {
    return  SnackBar(content: Container(
      width: 40.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Padding(
        padding:  EdgeInsets.only(left:100.0),
        child: Text(message,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, ), ),
      ),
    ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
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