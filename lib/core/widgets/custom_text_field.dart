import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import 'methods/glass_effects.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textCon;
  String? prefixIcon;
  Widget? suffixWidget;
  final String hintText;
  bool? isPassField;
  TextInputType? inputType;
  double? width, height;
  FontWeight? txtFontWeight;
  Color? fillClr;
  Color? brdrClr;
  Color? txtClr;
  Color? disableClr;
  double? brdrRadius;
  double? txtSize;
  bool? enabledFlag;
  String? errorText;
  int? maxLine;
  int? maxLength;
  FocusNode? focusNode;
  List<TextInputFormatter>? inputFormatters;
  bool? isCenterAlign;

  String? Function(String?)? validator;
  void Function(String)? onCngdFn;
  void Function()? onSubmitted;
  void Function()? onTap;
  void Function(String)? onEditStop;
  CustomTextField({
    super.key,
    required this.textCon,
    this.prefixIcon,
    this.suffixWidget,
    required this.hintText,
    this.isPassField,
    this.inputType,
    this.width,
    this.height,
    this.txtFontWeight,
    this.fillClr,
    this.onTap,
    this.disableClr,
    this.txtClr,
    this.brdrClr,
    this.maxLength,
    this.brdrRadius,
    this.txtSize,
    this.onCngdFn,
    this.enabledFlag,
    this.errorText,
    this.onSubmitted,
    this.onEditStop,
    this.maxLine,
    this.focusNode,
    this.inputFormatters,
    this.validator,
    this.isCenterAlign,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.isPassField ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.primary,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      maxLength: widget.maxLength,
      textAlign: widget.isCenterAlign != null? TextAlign.center: TextAlign.start,
      style: TextStyle(
        fontSize: widget.txtSize ?? 12,
        // fontFamily: ConstantStrings.kFontFamily,
        fontWeight: widget.txtFontWeight ?? FontWeight.normal,
        color: widget.enabledFlag == false? Colors.grey.shade800: Colors.black,
      ),
      controller: widget.textCon,
      keyboardType: widget.inputType,
      obscureText: obscureText,
      textAlignVertical: TextAlignVertical.center,
      onTap: widget.onTap??(){
        if(widget.textCon.text=="0"){
          widget.textCon.clear();
        }
      },
      onEditingComplete: widget.onSubmitted,
      // onSubmitted: widget.onEditStop,
      enabled: widget.enabledFlag,

      decoration: InputDecoration(
        filled: widget.enabledFlag != null ? true : widget.fillClr != null,
        fillColor: widget.enabledFlag != null && widget.enabledFlag == false
            ? widget.disableClr??const Color(0xfff6f6f6)
            : widget.fillClr ?? Colors.white,
        contentPadding: widget.maxLine !=null || widget.isCenterAlign != null?const EdgeInsets.all(15):const EdgeInsets.only(left: 15),
        border: getInputBorder(),
        enabledBorder: getInputBorder(),
        focusedBorder: getInputBorder(),
        prefixIcon: widget.prefixIcon != null
            ? SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/${widget.prefixIcon!}.svg',
                    fit: BoxFit.cover,
                    color: const Color(0xff1d3557),
                  ),
                ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: widget.txtSize ?? 16,
          // fontFamily: ConstantStrings.kFontFamily,
          color: const Color(0xff909090),
          fontWeight: widget.txtFontWeight,
        ),
        suffixIcon: widget.suffixWidget != null
            ? widget.suffixWidget!
            : widget.isPassField != null
                ? IconButton(
                    onPressed: () =>
                        setState(() => obscureText = !obscureText),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey.shade600,
                    ),
                  )
                : null,
      ),
      onChanged: widget.onCngdFn,
      maxLines: widget.maxLine??1,
    );
  }

  InputBorder getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.brdrRadius ?? 8.0),
      borderSide: BorderSide(
        color: widget.brdrClr ?? AppColors.inputBorderColor,
        width: 0,
      ),
    );
  }
}
