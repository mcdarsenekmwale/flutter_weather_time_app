import 'dart:convert';

class Country {
  final double lat;
  final double lng;
  final int id;
  final int population;
  final String city;
  String city_ascii;
  final String name;
  final String iso3;
  final String iso2;

  Country({this.population, this.id, this.name, this.lng, this.lat, this.city, this.iso3, this.iso2});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      population: json['population'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      iso2: json['iso2'] as String,
      iso3: json['iso3'] as String,
    );
  }

  List<Country> parseCountries(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Country>((json) => Country.fromJson(json)).toList();
  }
}