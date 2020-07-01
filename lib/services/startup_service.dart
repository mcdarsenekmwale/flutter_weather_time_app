import 'package:location/location.dart';
import 'package:osappw/services/config.dart';
import 'package:osappw/services/time.dart';
import 'package:osappw/services/weather.dart';

class StartUpService{
  Time _time;
  Weather _weather;
  Location _currentLocation = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Map service;
  Config config = new Config();
  List _settings;
  StartUpService();

  Future<void> _enableLocation() async{
    _serviceEnabled = await _currentLocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _currentLocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _currentLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _currentLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> getReadyData() async{

    await config.loadSettings();
    await config.getDefaultLocation();
    _settings = config.settings;
    var defaultLoc = config.favourite;
    if( _settings[2]) {
        _enableLocation();
        _locationData =  await _currentLocation.getLocation();
        if (_locationData != null) {
          final lat = _locationData.latitude;
          final lon = _locationData.longitude;
          _weather = Weather( lat: lat.toString(), lon:lon.toString());
        }
      }
    else if(defaultLoc['lat'] !=null && defaultLoc['lng'] !=null ){
      _weather = Weather( lat:defaultLoc['lat'] , lon:defaultLoc['lng']);
    }
    else
        _weather = Weather( lat: -0.13, lon:51.51);
    await _weather.initialize();
    await _weather.getCityWeather(_weather.lat, _weather.lon);
    _time = Time(url:_weather.weatherHourly[0].timezone, location: _weather.city );
    await _time.initializeTime();
    await config.loadSettings();

    service = {'_weather': _weather, '_time' : _time, '_settings':_settings};
  return service;
  }
}