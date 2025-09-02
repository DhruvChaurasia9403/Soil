# ReadSoil – Soil Health Monitoring App

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Setup Instructions](#setup-instructions)
- [Data Model](#data-model)
- [Assumptions](#assumptions)
- [Dependencies](#dependencies)
- [APK Build & Installation](#apk-build--installation)
- [Notes](#notes)
- [License](#license)

---

## Project Overview
ReadSoil is a Flutter-based Android app that connects to a Bluetooth soil sensor device to retrieve temperature and moisture readings. It stores readings in Firebase Firestore and provides a clean, responsive UI for viewing current and historical data. Users without a Bluetooth device can toggle to view mock data for testing.

---

## Features

### Bluetooth Device Communication 📡
- Scan and connect to a generic Bluetooth device emitting soil temperature (°C) and moisture (%) readings.
- Fetch the latest values from the connected sensor.
- Toggle between real sensor data and mock data if a Bluetooth device is unavailable.

### Firebase Integration 🔥
- Secure user authentication using Firebase Authentication with email/password login and signup.
- Readings are stored in a Firestore database with a timestamp, temperature, and moisture.

### App UI 📱
- A Home Screen provides a clear overview with buttons to "Test" (fetch a new reading) and "Reports" (view the latest reading).
- A History Screen displays past readings as a chronological list or a dynamic line chart.
- Fully responsive design with light and dark mode themes.

### Good to Have ✅
- Graphical charts using `fl_chart` for real-time visualization of soil health trends.
- Real-time synchronization of data updates with Firebase Firestore.
- Offline caching of the last readings for display when the device is not connected to the internet.

---

## Screenshots

### Light Mode
<!-- Add your light mode screenshots here -->
<!-- ![Home Screen](screenshots/light_mode_home.png) -->
<!-- ![History List](screenshots/light_mode_history_list.png) -->
<!-- ![History Chart](screenshots/light_mode_history_chart.png) -->
<!-- ![Login Screen](screenshots/light_mode_login.png) -->
<!-- ![Signup Screen](screenshots/light_mode_signup.png) -->

*Screenshots will be added once available*

### Dark Mode
<!-- Add your dark mode screenshots here -->
<!-- ![Home Screen](screenshots/dark_mode_home.png) -->
<!-- ![History List](screenshots/dark_mode_history_list.png) -->
<!-- ![History Chart](screenshots/dark_mode_history_chart.png) -->
<!-- ![Login Screen](screenshots/dark_mode_login.png) -->
<!-- ![Signup Screen](screenshots/dark_mode_signup.png) -->

*Screenshots will be added once available*

---

## Setup Instructions

### Clone the Repository
```bash
git clone <your-github-repo-link>
cd readsoil
```

### Install Flutter Dependencies
```bash
flutter pub get
```

### Configure Firebase
- Create a Firebase project in the Firebase Console.
- Enable Firestore and Firebase Authentication (email/password provider).
- Download the `google-services.json` file and place it in the `android/app/` directory.
- Ensure your Firestore security rules allow read/write access for authenticated users.

### Run the App
```bash
flutter run
```

---

## Data Model

Soil readings are stored in Firestore using the following data model:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SoilReading {
  final DateTime timestamp;
  final double temperature;
  final double moisture;

  SoilReading({
    required this.timestamp,
    required this.temperature,
    required this.moisture,
  });

  factory SoilReading.fromMap(Map<String, dynamic> map) {
    return SoilReading(
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      temperature: map['temperature']?.toDouble() ?? 0.0,
      moisture: map['moisture']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'temperature': temperature,
      'moisture': moisture,
    };
  }
}
```

---

## Assumptions
- The Bluetooth sensor device is a generic BLE device that transmits mockable temperature and moisture data.
- The app supports toggling between real sensor data and mock data when the hardware is not available.
- Firebase Auth is used exclusively for email/password authentication.
- Offline caching is a "good to have" feature, with last-known readings stored locally for display.

---

## Dependencies
- `flutter_bloc` & `bloc`: State management.
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Firebase integrations.
- `flutter_blue_plus`: Bluetooth Low Energy (BLE) communication.
- `fl_chart`: Interactive charts.
- `pdf` & `printing`: Optional PDF report generation.
- `flutter_animate`, `google_fonts`, `intl`, `iconsax`, `flutter_screenutil`: UI/UX enhancements.

---

## APK Build & Installation

### Build Command
```bash
flutter build apk --release
```

### Minimum Android Version
- 6.0 (API 23)

### Installation
- Download ReadSoil APK: [Available Soon]
- Or build from source using the command above

---

## Notes
- Ensure Bluetooth is enabled on your device for real readings.
- Supports both light and dark themes.
- Release APK is signed and optimized for production.

---

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

---

## How to Add Screenshots

1. Create a `screenshots` folder in your project root directory
2. Take screenshots of your app in both light and dark modes
3. Save them with descriptive names like:
   - `light_mode_home.png`
   - `light_mode_history_list.png` 
   - `light_mode_history_chart.png`
   - `light_mode_login.png`
   - `light_mode_signup.png`
   - `dark_mode_home.png`
   - `dark_mode_history_list.png`
   - `dark_mode_history_chart.png`
   - `dark_mode_login.png`
   - `dark_mode_signup.png`
4. Uncomment the screenshot lines in the README and replace the paths with your actual image paths
5. Commit and push your changes to GitHub

The screenshots will then display properly in your README on GitHub.