import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:osappw/services/time.dart';
import 'package:osappw/widgets/place_notifier.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class TimeScreen extends StatefulWidget {
  final Time time;
  const TimeScreen({Key key, this.time}) : super(key: key);

  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var listOfPlaces ;
  var watchlist ;
  var objTime ;

  @override
  void didChangeDependencies() {
    listOfPlaces = Provider.of<Places>(context);
    watchlist = Provider.of<PlaceNotifier>(context);
    objTime = widget.time;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    var time = (objTime.time.toString().substring(5)=='AM' || objTime.time.toString().substring(6)=='AM')?
                            objTime.time.toString().replaceFirst('AM', '') : objTime.time.toString().replaceFirst('PM', '');
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container( 
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
                  Flexible(
                    fit: FlexFit.loose,
                    child: ClipRect(
                      clipBehavior: Clip.antiAlias,
                      child: Hero(
                        tag:'',
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
                                      setState(() {
                                        return Navigator.pop(context);
                                      });
                                    });
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 26.0,)
                                ),
                              ),
                              Positioned(
                                top: 40.0,
                                left: objTime.location.toString().length < 9? 165 : 130.0,
                                child: Row(
                                  children: <Widget>[
                                    Text('${objTime.location}',
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
                                top: 90.0,
                                left: 120.0,
                                child: Container(
                                  height: 160.0,
                                  width: 160.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80.0),
                                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 3.0),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.4),
                                          Theme.of(context).primaryColor.withOpacity(0.5),
                                          Theme.of(context).primaryColor.withOpacity(0.1),
                                          Colors.white.withOpacity(0.4)
                                        ])
                                  ),
                                  child: Center(
                                    child: Stack(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text( '$time',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 0.30,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 40.0
                                              ),
                                            ),
                                            Text('${objTime.time.toString().substring(5)} ',
                                              style: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),
                                                  letterSpacing: 0.30,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20.0
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.0,),
                                        Positioned(
                                          top: 31.0,
                                          left: 25.0,
                                          child: Text('${objTime.date.toString().substring(5)} ',
                                            style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                letterSpacing: 0.30,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) ,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 128.0,
                    padding: EdgeInsets.only(left: 7.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: _buildCards(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: listOfPlaces.getDifferentPlaces(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return RefreshIndicator(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    onRefresh: ()=>listOfPlaces.getDifferentPlaces(),
                    child: ListView.builder(
                      itemCount: (listOfPlaces.places.length/5) .floor(),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          var placeO = listOfPlaces.getByPosition(index);
                          var placeName = placeO.name.isEmpty ?
                                            placeO.region.toUpperCase() :
                                            placeO.name.toUpperCase();
                          return Padding(
                            padding:EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.00),
                            child: Container(
                              height: 70.0,
                              padding: EdgeInsets.only(top:4.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: -2.0,
                                    left: 2.0,
                                    child: Icon(watchlist.places.contains(placeO)? Icons.star: Icons.star_border,
                                      color: Colors.orangeAccent.withOpacity(0.9),
                                      size: 14,),
                                  ),
                                  Container(
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
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 10.0, top: 4.0),
                                        child: Text('$placeName',
                                          style: TextStyle(
                                              color: Colors.grey[700].withOpacity(0.9),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0
                                          ),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(left: 10.0, top: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 15.0,
                                              color: Colors.grey[600].withOpacity(0.6),
                                            ),
                                            SizedBox(width: 1.0,),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10.0, top: 4.0),
                                              child: Text('${placeO.region}',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.0
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      selected: watchlist.places.contains(placeO),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 19.0,
                                        color: Colors.grey[700].withOpacity(0.4),
                                      ),
                                      onTap: ()  async{
                                        var url =placeO.timezone;
                                        Time _time = new Time(url: url, location: placeName);
                                        await _time.initializeTime();
                                        setState(() {
                                          objTime = _time;
                                        });
                                        },
                                      onLongPress: (){
                                        setState(() {
                                          watchlist.places.contains(placeO) ? ()=>null : watchlist.add(placeO);
                                          scaffoldKey.currentState.showSnackBar(_buildSnack('Added to Watchlist',));
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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
                      height: 10.0,
                      width: MediaQuery.of(context).size.width,
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                    ),
                  );
              }
            ),
          )
        ],
      ),
    );
  }


  SnackBar  _buildSnack(String message) {
    return  SnackBar(content: Container(
      width: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Padding(
        padding:  EdgeInsets.only(left:100.0),
        child: Text(message,
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

  Widget _buildCards(){
    return Padding(
      padding: EdgeInsets.only(left:5.0,right: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: AssetImage('assets/images.jfif'),
              fit: BoxFit.cover
            ),
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.5),
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Colors.white.withOpacity(0.2)
                ]
            )
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5)
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom:1.0,
                child: Container(
                  height: 40.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(image: AssetImage('assets/stock.jpg'), fit: BoxFit.cover)
                  ),
                ),
              ),
              Positioned(
                top:1.0,
                right: 1.0,
                child: Container(
                  height: 35.0,
                  width: 35.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.3)
                        ]
                      )
                  ),
                  child:BoxedIcon(
                    widget.time.isDaytime ? WeatherIcons.sunrise:
                    (false)?WeatherIcons.sunset : WeatherIcons.moon_alt_waning_gibbous_6,
                    color: widget.time.isDaytime ? Colors.orangeAccent.withOpacity(0.5):
                    Colors.grey.withOpacity(0.5),
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
