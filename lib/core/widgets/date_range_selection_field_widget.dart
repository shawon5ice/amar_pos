import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_assets.dart';
import '../responsive/pixel_perfect.dart';
import 'custom_text_field.dart';
import 'field_title.dart';

class CustomDateRangeSelectionFieldWidget extends StatefulWidget {
  const CustomDateRangeSelectionFieldWidget({super.key, required this.onDateRangeSelection, required this.title, this.initialDate});

  final Function(DateTime? startDate, DateTime? endDate) onDateRangeSelection;
  final String title;
  final DateTimeRange? initialDate;

  @override
  State<CustomDateRangeSelectionFieldWidget> createState() =>
      _CustomDateRangeSelectionFieldWidgetState();
}

class _CustomDateRangeSelectionFieldWidgetState
    extends State<CustomDateRangeSelectionFieldWidget> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.initialDate ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      readOnly: true,
      onTap: () async {
        DateTimeRange? selectedDate = await showDateRangePicker(

          context: context,
          firstDate: DateTime.now().subtract(Duration(days: 1000)),
          lastDate: DateTime.now().add(Duration(days: 1000)),
          initialDateRange: widget.initialDate,
        );
        if(selectedDate != null){
          setState(() {
            _textEditingController.text = formatDate(selectedDate);
          });
          // widget.onDateSelection(_textEditingController.text);
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
    );
  }
}
