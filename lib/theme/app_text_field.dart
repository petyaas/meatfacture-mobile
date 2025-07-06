import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class AppTextField extends StatefulWidget {
  final BuildContext context;
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final Color borderColor;
  final Color errorBorderColor;
  final Color errorTextColor;
  final bool enabled;
  final List<TextInputFormatter> inputFormatters;

  AppTextField({
    Key key,
    @required this.context,
    @required this.controller,
    @required this.hintText,
    @required this.onChanged,
    this.validator,
    this.keyboardType,
    this.borderColor = newGrey,
    this.errorBorderColor = newGrey,
    this.errorTextColor = newRedDark,
    this.enabled = true,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(context) {
    return TextFormField(
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        return widget.validator != null ? widget.validator(value) : null;
      },
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: appLabelTextStyle(color: newGrey, fontSize: heightRatio(size: 14, context: context)),
        // errorText: widget.errorText.isNotEmpty ? widget.errorText : null,
        errorStyle: appLabelTextStyle(color: widget.errorTextColor, fontSize: heightRatio(size: 12, context: context)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.borderColor)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.errorBorderColor)),
        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.errorBorderColor)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.borderColor)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: widget.borderColor)),
        contentPadding: EdgeInsets.only(top: heightRatio(size: 10, context: context)),
      ),
    );
  }
}
