import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';


class Weather{

    dynamic lon;
    dynamic lat;
    int id;
    String timezone;
    Temperature temperature;
    Wind wind;
    WeatherData weatherData;
    String country;
    String city;
    int visibility;
    int clouds;
    int sunrise;
    int sunset;
    int cityId;
    int cod;
    int countrySize;
    String dateShortFormatted;
    String dateFullFormatted;
    String day;
    List<Weather> weatherForecast;
    List<Weather> weatherHourly ;
    List<Weather> countryWeathers;
    
    Weather({this.id, this.city, this.cityId, this.country, this.clouds, this.cod, this.lat, this.lon, this.temperature, this.visibility,this.weatherData,
       this.wind, this.dateShortFormatted, this.dateFullFormatted,this.day, this.timezone,this.weatherForecast,this.weatherHourly
    });

    final String openWeatherMapToken = "";
  Future<void> initialize() async{
      try{
        Response response = await get('http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$openWeatherMapToken');
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          Map data  = jsonDecode(response.body);
          //set up time
          return manipulateData(data);
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load weather');
        }
      }
      catch(e){
        print(e);
      }
    }

    Weather manipulateData(Map data){
      //get properties
      city = data['name'];
      cityId = data['id'];
      country = data['sys']['country'];
      cod  =  data['cod'];
      lon = data['coord']['lon'];
      lat = data['coord']['lat'];
      sunrise = data['sys']['sunrise'];
      sunset = data['sys']['sunset'];
      clouds = data['clouds']['all'];
      visibility = data['visibility'];
      wind = Wind(windSpeed:data['wind']['speed'], windDeg: data['wind']['deg']);
      temperature = Temperature(pressure: data['main']['pressure'], humidity: data['main']['humidity'], tempCurrent: data['main']['temp'], tempMax: data['main']['temp_max'],
          tempMin: data['main']['temp_min']);
      weatherData = WeatherData(weatherMain: data['weather'][0]['main'], weatherDescription: data['weather'][0]['description'], weatherIcon: data['weather'][0]['icon'], weatherId: data['weather'][0]['id']);
      dateShortFormatted = setupDateFormatted(data['dt']);

//          getDayMode(sunrise, sunset);
      return Weather(cityId: cityId, city: city, clouds: clouds, cod: cod, visibility: visibility, lon: lon, lat: lat, country: country,
          weatherData: weatherData, temperature: temperature, wind: wind, dateShortFormatted: dateShortFormatted, dateFullFormatted: dateFullFormatted,
          day: day, weatherForecast:weatherForecast, );
    }

    String setupDateFormatted(int date) {
      DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: false);
      day = new DateFormat.EEEE().format(dateTime);
      dateFullFormatted =  new DateFormat.yMd().format(dateTime);
      return new DateFormat.MMMEd().format(dateTime);
    }

    String setupDateTimeFormatted(int date) {
      DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: false);
      return new DateFormat.Hm().format(dateTime);
    }

    static int getDayMode(int sunrise, int sunset) {
       sunrise = sunrise * 1000;
       sunset = sunset * 1000;
      return getDayModeFromSunriseSunset(sunrise, sunset);
    }

    static int getDayModeFromSunriseSunset(int sunrise, int sunset) {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now >= sunrise && now <= sunset) {
        return 0;
      } else if (now >= sunrise) {
        return 1;
      } else {
        return -1;
      }
    }

    Future<void> getCityWeather(lat, lon) async{
      try{
        Response response = await get('https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$openWeatherMapToken');
        Map data  = jsonDecode(response.body);
        getHourlyData(data);
        List<Weather> weathers = [];
        data['daily'].forEach((weather)=>weathers.add(manipulateForecastData(weather)));
        weatherForecast = weathers;
        return weathers;
      }
      catch(e){
        throw Exception(e);
      }
    }

    Weather manipulateForecastData(Map data){
      //get properties
      clouds = data['clouds'];
      wind = Wind(windSpeed:data['wind_speed'], windDeg: data['wind_deg']);
      temperature = Temperature(pressure: data['pressure'], humidity: data['humidity'], tempCurrent: data['temp']['day'], tempMax: data['temp']['max'],
          tempMin: data['temp']['min']);
      weatherData = WeatherData(weatherMain: data['weather'][0]['main'], weatherDescription: data['weather'][0]['description'], weatherIcon: data['weather'][0]['icon'], weatherId: data['weather'][0]['id']);
      dateShortFormatted = setupDateFormatted(data['dt']);

//          getDayMode(sunrise, sunset);
      return Weather(clouds: clouds, weatherData: weatherData, temperature: temperature, wind: wind,
              dateShortFormatted: dateShortFormatted, dateFullFormatted: dateFullFormatted,
              day: day, weatherForecast:weatherForecast,  );
    }

    void getHourlyData(Map data){
        List<Weather> tempData = [];
       data['hourly'].forEach((entry){
         tempData.add(Weather(
            timezone: data['timezone'],
            temperature: Temperature(tempCurrent: entry['temp'], pressure: entry['humidity']),
            wind: Wind(windDeg: entry['wind_deg'], windSpeed: entry['wind_speed']),
            weatherData: WeatherData(weatherId: entry['weather'][0]['id'], weatherMain:entry['weather'][0]['main'],weatherDescription: entry['weather'][0]['description'] ),
            dateShortFormatted: setupDateTimeFormatted(entry['dt'], )
          )
        );
      });
       weatherHourly = tempData;
    }

    Future<void> getAllWeather(int number) async{
      try{
         List value =  await parseJsonFromAssets("assets/data/world.json");
         List<Weather> tempHash = [];
         for(int i = 0; i<number && number<value.length; i++){
           Weather temp = await getCountryWeathers(value[i]);
           tempHash.add(temp);
         }
         countryWeathers =  tempHash;
         countrySize = value.length;
        return countryWeathers;
      }
      catch(e){
        throw Exception(e);
      }
    }

    // ignore: missing_return
    Future<Weather> getCountryWeathers(Map data) async {
      try {
        Response response = await get('http://api.openweathermap.org/data/2.5/weather?lat=${data['lat']}&lon=${data['lng']}&units=metric&appid=$openWeatherMapToken');
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          Map newData = jsonDecode(response.body);
          return new Weather(
              city: data['city'],
              country: data['iso3'],
              id: data['id'],
              lat: data['lat'],
              lon: data['lng'],
              temperature: Temperature(pressure: newData['main']['pressure'], humidity: newData['main']['humidity'], tempCurrent: newData['main']['temp'], tempMax: newData['main']['temp_max'],
                  tempMin: newData['main']['temp_min']) ,
              weatherData : WeatherData(weatherMain: newData['weather'][0]['main'], weatherDescription: newData['weather'][0]['description'], weatherIcon: newData['weather'][0]['icon'], weatherId: newData['weather'][0]['id']),
              cod: newData['cod'],
              dateShortFormatted : setupDateFormatted(newData['dt'])
          );
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load weather');
        }
      }
      catch(e) {
        throw Exception(e);
      }
    }

    Future<List> parseJsonFromAssets(String assetsPath) async {
      return rootBundle.loadString(assetsPath)
          .then((jsonStr) => jsonDecode(jsonStr));
    }

    Future<void> getWeather() async{
      try{
        Response response = await get('http://api.openweathermap.org/data/2.5/weather?city=$city&units=metric&appid=$openWeatherMapToken');
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          Map data  = jsonDecode(response.body);
          return manipulateData(data);
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load weather');
        }
      }
      catch(e){
        throw Exception(e);
      }
    }

    /// In this sample, the watchlist is infinite, looping over [_city].
    Weather getById(int id) => Weather( cityId: id, city: city, lon: lon, lat: lat, country: country);

    /// Get weather by its position in the watchlist.
    /// // In this simplified case, an weather's position in the weather
    //      // is also its id.
    Weather getByPosition(int position)=> getById(position);

    @override
    int get hashCode => id;

    @override
    bool operator ==(Object other) => other is Weather && other.id == id;
}

class WeatherData{
  int weatherId;
  String weatherMain;
  String weatherDescription;
  dynamic weatherIcon;

  WeatherData({this.weatherDescription, this.weatherIcon, this.weatherMain,this.weatherId});
  WeatherData getWeatherData(Map data){
    return WeatherData(
        weatherId: data['id'],
        weatherDescription: data['description'],
        weatherIcon: data['icon'],
        weatherMain: data['main']
    );
  }
}

class Temperature{
  dynamic tempCurrent;
  dynamic tempMax;
  dynamic tempMin;
  dynamic feelsLike;
  dynamic pressure;
  dynamic humidity;

  Temperature({this.tempCurrent, this.tempMax, this.tempMin, this.feelsLike, this.pressure, this.humidity});
}

class Wind{
  dynamic windSpeed;
  int windDeg;

  Wind({this.windDeg, this.windSpeed});
}

