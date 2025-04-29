// import 'dart:async';
// import 'package:bluetooth_print_plus/bluetooth_print_plus.dart' as bpp;
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'invoice_preview_screen.dart';
//
// class POSPrintScreen extends StatefulWidget {
//   const POSPrintScreen({super.key});
//
//   @override
//   _POSPrintScreenState createState() => _POSPrintScreenState();
// }
//
// class _POSPrintScreenState extends State<POSPrintScreen> {
//   BluetoothDevice? connectedDevice;
//   bool isScanning = false;
//   bool isConnecting = false;
//   List<BluetoothDevice> scannedDevices = [];
//   late Stream<BluetoothAdapterState> bluetoothAdapterState;
//   BluetoothAdapterState currentAdapterState = BluetoothAdapterState.unknown;
//
//   int connectingIndex = -1;
//
//   @override
//   void initState(){
//     super.initState();
//     bluetoothAdapterState = FlutterBluePlus.adapterState;
//     listenForBluetooth();
//   }
//
//   void listenForBluetooth() async {
//     currentAdapterState = await FlutterBluePlus.adapterState.first;
//     bluetoothAdapterState.listen((value){
//
//       if(value == BluetoothAdapterState.off || value == BluetoothAdapterState.turningOff){
//         scannedDevices.clear();
//       }
//       setState(() {
//         currentAdapterState = value;
//       });
//     });
//     _initBluetooth();
//   }
//
//   // Initialize Bluetooth
//   Future<void> _initBluetooth() async {
//     await [
//       Permission.bluetooth,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.location,
//     ].request();
//
//     if (!(await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off)) {
//       await FlutterBluePlus.turnOn().then((value){
//         _startScanning();
//       });
//     }else{
//       _startScanning();
//     }
//
//
//   }
//
//   // Start scanning for devices and listen for devices being discovered
//   void _startScanning() {
//     scannedDevices.clear();
//     if(currentAdapterState != BluetoothAdapterState.on){
//       return;
//     }
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
//
//     FlutterBluePlus.scanResults.listen((results) {
//       for (var r in results) {
//         if (r.device.platformName.isNotEmpty &&
//             !scannedDevices.any((d) => d.remoteId == r.device.remoteId)) {
//           setState(() {
//             scannedDevices.add(r.device);
//           });
//         }
//       }
//     });
//   }
//
//   void navigateToInvoice(bpp.BluetoothDevice device){
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => InvoicePreviewScreen(device: device)),
//     ).then((_) {
//       setState(() {
//         connectingIndex = -1;
//       });
//     });
//   }
//
//
//   // Connect to the selected device
//   Future<void> _connectDevice(BluetoothDevice device, int index) async {
//     setState(() {
//       isConnecting = true;
//       connectingIndex = index;
//     });
//
//     try {
//       final bppDevice = bpp.BluetoothDevice(
//         device.platformName,
//         device.remoteId.str,
//       );
//
//       await bpp.BluetoothPrintPlus.connect(bppDevice);
//
//       bpp.BluetoothPrintPlus.connectState.listen((status) {
//         print('Printer connection status: $status');
//       });
//
//       setState(() {
//         connectedDevice = device;
//       });
//
//       navigateToInvoice(bppDevice);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Connection failed: $e")),
//       );
//       setState(() {
//         connectingIndex = -1;
//       });
//     } finally {
//       setState(() {
//         isConnecting = false;
//       });
//     }
//   }
//
//
//   // Handle manual device selection and error states
//   Widget buildDeviceTile(BluetoothDevice device, int index) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       elevation: 3,
//       child: ListTile(
//         onTap: (){
//           if(device == connectedDevice){
//             final bppDevice = bpp.BluetoothDevice(
//               device.platformName,
//               device.remoteId.str,
//             );
//             navigateToInvoice(bppDevice);
//           }
//         },
//         leading: const Icon(Icons.bluetooth, color: Colors.blue),
//         title: Text(device.platformName.isEmpty ? 'Unknown' : device.platformName),
//         subtitle: Text(device.remoteId.str),
//         trailing: ElevatedButton(
//           onPressed: isConnecting || connectedDevice == device
//               ? null // Disable button while connecting or if already connected
//               : () {
//             _connectDevice(device, index);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isConnecting ? Colors.grey : Colors.green,
//             // Change color based on state
//             foregroundColor: Colors.white,
//           ),
//           child: connectingIndex == index
//               ? const Text('Connecting...') : connectedDevice == device ? const Text("Connected")
//               : const Text('Connect'),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('POS Printing'),
//         actions: [
//           // Add a button to manually start scanning for devices
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: isScanning ? null : _startScanning,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (currentAdapterState == BluetoothAdapterState.off)
//             Expanded(
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     FlutterBluePlus.turnOn();
//                   },
//                   child: Text("Turn Bluetooth On"),
//                 ),
//               ),
//             ),
//           if (scannedDevices.isEmpty && !isScanning && currentAdapterState == BluetoothAdapterState.on)
//             const Expanded(
//               child: Center(
//                 child: Text(
//                   "No bluetooth device found. Please scan to find a printer.",
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           if (scannedDevices.isEmpty && isScanning)
//             const Expanded(
//               child: Center(
//                 child: LinearProgressIndicator(),
//               ),
//             ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 _startScanning();
//               },
//               child: ListView.builder(
//                 itemCount: scannedDevices.length,
//                 itemBuilder: (_, index) {
//                   final device = scannedDevices[index];
//                   return buildDeviceTile(device, index);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
