# ReadSoil – Soil Health Monitoring App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.32.5-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%2C%20Auth-yellowgreen.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#license)

---

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

ReadSoil is a Flutter-based Android app that connects to a Bluetooth soil sensor device to retrieve temperature and moisture readings. It stores readings in Firebase Firestore and provides a clean, responsive UI for viewing current and historical data. Users without a Bluetooth device can toggle to view mock data.

---

## Features

- **Bluetooth Device Communication**
    - Scan and connect to a generic Bluetooth device emitting soil temperature and moisture readings.
    - Fetch latest temperature (°C) and moisture (%) values.
    - Toggle to mock data if a Bluetooth device is unavailable.

- **Firebase Integration**
    - Firebase Authentication with email/password login/signup.
    - Firestore database stores readings with timestamp, temperature, and moisture.

- **App UI**
    - Home Screen with buttons: “Test” (fetch new reading) and “Reports” (view latest reading).
    - History Screen displays past readings as a list or line chart.
    - Fully responsive with light and dark mode themes (10 images for each mode).

- **Good to Have**
    - Graphical charts using `fl_chart` for visualization of moisture and temperature trends.
    - Real-time sync updates with Firebase.
    - Offline caching of last readings for display when offline.

---

## Screenshots

_Add here 10 screenshots for Light mode and 10 for Dark mode showcasing the responsive design._

---

## Setup Instructions

1. **Clone the Repository**

git clone <your-github-repo-link>
cd readsoil

text

2. **Install Flutter Dependencies**

flutter pub get

text

3. **Configure Firebase**

- Create a Firebase project.
- Enable Firestore and Firebase Authentication (email/password).
- Download `google-services.json` and place it under `android/app/`.
- Ensure Firestore security rules allow read/write for authenticated users.

4. **Run the App**

flutter run

text

---

## Data Model

Soil readings are stored in Firestore with the following structure:

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

text

---

## Assumptions

- The Bluetooth device is generic and emits mockable temperature and moisture readings.
- Users can toggle between real Bluetooth readings and mock data if hardware is not available.
- Firebase Auth is used only for email/password authentication.
- Offline caching is optional; last readings are stored locally for display.

---

## Dependencies

- `flutter_bloc` & `bloc` - State management
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase integration
- `flutter_blue_plus` - Bluetooth communication
- `fl_chart` - Charts and graphs
- `pdf` & `printing` - PDF generation (optional)
- `flutter_animate`, `google_fonts`, `intl`, `iconsax`, `flutter_screenutil` - UI/UX enhancements

---

## APK Build & Installation

- **Build Command:**

flutter build apk --release

text

- **Minimum Android Version:** 6.0 (API 23)

- **Installation:**

Replace `INSERT_LINK_HERE` with the actual download URL for the release APK below:

[Download ReadSoil APK](INSERT_LINK_HERE)

---

## Notes

- Ensure Bluetooth is enabled on the device for real readings.
- The app supports both light and dark themes with 10 images for each.
- The app UI is fully responsive for different screen sizes.
- The release APK is signed and optimized for production.

---

## License

MIT License. See the LICENSE file for more details.

---

*This ReadMe was generated for the ReadSoil soil health monitoring project.*  