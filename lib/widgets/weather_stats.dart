import 'package:flutter/material.dart';
import 'package:osappw/services/weather.dart';
import 'package:osappw/widgets/weather_icon.dart';
import 'package:osappw/services/config.dart';
import 'line_painter.dart';


class WeatherStatsWidget extends StatelessWidget {
  final List<Weather> weather;
  final Config config;
  final List<bool> settings;
  WeatherStatsWidget({this.weather, this.config, this.settings}) ;


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.only(left:8.0, right: 20.0),
      child: Container(
        height: 220.0,
        width: MediaQuery.of(context).size.width-15.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
              colors:[
                Colors.white,
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.02),
                Colors.white.withOpacity(0.1)
              ])
        ),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,  index){
              return builderContainers(weather.elementAt(index), index, context);
            },
          itemCount: weather.length,
            ),
      ),
    );
  }
  
  Widget builderContainers(Weather data,index, BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left:3.0),
      child: Container(
        width: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.1),
//              Colors.white.withOpacity(0.05)
            ]
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: (100.0-(data.temperature.tempCurrent *2).toDouble()),
              left: 21.0,
              child: Column(
                children: <Widget>[
                  Text('${(config.setTemperatureUnits(data.temperature.tempCurrent, settings) ).floor()}\u1d52',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                ],
              ),
            ),
            CustomPaint(
              size: Size.infinite,
              painter: 0 < index && index < weather.length ?
              LinesPainter(
                  Offset(-30.0, (104-(weather.elementAt(index-1).temperature.tempCurrent-2)).toDouble()),
                  Offset(22.0*1.5, (104-(data.temperature.tempCurrent -2)).toDouble()),
                  Theme.of(context).primaryColor.withOpacity(0.5)
              )
                  : null
            ),
            Positioned(
              bottom: 50.0,
                left: 13.0,
                child: Column(
                  children: <Widget>[
                    WeatherIconWidget(
                      code: data.weatherData.weatherId,
                      color: Colors.orangeAccent.withOpacity(1),
                      size: 24,
                    ),
                    Text('${data.weatherData.weatherMain}',
                      style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).primaryColor
                      ),)
                  ],
                )
            ),
            Positioned(
              bottom: 11.0,
              left: 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(bottom: 5.0),
                    child: Text(
                        '${config.setVelocityUnits(data.wind.windSpeed,!settings[1] )}',
                        style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        letterSpacing: 1.0,
                        color: Colors.grey[600].withOpacity(0.7)
                    )),
                  ),
                  Container(
                    child: Text('${data.dateShortFormatted}', style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 1.0,
                        color: Theme.of(context).primaryColor
                    )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
