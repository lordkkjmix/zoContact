import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:zocontact/blocs/blocs.dart';

import 'shared.dart';

class CodeTextFieldWidget extends StatelessWidget {
  final int validInputLength = 5;
  final TextEditingController controller;
  final bool obscureText;

  const CodeTextFieldWidget(
      {Key key, @required this.controller, this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.5,
      child: BlocConsumer<CodeInputBloc, CodeInputState>(
        listener: (context, state) {
         // this.controller.text = state.code;
        },
        builder: (context, state) {
          return PinInputTextField(
            pinLength: this.validInputLength,
            keyboardType: TextInputType.text,
            autoFocus: true,
            enabled: true,
            controller: this.controller,
            onChanged: (value) {
              BlocProvider.of<CodeInputBloc>(context)
                  .add(CodeDigitEntered(value));
            },
            decoration: UnderlineDecoration(
             // hintText: "\u2022\u2022\u2022\u2022\u2022",
              hintTextStyle: TextStyle(fontSize: 40, color: Colors.black26),
              textStyle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
              colorBuilder: PinListenColorBuilder(
                  BlouColors.GreyBgColor, BlouColors.DarkBlueColor),
              obscureStyle: ObscureStyle(
                  isTextObscure: obscureText, obscureText: "\u2022"),
            ),
          );
        },
      ),
    );
  }
}
