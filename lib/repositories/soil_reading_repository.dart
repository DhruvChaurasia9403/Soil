import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/soil_reading.dart';
import '../services/bluetooth_services.dart';

class SoilReadingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BluetoothService _bluetoothService = BluetoothService();

  CollectionReference _getReadingsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('soilReadings');
  }

  Future<SoilReading> fetchLatestReading({
    required String userId,
    required bool useRealData,
  }) async {
    final readingData =
    await _bluetoothService.getSoilData(useRealData: useRealData);

    final reading = SoilReading(
      timestamp: DateTime.now(),
      temperature: readingData['temperature'] ?? 0.0,
      moisture: readingData['moisture'] ?? 0.0,
    );

    await _getReadingsCollection(userId).add(reading.toMap());
    return reading;
  }

  Future<Map<String, dynamic>> loadMoreReadings({
    required String userId,
    required int limit,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query =
    _getReadingsCollection(userId).orderBy('timestamp', descending: true);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.limit(limit).get();
    final readings = querySnapshot.docs
        .map((doc) =>
        SoilReading.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    final newLastDocument =
    querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    return {
      'readings': readings,
      'lastDoc': newLastDocument,
    };
  }

  Stream<List<SoilReading>> readingStream({required String userId}) {
    return _getReadingsCollection(userId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        SoilReading.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
