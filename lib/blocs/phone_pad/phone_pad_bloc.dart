import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'phone_pad_event.dart';
part 'phone_pad_state.dart';

class PhonePadBloc extends Bloc<PhonePadEvent, PhonePadState> {
    final int phoneNumberValidInputLength;
  PhonePadBloc(this.phoneNumberValidInputLength) : super(PhonePadInitial());

  @override
  Stream<PhonePadState> mapEventToState(
    PhonePadEvent event,
  ) async* {
       if (event is PhonePadCleared) {
      yield PhonePadInputInProgress("");
      yield PhonePadInputSuccess("");
    }

    if (event is PhonePadDigitRemoved) {
      if (event.phoneNumber != null && event.phoneNumber.length > 0) {
        yield (PhonePadInputSuccess(event.phoneNumber.substring(0, event.phoneNumber.length - 1)));
      }
    }

    if (event is PhonePadDigitEntered) {
      yield PhonePadInputInProgress(event.phoneNumber);
      if (event.phoneNumber != null) {
        String newPhonePad = "${event.phoneNumber}";
        if (event.phoneNumber.length < this.phoneNumberValidInputLength) {
          newPhonePad = "${event.phoneNumber}${event.digit}";
        }
        yield PhonePadInputSuccess(newPhonePad);
      }
    }
  }
}
