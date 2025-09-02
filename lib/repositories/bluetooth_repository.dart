
import '../services/bluetooth_services.dart';

class BluetoothRepository {
  final BluetoothService _bluetoothService = BluetoothService();

  Future<Map<String, double>> getSoilData() async {
    // Currently returns mock data simulating Bluetooth device readings
    return await _bluetoothService.getMockSoilData();
  }
}
