import 'package:flutter/material.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart' as bp;
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';


import 'invoice_preview_screen.dart'; // Import next screen

class POSPrintScreen extends StatefulWidget {
  @override
  _POSPrintScreenState createState() => _POSPrintScreenState();
}

class _POSPrintScreenState extends State<POSPrintScreen> {
  // final bp.BluetoothPrintPlus bluetoothPrint = bp.BluetoothPrintPlus;
  bool _connecting = false;
  String? _connectingDeviceId;
  List<fbp.BluetoothDevice> _devices = [];

  fbp.BluetoothDevice? _connectedDevice;


  final String _knownDeviceIdKey = 'last_connected_printer';

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await _requestPermissions();
    await _ensureBluetoothOn();
    await _attemptAutoReconnect();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();
  }

  Future<void> _ensureBluetoothOn() async {
    bool isOn = await fbp.FlutterBluePlus.isOn;
    if (!isOn) {
      try {
        await fbp.FlutterBluePlus.turnOn();
        await Future.delayed(Duration(seconds: 2)); // wait for it to stabilize
      } catch (e) {
        _showError('Please turn on Bluetooth manually.');
      }
    }
  }

  Future<void> _attemptAutoReconnect() async {
    // TODO: Load previously saved device ID
    // For now, skipping SharedPreferences or storage - you can integrate easily

    // Skipping auto reconnect now, always scanning
    _startScan();
  }

  void _startScan() async {
    _devices.clear();
    fbp.FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    fbp.FlutterBluePlus.scanResults.listen((results) {
      for (fbp.ScanResult r in results) {
        if (!_devices.any((d) => d.remoteId == r.device.remoteId) && r.device.platformName.isNotEmpty) {
          setState(() {
            _devices.add(r.device);
          });
        }
      }
    });
  }

  Future<void> _connectDevice(fbp.BluetoothDevice device) async {
    setState(() {
      _connecting = true;
      _connectingDeviceId = device.remoteId.str;
    });

    try {
      await device.connect();
      setState(() {
        _connectedDevice = device;
      });

      // TODO: Save connected device ID for auto-reconnect later
      // SharedPreferences.setString(_knownDeviceIdKey, device.remoteId.str);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InvoicePreviewScreen(device: device)),
      );
    } catch (e) {
      _showError('Failed to connect: $e');
    } finally {
      setState(() {
        _connecting = false;
        _connectingDeviceId = null;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Printer')),
      body: _devices.isEmpty
          ? Center(child: Text('No printers found.'))
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return ListTile(
            title: Text(device.platformName),
            subtitle: Text(device.remoteId.str),
            trailing: _connecting && _connectingDeviceId == device.remoteId.str
                ? CircularProgressIndicator()
                : Icon(Icons.bluetooth),
            onTap: () => _connectDevice(device),
          );
        },
      ),
    );
  }
}
