import 'package:zocontact/blocs/blocs.dart';
import 'package:zocontact/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhonePadWidget extends StatelessWidget {
  static const backspace_value = "-1";

  final List<String> digits = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "",
    "0"
  ];
  final String phoneNumber;

  PhonePadWidget({Key key, this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (this.phoneNumber != null) {
      this.digits.removeLast();
    }
    this.digits.add(backspace_value);
    return  Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
      alignment: Alignment.center,
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              new BoxShadow(color: Colors.black, blurRadius: 3.0),
            ]),
        child: BlocConsumer<PhonePadBloc, PhonePadState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            final phoneNumber = state.phoneNumber;
            return Wrap(
              spacing: 0.0,
              runSpacing: 0.0,
              children: [
                for (int index = 0; index < this.digits.length; index++)
                  Container(
                    width: (width - 100) / 3,
                    height: 60,
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: index % 4 == 4
                              ? BorderSide.none
                              : BorderSide(color: Colors.black12, width: 1.0),
                          bottom: index > 8
                              ? BorderSide.none
                              : BorderSide(color: Colors.black12, width: 1.0),
                        ),
                      ),
                      child: ButtonTheme(
                          buttonColor: Colors.white,
                          child: FlatButton(
                            onPressed: () {
                              if (this.digits[index] == backspace_value) {
                                BlocProvider.of<PhonePadBloc>(context)
                                    .add(PhonePadDigitRemoved(phoneNumber));
                              } else {
                                BlocProvider.of<PhonePadBloc>(context).add(
                                    PhonePadDigitEntered(
                                        phoneNumber, this.digits[index]));
                              }
                            },
                            child: Center(
                              child: (this.digits[index] == backspace_value)
                                  ? Icon(Icons.backspace,
                                      color: Colors.black, size: 25)
                                  : BlouText(
                                      text: '${this.digits[index]}',
                                      fontSize: 25),
                            ),
                          )),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
