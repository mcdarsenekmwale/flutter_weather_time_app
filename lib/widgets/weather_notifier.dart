import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:osappw/services/config.dart';
import 'package:osappw/services/weather.dart';


class WeatherNotifier extends ChangeNotifier {
  /// Internal, private state of the watch list.
  final List<Weather> _weathers = [];
  /// The private field backing [watchlist].
  Weather _weather;
  Config config = new Config();
  Map _favourite = new Map();
  List<bool> _settings =  new List<bool>();

  /// Internal, private state of the watchlist. Stores the ids of each item.
  final List<int> _weatherIds = [];

  /// The current Weather. Used to construct items from numeric ids.
  Weather get watchlist => _weather;

  set watchlist(Weather newWeather) {
    assert(newWeather != null);
    assert(_weatherIds.every((id) => newWeather.getById(id) != null),
    'The watchlist $newWeather does not have one of $_weatherIds in it.');
    _weather = newWeather;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }
  /// An unmodifiable view of the items in the watch list.
  UnmodifiableListView<Weather> get weathers => UnmodifiableListView(_weathers);

  /// List of items in the .
//  List<Weather> get weathers => _weatherIds.map((id) => _weather.getById(id)).toList();

  /// The current total watch weathers .
  int get totalWatchWeathers =>
      _weathers.fold(0, (total, current) => total + 1);

  /// Adds [Weather] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Weather weather) {
    _weathers.add(weather);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all weather from the watchList.
  void removeAll() {
    _weathers.clear();
    // This call tells the widgets

    notifyListeners();
  }

  void removePlace(Weather weather) {
    _weathers.remove(weather);

    notifyListeners();
  }

  Map get favourite => _favourite;
  List<bool> get settings => _settings;
  Config get defaultConfig => config;

  set defaultConfig(Config newConfig)  {
    assert(newConfig != null);

    // Notify listeners, in case the new provides information
    // might have changed.
    notifyListeners();
  }

  Future<void> getSettings() async{
    await config.loadSettings();
    _favourite = config.favourite;
    _settings =  config.settings;

    notifyListeners();
  }
}