import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_assets.dart';
import 'custom_text_field.dart';
import 'methods/field_validator.dart';

class CustomDateRangeSelectionFieldWidget extends StatefulWidget {
  const CustomDateRangeSelectionFieldWidget({
    super.key,
    required this.onDateRangeSelection,
    this.initialDate,
    this.isMandatory,
    this.noInputBorder,
    this.fontSize,
  });

  final Function(DateTimeRange? dateRange) onDateRangeSelection;
  final DateTimeRange? initialDate;
  final bool? isMandatory;
  final bool? noInputBorder;
  final double? fontSize;

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
    if (widget.initialDate != null) {
      setDateString(widget.initialDate!);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDateRangeSelectionFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update the date string if the initialDate changes
    if (widget.initialDate != null) {
      setDateString(widget.initialDate!);
    } else {
      _textEditingController.clear();
    }
  }

  void setDateString(DateTimeRange dateTimeRange) {
    setState(() {
      _textEditingController.text =
      "${formatDate(dateTimeRange.start)} - ${formatDate(dateTimeRange.end)}";
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      txtSize: widget.fontSize ??12,
      noInputBorder: widget.noInputBorder,
      readOnly: true,
      onTap: () async {
        DateTimeRange? selectedDate = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now().subtract(const Duration(days: 1000)),
          lastDate: DateTime.now().add(const Duration(days: 1000)),
          initialDateRange: widget.initialDate,
        );
        if (selectedDate != null) {
          setDateString(selectedDate);
          widget.onDateRangeSelection(selectedDate);
        }
      },
      textCon: _textEditingController,
      suffixWidget: GestureDetector(
        onTap: _textEditingController.text.isNotEmpty
            ? () {
          setState(() {
            _textEditingController.clear();
            widget.onDateRangeSelection(null);
          });
        }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _textEditingController.text.isNotEmpty
              ? const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
          )
              : SvgPicture.asset(
            AppAssets.calenderIcon,
          ),
        ),
      ),
      validator: widget.isMandatory != null ?  (value) =>
          FieldValidator.nonNullableFieldValidator(
              _textEditingController.text, "Date range") : null,
      hintText: "Select date range",
      inputType: TextInputType.text,
    );
  }
}
