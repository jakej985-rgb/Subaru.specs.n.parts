import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';

class ComparisonState {
  final List<Vehicle> vehicles;

  ComparisonState({this.vehicles = const []});

  bool get isFull => vehicles.length >= 2;
  bool contains(String vehicleId) => vehicles.any((v) => v.id == vehicleId);

  ComparisonState copyWith({List<Vehicle>? vehicles}) {
    return ComparisonState(vehicles: vehicles ?? this.vehicles);
  }
}

final comparisonProvider =
    NotifierProvider<ComparisonNotifier, ComparisonState>(
  ComparisonNotifier.new,
);

class ComparisonNotifier extends Notifier<ComparisonState> {
  @override
  ComparisonState build() {
    return ComparisonState();
  }

  void add(Vehicle vehicle) {
    if (state.contains(vehicle.id)) return;
    if (state.isFull) {
      // Replace the last one or just ignore?
      // Let's replace the second one if full, or keep it simple and just do 2.
      state = state.copyWith(vehicles: [state.vehicles.first, vehicle]);
    } else {
      state = state.copyWith(vehicles: [...state.vehicles, vehicle]);
    }
  }

  void remove(String vehicleId) {
    state = state.copyWith(
      vehicles: state.vehicles.where((v) => v.id != vehicleId).toList(),
    );
  }

  void clear() {
    state = ComparisonState();
  }
}
