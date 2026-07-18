import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specsnparts/features/home/garage_providers.dart';

// --- Keys & Constants ---
const String kPrefsRecentPartSearchesKey = 'prefs_recent_part_searches_v1';
const int kMaxRecentPartSearches = 10;

// --- Providers ---

class RecentPartSearchesNotifier extends Notifier<List<String>> {
  late SharedPreferences _prefs;

  @override
  List<String> build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    _load();
    return state;
  }

  void _load() {
    final jsonString = _prefs.getString(kPrefsRecentPartSearchesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        state = list.map((e) => e.toString()).toList();
      } catch (_) {
        state = [];
      }
    } else {
      state = [];
    }
  }

  Future<void> add(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    final newState = List<String>.from(state);

    // Remove if exists to bump to top
    newState.removeWhere((q) => q.toLowerCase() == cleanQuery.toLowerCase());

    // Add to front
    newState.insert(0, cleanQuery);

    // Trim
    if (newState.length > kMaxRecentPartSearches) {
      newState.removeRange(kMaxRecentPartSearches, newState.length);
    }

    state = newState;
    await _save();
  }

  Future<void> remove(String query) async {
    final newState = List<String>.from(state);
    newState.remove(query);
    state = newState;
    await _save();
  }

  Future<void> clear() async {
    state = [];
    await _save();
  }

  Future<void> _save() async {
    await _prefs.setString(kPrefsRecentPartSearchesKey, jsonEncode(state));
  }
}

final recentPartSearchesProvider =
    NotifierProvider<RecentPartSearchesNotifier, List<String>>(
  RecentPartSearchesNotifier.new,
);
