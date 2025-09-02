import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;

class BluetoothService {
  Future<Map<String, double>> getSoilData({required bool useRealData}) async {
    if (useRealData) {
      print("BluetoothService: Real data requested.");
      return getRealSoilData();
    } else {
      return getMockSoilData();
    }
  }

  // Mock data for testing
  Future<Map<String, double>> getMockSoilData() async {
    print("Fetching MOCK soil data...");
    await Future.delayed(const Duration(seconds: 1));
    return {
      'temperature': 22.5 + (5 * (DateTime.now().second % 6) / 6),
      'moisture': 40 + (20 * (DateTime.now().second % 6) / 6),
    };
  }

  // Real Bluetooth implementation
  Future<Map<String, double>> getRealSoilData() async {
    print("Attempting to fetch REAL soil data...");

    final state = await fb.FlutterBluePlus.adapterState.first;
    if (state != fb.BluetoothAdapterState.on) {
      throw Exception("Bluetooth is off. Please turn it on.");
    }

    final connectedDevices = fb.FlutterBluePlus.connectedDevices;
    if (connectedDevices.isEmpty) {
      throw Exception(
          "No Bluetooth device connected. Please connect from the Profile screen.");
    }

    final fb.BluetoothDevice device = connectedDevices.first;

    const String serviceUuid = "0000181a-0000-1000-8000-00805f9b34fb";
    const String tempCharUuid = "00002a6e-0000-1000-8000-00805f9b34fb";
    const String moistureCharUuid = "00002a6c-0000-1000-8000-00805f9b34fb";

    try {
      final List<fb.BluetoothService> services =
      await device.discoverServices();
      final targetService =
      services.firstWhere((s) => s.uuid.toString() == serviceUuid);

      final tempChar = targetService.characteristics
          .firstWhere((c) => c.uuid.toString() == tempCharUuid);
      final moistureChar = targetService.characteristics
          .firstWhere((c) => c.uuid.toString() == moistureCharUuid);

      final List<int> tempRaw = await tempChar.read();
      final List<int> moistureRaw = await moistureChar.read();

      return {
        'temperature': _parseTemperature(tempRaw),
        'moisture': _parseMoisture(moistureRaw),
      };
    } catch (e) {
      print("Error fetching real BT data: $e");
      throw Exception(
          "Could not read data from the device. Is it the correct one?");
    }
  }


  double _parseTemperature(List<int> rawData) {
    if (rawData.length < 2) return 0.0;
    int value = (rawData[1] << 8) + rawData[0];
    return value / 100.0;
  }

  double _parseMoisture(List<int> rawData) {
    if (rawData.isEmpty) return 0.0;
    return rawData[0].toDouble();
  }
}
