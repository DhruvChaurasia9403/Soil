import 'package:cloud_firestore/cloud_firestore.dart'; // Added this import

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