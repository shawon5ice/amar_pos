import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../constants/app_assets.dart';
import '../responsive/pixel_perfect.dart';
import 'custom_text_field.dart';
import 'field_title.dart';

class CustomDateSelectionFieldWidget extends StatefulWidget {
  const CustomDateSelectionFieldWidget({super.key, required this.onDateSelection, required this.title});

  final Function(DateTime? date) onDateSelection;
  final String title;

  @override
  State<CustomDateSelectionFieldWidget> createState() =>
      _CustomDateSelectionFieldWidgetState();
}

class _CustomDateSelectionFieldWidgetState
    extends State<CustomDateSelectionFieldWidget> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addH(16.h),
        FieldTitle(widget.title),
        addH(8.h),
        CustomTextField(
          readOnly: true,
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 1000)),
              lastDate: DateTime.now().add(Duration(days: 1000)),
              initialDate: DateTime.now(),);
            if(selectedDate != null){
              setState(() {
                _textEditingController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
              });
              widget.onDateSelection(selectedDate);
            }
          },
          textCon: _textEditingController,
          suffixWidget: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              AppAssets.calenderIcon,
            ),
          ),
          hintText: "Select Manufacturing Date",
          inputType: TextInputType.text,
        ),
      ],
    );
  }
}