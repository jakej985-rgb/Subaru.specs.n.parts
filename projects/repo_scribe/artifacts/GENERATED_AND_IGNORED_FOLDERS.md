# Generated & Ignored Folders 🏗️

This document explains the standard folders in this repository that are **ignored by Git** and **generated automatically** by tools.

> **Note:** These folders may not exist if you have just cloned the repo. They are created when you run `flutter pub get`, `flutter run`, or build commands.

## 1. `build/`
*   **Status:** **Ignored** (`.gitignore`)
*   **Created By:** `flutter run`, `flutter build`, `dart run build_runner`
*   **Contents:**
    *   `app/`: Compiled Android/iOS application binaries.
    *   `web/`: Compiled Web assets (if web enabled).
    *   `ios/`, `linux/`, `windows/`: Platform-specific build artifacts.
*   **Action:** Safe to delete (`flutter clean`).

## 2. `.dart_tool/`
*   **Status:** **Ignored** (`.gitignore`)
*   **Created By:** `flutter pub get`, `dart run build_runner`
*   **Contents:**
    *   `package_config.json`: Maps package names to file paths (critical for imports).
    *   `build/`: Cache for code generation (Drift, Riverpod, Freezed).
*   **Action:** Safe to delete. Re-generate with `flutter pub get`.

## 3. `.idea/`
*   **Status:** **Ignored** (`.gitignore`)
*   **Created By:** Android Studio / IntelliJ IDEA
*   **Contents:**
    *   `workspace.xml`: User-specific workspace settings.
    *   `libraries/`: Library configuration.
*   **Action:** Safe to delete, but you lose local IDE preferences.

## 4. `android/.gradle/`
*   **Status:** **Ignored** (`.gitignore`)
*   **Created By:** Gradle (during Android build)
*   **Contents:**
    *   Binary caches and dependency jars for Android build system.
*   **Action:** Safe to delete. Will re-download on next build.

## 5. `ios/Pods/` (If applicable)
*   **Status:** **Ignored** (`.gitignore`)
*   **Created By:** `pod install` (runs automatically with `flutter run`)
*   **Contents:**
    *   Source code for iOS dependencies (CocoaPods).
*   **Action:** Safe to delete. Re-generate with `cd ios && pod install`.
