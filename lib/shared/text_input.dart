import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlouTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged onChanged;
  final onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final bool autofocus;
  final bool enabled;
  final int maxLength;
  final String hintText;
  final EdgeInsets contentPadding;
  final EdgeInsets contentMargin;
  final String type;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final Widget prefix;
  final Widget surffix;
  final FocusNode focusNode;
  final Color inputTextColor;
  final inputFormatters;
  final AutovalidateMode autovalidateMode;
  final validator;
  final obscureText;
  BlouTextField(
      {this.onChanged,
      this.controller,
      this.keyboardType = TextInputType.phone,
      this.autofocus = false,
      this.enabled = true,
      this.maxLength,
      this.hintText,
      this.contentPadding,
      this.contentMargin,
      this.type = 'formfield',
      this.focusNode,
      this.suffixIcon,
      this.prefixIcon,
      this.prefix,
      this.surffix,
      this.inputFormatters,
      this.onTap,
      this.readOnly = false,
      this.validator,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.obscureText = false,
      this.inputTextColor = Colors.black})
      : super();

  @override
  Widget build(BuildContext context) {
    switch (this.type) {
      case 'amount':
        return new Container(
            padding: contentPadding,
            margin: contentMargin,
            alignment: Alignment.center,
            child: new TextField(
                style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: GoogleFonts.workSans().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: inputTextColor),
                onChanged: onChanged,
                textInputAction: TextInputAction.done,
                keyboardType: keyboardType,
                controller: controller,
                inputFormatters: inputFormatters,
                onTap: onTap,
                readOnly: readOnly,
                maxLength: maxLength,
                textAlign: TextAlign.right,
                autofocus: autofocus,
                focusNode: focusNode,
                decoration: new InputDecoration(
                    hintStyle: TextStyle(color: Colors.red.withOpacity(0.3)),
                    hintText: "hintText",
                    counterText: "",
                    border: InputBorder.none,
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                    prefix: prefix,
                    suffix: surffix)));
      case 'formfield':
        return new Container(
            padding: contentPadding,
            margin: contentMargin,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color(0xffEFEFEF),
            ),
            child: TextFormField(
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: GoogleFonts.workSans().fontFamily,
                    fontWeight: FontWeight.w500,
                    color: inputTextColor),
                onChanged: onChanged,
                keyboardType: keyboardType,
                controller: controller,
                inputFormatters: inputFormatters,
                onTap: onTap,
                readOnly: readOnly,
                maxLength: maxLength,
                textAlign: TextAlign.left,
                autofocus: autofocus,
                focusNode: focusNode,
                decoration: new InputDecoration(
                    hintText: hintText,
                    counterText: "",
                    border: InputBorder.none,
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                    prefix: prefix,
                    suffix: surffix),
                obscureText: obscureText,
                autovalidateMode: this.autovalidateMode,
                validator: validator));
      default:
        return new Container(
          padding: contentPadding,
          margin: contentMargin,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Color(0xffEFEFEF),
          ),
          child: new TextField(
            onChanged: onChanged,
            keyboardType: keyboardType,
            controller: controller,
            inputFormatters: inputFormatters,
            onTap: onTap,
            readOnly: readOnly,
            maxLength: maxLength,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: GoogleFonts.workSans().fontFamily,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            decoration: new InputDecoration(
                hintText: hintText,
                counterText: "",
                border: InputBorder.none,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon),
          ),
        );
    }
  }
}
