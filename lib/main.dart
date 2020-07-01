import 'package:flutter/material.dart';
import 'package:osappw/screens/WatchList_Screen.dart';
import 'package:osappw/screens/home_screen.dart';
import 'package:osappw/screens/weather_screen.dart';
import 'package:osappw/services/time.dart';
import 'package:osappw/services/weather.dart';
import 'package:osappw/widgets/place_notifier.dart';
import 'package:osappw/widgets/weather_notifier.dart';
import 'package:provider/provider.dart';
import 'Initialize/startup.dart';

main(){
  runApp(
       MultiProvider(
           providers: [
             // In this sample app, CatalogModel never changes, so a simple Provider
             // is sufficient.
             Provider(create: (context) => Places()),
             Provider(create: (context) => Weather()),
             // WatchList is implemented as a ChangeNotifier, which calls for the use
             // of ChangeNotifierProvider. Moreover, Weather depends
             // on WatchNotifier, so a ProxyProvider is needed.
             ChangeNotifierProxyProvider<Places, PlaceNotifier>(
               create: (context) => PlaceNotifier(),
               update: (context, watchlist, place) {
                 place.watchlist = watchlist;
                 return place;
               },
             ),
             ChangeNotifierProxyProvider<Weather, WeatherNotifier>(
               create: (context) => WeatherNotifier(),
               update: (context, watchlist, weather) {
                 weather.watchlist = watchlist;
                 return weather;
               },
             ),
           ],
         child:
         MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Open Source App',
                theme: ThemeData(
                  primaryColor: Color.fromRGBO(34, 201, 190, 1),
                  accentColor: Color(0xFFD8ECF1),
                  scaffoldBackgroundColor: Color(0xFFF3F5F7)
              ),
                initialRoute: '/',
                routes:{
                  '/': (context) => StartUp(),
                  '/home': (context) => (HomeScreen()),
                  '/weather': (context)=>(WeatherScreen()),
                  '/watchList': (context) => WatchListScreen(),
                },
//              home: HomeScreen(),
              ),
       )
  );
}
