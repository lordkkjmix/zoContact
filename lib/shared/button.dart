import 'package:zocontact/shared/shared.dart';
import 'package:flutter/material.dart';

class BlouButton extends StatelessWidget {
  //Button Custom Style
  final bool customStyle;
  //Button type
  final String type;
  // Buton name
  final String label;

  // On pressed action
  final VoidCallback onPressed;

  // On long pressed action
  final VoidCallback onLongPressed;

  // Style
  final TextStyle buttonTextStyle;

  // Background color
  final Color bgColor;

  // Radius size
  final double radiusSize;

  // Border colors
  final Color borderColor;

  // Border width
  final double borderWidth;

  // width of button
  final double width;
  // width of button
  final double height;
  // icon of button
  final Widget icon;
  //button label style
  final TextStyle labelStyle;

  final String labelType;
  final Color labelColor;
  final double labelFontSize;

  //button color
  final Color buttonColor;

  //Circular progress indicator color
  final Color loaderColor;

  //mini button for raisedIconButton
  final mini;

  final isWorking;

  //passing props in react style
  BlouButton(
      {@required this.label,
      @required this.onPressed,
      this.customStyle = false,
      this.type,
      this.onLongPressed,
      this.buttonTextStyle,
      this.bgColor = BlouColors.DarkBlueColor,
      this.radiusSize = 10.0,
      this.borderColor = Colors.grey,
      this.borderWidth = 1.0,
      this.width = 250.0,
      this.height = 50,
      this.icon,
      this.buttonColor,
      this.labelStyle,
      this.labelType = "medium",
      this.labelColor = Colors.white,
      this.loaderColor = Colors.white,
      this.labelFontSize = 20,
      this.mini = true,
      this.isWorking = false});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'outline':
        return ButtonTheme(
            minWidth: width,
            height: height,
            child: new OutlineButton(
              child: BlouText(
                text: label,
                type: "medium",
                color: labelColor,
                customTextStyle: labelStyle,
              ),
              onLongPress: onLongPressed,
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
              borderSide: BorderSide(width: borderWidth, color: borderColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusSize)),
            ));
      case 'flat':
        return ButtonTheme(
            minWidth: width,
            height: height,
            child: new FlatButton(
              child: this.isWorking
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(loaderColor))
                  : BlouText(
                      text: label,
                      type: labelType,
                      color: labelColor,
                      fontSize: labelFontSize,
                      customTextStyle: labelStyle,
                    ),
              onLongPress: onLongPressed,
              onPressed: onPressed,
            ));
      case 'raised-icon':
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                icon,
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: BlouText(
                    text: label,
                    customTextStyle: labelStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          onTap: onPressed,
        );
        break;
      default:
        return ButtonTheme(
            minWidth: width,
            height: height,
            child: Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new RaisedButton(
                    child: this.isWorking
                        ? CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white))
                        : BlouText(
                            text: label,
                            customTextStyle: labelStyle,
                            type: labelType,
                            color: labelColor,
                            fontSize: labelFontSize,
                          ),
                    onLongPress: onLongPressed,
                    onPressed: onPressed,
                    color: bgColor,
                    disabledColor: bgColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radiusSize),
                    ))));
    }
  }
}
