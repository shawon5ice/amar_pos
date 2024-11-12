import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool showImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Inventory"),
        centerTitle: true,
      ),
      body: FallClearanceForm()
    );
  }
}

class FallClearanceForm extends StatefulWidget {
  @override
  _FallClearanceFormState createState() => _FallClearanceFormState();
}

class _FallClearanceFormState extends State<FallClearanceForm> {
  bool _showImage = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 2, // Allow for extra width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This must be calculated. The distance the worker would fall must be less than the distance to the nearest object / surface below the worker.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              
              SizedBox(height: 16),
              Row(
                children: [
                  if (_showImage)
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _showImage = false;
                          });
                        },
                        child: Image.asset(
                          'assets/safety_guide.png', // Make sure this path is correct
                          height: MediaQuery.of(context).size.height/1.5,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              'Image not found. Check the asset path.',
                              style: TextStyle(color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                  if(!_showImage)GestureDetector(
                    onTap: () {
                      setState(() {
                        _showImage = !_showImage;
                      });
                    },
                    child: Card(child: Icon(Icons.remove_red_eye),),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(3),
                      },
                      children: [
                        _buildRow(['Date:${DateTime.now()}', 'Worker 1', 'Worker 2'], isInputRow: false),
                        _buildRow(['Length of Lanyard (A):', '', ''], isInputRow: true),
                        _buildRow(['Extension of Shock Absorber (B):', '', ''], isInputRow: true),
                        _buildRow(['Harness Stretch (from top of worker’s head) (C):', '', ''], isInputRow: true),
                        _buildRow(['Height of Worker to D-Ring (D):', '', ''], isInputRow: true),
                        _buildRow(['Safety Factor (E):', '0.6 metres (2\')', '0.6 metres (2\')',]),
                        _buildRow(['Swing Fall Distance (if worker not directly below anchor):', '', ''], isInputRow: true),
                        _buildRow(['Overall Minimum Clearance Beneath Anchor (F):', '', ''], isInputRow: true),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Calculating Clearance Requirement: Add A + B + C + D + E + * to determine minimum distance from anchor point to nearest surface below worker.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(),
                            SizedBox(),
                          ],
                        ),
                        _buildRow(['Clearance Requirement:', '', ''], isInputRow: true),
                        _buildRow(['Distance to Surface Below:', '', ''], isInputRow: true),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Clearance requirement must be less than the distance from the worker to the nearest surface below.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(),
                            SizedBox(),
                          ],
                        ),
                        _buildRow(['Date Calculated & Reviewed by Worker (DD/MM/YY):', '', ''], isInputRow: true),
                        _buildRow(['Inspected by (Print & Sign):', '', ''], isInputRow: true),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildRow(List<String> cells, {bool isInputRow = false}) {
    return TableRow(
      children: cells.map((cell) {
        int index = cells.indexOf(cell);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: isInputRow && index != 0
              ? TextFormField(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: cell.isEmpty ? 'Enter value' : cell,
              hintStyle: TextStyle(color: Colors.grey)
            ),
          )
              : Text(cell, style: TextStyle(fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }
}