# Subaru Specs & Parts

A Flutter app for offline lookup of Subaru vehicle specifications and parts.

## Features

- **Offline First**: All data is stored locally in SQLite.
- **Vehicle Browser**: Browse by Year, Make, Model, and Trim.
- **Part Lookup**: Search parts by name or OEM number.
- **Specs**: Quick reference for torque specs, fluid capacities, and bulb types.

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: go_router
- **Database**: Drift (SQLite)

## Getting Started

1. **Install Flutter**: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. **Clone the repo**:
   ```bash
   git clone https://github.com/your-org/subaru-specs-parts.git
   cd subaru-specs-parts
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run Code Generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Run the App**:
   ```bash
   flutter run
   ```

## Testing

Run unit and widget tests:

```bash
flutter test
```
