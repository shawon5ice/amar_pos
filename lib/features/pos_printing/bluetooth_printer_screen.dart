import 'dart:async';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:amar_pos/core/widgets/dashed_line.dart';
import 'package:amar_pos/features/pos_printing/pos_invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/network/helpers/error_extractor.dart';
import '../../core/responsive/pixel_perfect.dart';
import '../../core/widgets/custom_btn.dart';
import '../../core/widgets/field_title.dart';
import '../../core/widgets/loading/random_lottie_loader.dart';
import '../../core/widgets/methods/helper_methods.dart';
import '../inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'invoice_gen_from_screen_shot.dart';
import 'invoice_preview_screen.dart';

class BluetoothPrinterScreen extends StatefulWidget {
  const BluetoothPrinterScreen({
    super.key,
  });

  @override
  _BluetoothPrinterScreenState createState() => _BluetoothPrinterScreenState();
}

class _BluetoothPrinterScreenState extends State<BluetoothPrinterScreen> {
  BluetoothDevice? _device;
  BluetoothDevice? _selectedDevice;
  late StreamSubscription<bool> _isScanningSubscription;
  late StreamSubscription<BlueState> _blueStateSubscription;
  late StreamSubscription<ConnectState> _connectStateSubscription;
  late StreamSubscription<Uint8List> _receivedDataSubscription;
  late StreamSubscription<List<BluetoothDevice>> _scanResultsSubscription;
  List<BluetoothDevice> _scanResults = [];

  bool isConnecting = false;

  late PosInvoiceModel posInvoiceModel;
  bool isScanning = false;
  bool isConnected = false;
  bool isPrinting = false;

  @override
  void initState() {
    posInvoiceModel = Get.arguments;
    super.initState();
    initBluetoothPrintPlusListen();
  }

  @override
  void dispose() {
    super.dispose();
    _isScanningSubscription.cancel();
    _blueStateSubscription.cancel();
    _connectStateSubscription.cancel();
    _receivedDataSubscription.cancel();
    _scanResultsSubscription.cancel();
    _scanResults.clear();
  }

