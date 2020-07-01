import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

// ignore: must_be_immutable
class WeatherIconWidget extends StatelessWidget {
    final int code;
    final double size;
    Color color;
  WeatherIconWidget({this.code, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return getWeatherIcon(code);
  }

  Widget getWeatherIcon(int code) {
    IconData wIcon = WeatherIcons.day_cloudy_gusts;

    if (code >= 200 && code <= 299) {
      wIcon = WeatherIcons.day_thunderstorm;
    } else if (code >= 300 && code <= 399) {
      wIcon = WeatherIcons.showers;
    } else if (code >= 500 && code <= 599) {
      wIcon = WeatherIcons.rain;
//      color = Colors.lightBlueAccent[100].withOpacity(0.9);
    } else if (code >= 600 && code <= 699) {
      wIcon = WeatherIcons.snow;
    } else if (code >= 700 && code <= 799) {
      wIcon = getSmokeIcon(code);
    } else if (code == 800) {
      wIcon = WeatherIcons.day_sunny;
    } else if (code >= 801) {
      wIcon = getCloudsIcon(code);
      color = Colors.grey.shade300;

    }

    return BoxedIcon(wIcon, size: size, color: color,);
  }

  IconData getSmokeIcon(int code){
    switch(code){
      case 711:
        return WeatherIcons.smoke;
        break;
      case 721:
        return WeatherIcons.day_haze;
        break;
      case 731:
        return WeatherIcons.dust;
        break;
      case 741:
        return WeatherIcons.fog;
        break;
      case 751:
        return WeatherIcons.sandstorm;
        break;
      case 761:
        return WeatherIcons.dust;
        break;
      case 762:
        return WeatherIcons.volcano;
        break;
      case 781:
        return WeatherIcons.tornado;
        break;
      default :
        return WeatherIcons.smog;
        break;
    }
  }

  IconData getCloudsIcon(int code){
    switch(code){
      case 801:
        return WeatherIcons.day_sunny_overcast;
        break;
      case 802:
        return WeatherIcons.day_cloudy;
        break;
      case 803:
        return WeatherIcons.cloud;
        break;
      default :
        return WeatherIcons.day_cloudy_high;
        break;
    }
  }
}
