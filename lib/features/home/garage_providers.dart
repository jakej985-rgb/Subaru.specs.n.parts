import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/data/db/app_db.dart';

// --- Keys & Constants ---
const String kPrefsRecentVehiclesKey = 'prefs_recent_vehicles_v1';
const String kPrefsFavoriteVehiclesKey = 'prefs_favorite_vehicles_v1';
const int kMaxRecents = 5;
const int kMaxFavorites = 10;

// --- Helper Functions ---
String _vehicleToId(Vehicle v) {
  // Format: year|make|model|trim
  return '${v.year}|${v.make}|${v.model}|${v.trim ?? ""}';
}

Vehicle? _idToVehicle(String id) {
  try {
    final parts = id.split('|');
    if (parts.length < 4) return null;
    return Vehicle(
      id: id,
      year: int.parse(parts[0]),
      make: parts[1],
      model: parts[2],
      trim: parts[3].isEmpty ? null : parts[3],
      updatedAt: DateTime.now(),
      engineCode: null,
    );
  } catch (e) {
    return null;
  }
}

// --- Providers ---

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider not overridden');
});

// Recent Vehicles Notifier
class RecentVehiclesNotifier extends Notifier<List<Vehicle>> {
  late SharedPreferences _prefs;

  @override
  List<Vehicle> build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    _load();
    return state;
  }

  void _load() {
    final jsonString = _prefs.getString(kPrefsRecentVehiclesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        state = list
            .map((e) => _idToVehicle(e as String))
            .whereType<Vehicle>()
            .toList();
      } catch (_) {
        state = [];
      }
    } else {
      state = [];
    }
  }

  Future<void> add(Vehicle vehicle) async {
    final existingIndex = state.indexWhere(
      (v) => _vehicleToId(v) == _vehicleToId(vehicle),
    );
    var newState = List<Vehicle>.from(state);

    if (existingIndex != -1) {
      newState.removeAt(existingIndex);
    }

    newState.insert(0, vehicle);

    if (newState.length > kMaxRecents) {
      newState = newState.sublist(0, kMaxRecents);
    }

    state = newState;
    await _save();
  }

  Future<void> clear() async {
    state = [];
    await _save();
  }

  Future<void> _save() async {
    final ids = state.map(_vehicleToId).toList();
    await _prefs.setString(kPrefsRecentVehiclesKey, jsonEncode(ids));
  }
}

final recentVehiclesProvider =
    NotifierProvider<RecentVehiclesNotifier, List<Vehicle>>(
      RecentVehiclesNotifier.new,
    );

// Favorite Vehicles Notifier
class FavoriteVehiclesNotifier extends Notifier<List<Vehicle>> {
  late SharedPreferences _prefs;

  @override
  List<Vehicle> build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    _load();
    return state;
  }

  void _load() {
    final jsonString = _prefs.getString(kPrefsFavoriteVehiclesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        state = list
            .map((e) => _idToVehicle(e as String))
            .whereType<Vehicle>()
            .toList();
      } catch (_) {
        state = [];
      }
    } else {
      state = [];
    }
  }

  bool isFavorite(Vehicle vehicle) {
    return state.any((v) => _vehicleToId(v) == _vehicleToId(vehicle));
  }

  Future<void> toggle(Vehicle vehicle) async {
    final id = _vehicleToId(vehicle);
    final isFav = isFavorite(vehicle);

    List<Vehicle> newState = List.from(state);
    if (isFav) {
      newState.removeWhere((v) => _vehicleToId(v) == id);
    } else {
      if (newState.length >= kMaxFavorites) {
        newState.removeLast();
      }
      newState.insert(0, vehicle);
    }

    state = newState;
    await _save();
  }

  Future<void> clear() async {
    state = [];
    await _save();
  }

  Future<void> _save() async {
    final ids = state.map(_vehicleToId).toList();
    await _prefs.setString(kPrefsFavoriteVehiclesKey, jsonEncode(ids));
  }
}

final favoriteVehiclesProvider =
    NotifierProvider<FavoriteVehiclesNotifier, List<Vehicle>>(
      FavoriteVehiclesNotifier.new,
    );
