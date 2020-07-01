import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:osappw/services/time.dart';


class PlaceNotifier extends ChangeNotifier {
  /// Internal, private state of the watchList.
  /// The current Weather. Used to construct items from numeric ids.
  /// The private field backing [watchlist].
  Places _place;
  /// Internal, private state of the watchlist. Stores the ids of each item.
  final List<int> _placeIds = [];

  Places get watchlist => _place;

  set watchlist(Places newPlace) {
    assert(newPlace != null);
    assert(_placeIds.every((id) => newPlace.getById(id) != null),
    'The watchlist $newPlace does not have one of $_placeIds in it.');
    _place = newPlace;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }
  /// An unmodifiable view of the items in the watchList.
//  UnmodifiableListView<Places> get places => UnmodifiableListView(_places);
  List<Places> get places => _placeIds.map((id) => _place.getById(id)).toList();

  /// The current total time zones.
  int get totalPlaceCount =>
      places.fold(0, (total, current) => total + 1);

  /// Adds [places] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Places place) {
    _placeIds.add(place.id);
    print(place.id);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removePlace(Places place) {
    _placeIds.remove(place.id);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _placeIds.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}