  Future<void> initBluetoothPrintPlusListen() async {
    /// listen scanResults
    _scanResultsSubscription = BluetoothPrintPlus.scanResults.listen((event) {
      if (mounted) {
        setState(() {
          _scanResults = event;
        });
      }
    });

    /// listen isScanning
    _isScanningSubscription = BluetoothPrintPlus.isScanning.listen((event) {
      print('********** isScanning: $event **********');
      if (mounted) {
        setState(() {
          isScanning = event;
          isConnected = false;
        });
      }
    });

    /// listen blue state
    _blueStateSubscription = BluetoothPrintPlus.blueState.listen((event) {
      print('********** blueState change: $event **********');
      if (mounted) {
        if(event == BlueState.blueOn){
          BluetoothPrintPlus.startScan();
        }else{
          Methods.showSnackbar(msg: "Please turn on bluetooth");
        }
        setState(() {});
      }
    });

    /// listen connect state
    _connectStateSubscription = BluetoothPrintPlus.connectState.listen((event) {
      print('********** connectState change: $event **********');
      switch (event) {
        case ConnectState.connected:
          // RandomLottieLoader.hide();
          setState(() {
            if (_device == null) return;

            isConnected = true;
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => InvoicePreviewScreen(device:  _device!)));
          });
          break;
        case ConnectState.disconnected:
          setState(() {
            _device = null;
            isConnected = false;
          });
          break;
      }
    });
    /// listen received data
    _receivedDataSubscription = BluetoothPrintPlus.receivedData.listen((data) {
      print('********** received data: $data **********');

      /// do something...
    });
  }

  String selectedSize = '80mm'; // default selection

  final List<String> sizes = ['80mm', '58mm', '72mm'];


  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _disconnect();
  }

  void _disconnect() async {
    await BluetoothPrintPlus.disconnect();
  }

  Widget _buildInvoiceWidget(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: 576,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  posInvoiceModel.storeName,
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 26,
                      letterSpacing: 1),
                ),
                Text(
                  posInvoiceModel.storeAddress,
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 20,
                      letterSpacing: 1),
                  textAlign: TextAlign.center,
                ),
                Text(
                  posInvoiceModel.storePhone,
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 20,
                      letterSpacing: 1),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Invoice :${posInvoiceModel.invoiceNo}",
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 22,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Date & Time :${posInvoiceModel.invoiceDate}",
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 20,
                      letterSpacing: 1),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(height: 4,),
              ],
            ),
          ),
          addH(4),
          const DashedLine(dashThickness: 2,),
          addH(4),
          Text(
            posInvoiceModel.customerName,
            style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 18,),
            textAlign: TextAlign.center,
          ),
          Text(
            posInvoiceModel.customerPhone,
            style: TextStyle(
                fontSize: 18,),
            textAlign: TextAlign.center,
          ),
          Text(
            "Address : ${posInvoiceModel.customerAddress ?? 'N/A'}",
            style: TextStyle(
              fontFamily: 'RobotoMono',
                fontSize: 18, fontWeight: FontWeight.w500,),
            textAlign: TextAlign.center,
          ),
          addH(4),
          const DashedLine(dashThickness: 2,),
          addH(4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 4,
                  child: Text(
                    "Item",
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 20,
                        letterSpacing: 2),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 20,),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    'Price',
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 20,
                        letterSpacing: 2),
                    textAlign: TextAlign.end,
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 20,
                        letterSpacing: 2),
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
          addH(4),
          const DashedLine(dashThickness: 2,),
          addH(4),
          ...posInvoiceModel.products.map((item) {
            int index = posInvoiceModel.products.indexOf(item);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "${index + 1}.${item.name}",
                        style: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        Methods.getFormattedNumber(item.qty.toDouble()),
                        style: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,),
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        Methods.getFormatedPrice((item.unitPrice).toDouble()),
                        style: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,),
                        textAlign: TextAlign.end,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        Methods.getFormatedPrice((item.subTotal).toDouble()),
                        style: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,),
                        textAlign: TextAlign.end,
                      )),
                ],
              ),
            );
          }),
          addH(4),
          const DashedLine(dashThickness: 2,),
          addH(4),
          ...posInvoiceModel.paymentUpperSection.entries.map((item) {
            // int index = posInvoiceModel.products.indexOf(item.key);
            return _buildSummaryRow(item.key, item.value);
          }),
          ...posInvoiceModel.paymentDetails.entries.map((item) {
            // int index = posInvoiceModel.products.indexOf(item.key);
            return _buildSummaryRow(item.key, item.value);
          }),
          if(posInvoiceModel.changeAmount != null)addH(4),
          if(posInvoiceModel.changeAmount != null)const DashedLine(dashThickness: 2,),
          if(posInvoiceModel.changeAmount != null) addH(4),
          if(posInvoiceModel.changeAmount != null)_buildSummaryRow('Change Amount', posInvoiceModel.changeAmount!.toDouble(),isBold: true),
          // _buildSummaryRow('VAT', posInvoiceModel.vat.toDouble()),
          // _buildSummaryRow('Additional Charge', posInvoiceModel.additionalCharge.toDouble()),
          // _buildSummaryRow('Discount', posInvoiceModel.discount.toDouble()),
          // _buildSummaryRow('Total', posInvoiceModel.invoiceNo, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    if(label == "Payable Amount"){
      isBold = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold
                  ? TextStyle(fontWeight:FontWeight.bold,fontSize: 24,fontFamily: 'RobotoMono',)
                  : TextStyle(fontSize: 20, fontFamily: 'RobotoMono',)),
          Text('${Methods.getFormatedPrice(amount)}',
              style: isBold
                  ? TextStyle(fontWeight:FontWeight.bold,fontSize: 24, fontFamily: 'RobotoMono',)
                  : TextStyle(fontSize: 20, fontFamily: 'RobotoMono',)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BluetoothPrintPlus'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldTitle("Select Printer"),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: CustomDropdown<BluetoothDevice>(
                        items: isScanning? []:_scanResults,
                        isMandatory: false,
                        noTitle: true,
                        title: "Select Device",
                        itemLabel: (e) => e.name,
                        onChanged: (device) {
                          setState(() {
                            _selectedDevice = device;
                          });
                        },
                        hintText:  isScanning ? "Loading...": "Select Device",
                      ),
                    ),
                    addW(8),
                    Expanded(
                      flex: 5,
                      child: CustomBtn(
                        onPressedFn: () async {
                          if (_selectedDevice == null) {
                            ErrorExtractor.showSingleErrorDialog(
                                context, "Please select a printer first");
                            return;
                          }

                          if (_device?.address == _selectedDevice?.address) {
                            // Already connected
                            return;
                          }

                          setState(() => isConnecting = true);

                          try {
                            RandomLottieLoader.show();
                            await BluetoothPrintPlus.connect(_selectedDevice!);
                            _device = _selectedDevice;
                          } catch (e) {
                            ErrorExtractor.showSingleErrorDialog(
                                context, "Failed to connect to device");
                          } finally {
                            setState(() => isConnecting = false);
                            RandomLottieLoader.hide();
                          }
                        },
                        btnTxt: _selectedDevice == null ? "Select": isConnecting
                            ? "Connecting..."
                            : (_device?.address == _selectedDevice?.address && _selectedDevice != null
                                ? "Connected"
                                : "Connect"),
                        btnSize: Size(100, 60),
                        txtSize: 14,
                        btnColor: _device?.address == _selectedDevice?.address && _selectedDevice != null
                            ? AppColors.primary : Colors.transparent,
                        btnBorderColor: AppColors.primary,
                        txtColor: _device?.address == _selectedDevice?.address && _selectedDevice != null
                            ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text('Select Paper Size', style: TextStyle(fontSize: 18)),
                    ...sizes.map((size) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: size,
                            groupValue: selectedSize,
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value!;
                              });
                            },
                          ),
                          Text(size),
                          SizedBox(width: 12),
                        ],
                      );
                    }).toList()
                  ]
                ),
                addH(10),
                Expanded(
                  child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: _buildInvoiceWidget(context),
                          ),
                          const Positioned.fill(
                            child: IgnorePointer( // So watermark doesn't block taps
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Opacity(
                                    opacity: 0.15, // Adjust for subtlety
                                    child: Text(
                                      "Preview",
                                      style: TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: isConnected ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: CustomBtn(
            btnColor: isPrinting ? Colors.grey : null,
                onPressedFn: isPrinting ?  null :  () async {
                  if(mounted){
                    setState(() {
                      isPrinting = true;
                    });
                  }

                  Uint8List? image8List = await InvoiceGenerator.generateInvoice(
                    context: context,
                    widget: _buildInvoiceWidget(context),
                  );
                  if (image8List != null) {
                    final decoded = img.decodeImage(image8List);
                    if (decoded == null) {
                      print("Could not decode image");
                      return;
                    }

                    final resized = img.copyResize(decoded, width: 576); // Full 80mm width

                    final generator = Generator(
                        selectedSize == sizes.first ?
                        PaperSize.mm80 : selectedSize == sizes.last ? PaperSize.mm72 : PaperSize.mm58, await CapabilityProfile.load());
                    final bytes = <int>[
                      ...generator.imageRaster(resized, align: PosAlign.center),
                      // ...generator.qrcode(posInvoiceModel.invoiceNo,size: QRSize.size6),
                      ...generator.cut(),
                    ];

                    // ✅ Convert to Uint8List
                    BluetoothPrintPlus.write(Uint8List.fromList(bytes)).whenComplete((){
                      if(mounted){
                        Future.delayed(Duration(milliseconds: 2000),(){
                          setState(() {
                            isPrinting = false;
                          });
                        });

                      }
                    });
                  }
                },

                btnTxt: isPrinting ? "Printing" : "Print Invoice",
              ),
        ): SizedBox.shrink(),
        // SafeArea(
        //     child: BluetoothPrintPlus.isBlueOn
        //         ? ListView(
        //       children: _scanResults
        //           .map((device) => Container(
        //         padding: EdgeInsets.only(
        //             left: 10, right: 10, bottom: 5),
        //         child: Row(
        //           mainAxisAlignment:
        //           MainAxisAlignment.spaceBetween,
        //           children: [
        //             Expanded(
        //                 child: Column(
        //                   crossAxisAlignment:
        //                   CrossAxisAlignment.start,
        //                   children: [
        //                     Text(device.name),
        //                     Text(
        //                       device.address,
        //                       overflow: TextOverflow.ellipsis,
        //                       style: TextStyle(
        //                           fontSize: 12, color: Colors.grey),
        //                     ),
        //                     Divider(),
        //                   ],
        //                 )),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             OutlinedButton(
        //               onPressed: () async {
        //                 _device = device;
        //                 await BluetoothPrintPlus.connect(device);
        //               },
        //               child: const Text("connect"),
        //             )
        //           ],
        //         ),
        //       ))
        //           .toList(),
        //     )
        //         : buildBlueOffWidget()),
        floatingActionButton:
            BluetoothPrintPlus.isBlueOn ? buildScanButton(context) : null);

  }

  Widget buildBlueOffWidget() {
    return Center(
        child: Text(
      "Bluetooth is turned off\nPlease turn on Bluetooth...",
      style: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 20, color: Colors.red),
      textAlign: TextAlign.center,
    ));
  }

  Widget buildScanButton(BuildContext context) {
    if (BluetoothPrintPlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          onPressed: onScanPressed,
          backgroundColor: Colors.green,
          child: Text("SCAN"));
    }
  }

  Future onScanPressed() async {
    try {
      await BluetoothPrintPlus.startScan(timeout: Duration(seconds: 4));
    } catch (e) {
      print("onScanPressed error: $e");
    }
  }

  Future onStopPressed() async {
    try {
      BluetoothPrintPlus.stopScan();
    } catch (e) {
      print("onStopPressed error: $e");
    }
  }
}
