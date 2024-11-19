
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ActionDropDownWidget extends StatefulWidget {

  const ActionDropDownWidget({
    super.key,
  });

  @override
  State<ActionDropDownWidget> createState() => _ActionDropDownWidgetState();
}

class _ActionDropDownWidgetState extends State<ActionDropDownWidget> {

  final List<String> items = [
    'Repair',
    'Replace Request',
    'Reject',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            SizedBox(
              width: 8,
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color:
              item.contains('Reject') ? Colors.red : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ))
            .toList(),
        value: null,
        onChanged: (value) {
          setState(() {
            if (value == 'Repair') {

            } else if (value == 'Reject') {

            }else if(value == 'Replace Request'){

            }
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          // height: 50,
          width: 132,
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            // border: Border.all(
            //   color: Colors.black26,
            // ),
            color: const Color(0xff7701f8),
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          iconSize: 24,
          iconEnabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              // color: Colors.redAccent,
              border: Border.all(color: Colors.deepPurple)),
          offset: const Offset(0, -5),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
            height: 36,
            padding: const EdgeInsets.only(left: 8, right: 8),
            overlayColor: WidgetStateProperty.all(const Color(0xffF4E9FF))),
      ),
    );
  }
}
