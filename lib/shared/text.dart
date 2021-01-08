import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlouText extends StatelessWidget {
  final String text;
  final String type;
  final double fontSize;
  final Color color;
  final double textScaleFactor;
  final FontWeight fontWeight;

  // Style
  final TextStyle customTextStyle;

  final TextAlign textAlign;

  //passing props in react style
  BlouText({
    @required this.text,
    this.type = "light",
    this.fontSize = 18.0,
    this.color = Colors.black,
    this.customTextStyle,
    this.textAlign = TextAlign.left,
    this.textScaleFactor = 1.0,
    this.fontWeight,
  });

  BlouText.text(this.text,
      {this.color: Colors.black, this.fontSize: 18.0, this.type: 'medium', this.textAlign = TextAlign.left, this.textScaleFactor = 1.0, this.customTextStyle,this.fontWeight});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    switch (type) {
      case 'light':
        return (new Text(text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: GoogleFonts.workSans().fontFamily,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
              color: color,
            ),
            textScaleFactor: textScaleFactor != null && textScaleFactor != 1.0 ? textScaleFactor : width < 330 ? 0.8 : textScaleFactor,
            textAlign: this.textAlign));
      case 'medium':
        return (new Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: GoogleFonts.workSans().fontFamily,
            decoration: TextDecoration.none,
            color: color,
          ).copyWith(color: customTextStyle?.color),
          textScaleFactor: textScaleFactor != null && textScaleFactor != 1.0 ? textScaleFactor : width < 330 ? 0.8 : textScaleFactor,
          textAlign: this.textAlign,
        ));
      case 'bold':
        return (new Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: GoogleFonts.workSans().fontFamily,
            decoration: TextDecoration.none,
            color: color,
            fontWeight: GoogleFonts.workSans(fontWeight:this.fontWeight!= null?this.fontWeight: FontWeight.bold).fontWeight
          ),
          textScaleFactor: textScaleFactor != null && textScaleFactor != 1.0 ? textScaleFactor : width < 330 ? 0.8 : textScaleFactor,
          textAlign: this.textAlign,
        ));
      default:
        TextStyle textStyle = TextStyle(fontSize: 20.0);
        if (customTextStyle != null) {
          textStyle = customTextStyle;
        }
        return (new Text(text, textScaleFactor: textScaleFactor != null && textScaleFactor != 1.0 ? textScaleFactor : width < 330 ? 0.8 : textScaleFactor, textAlign: this.textAlign, style: textStyle));
    }
  }
}
