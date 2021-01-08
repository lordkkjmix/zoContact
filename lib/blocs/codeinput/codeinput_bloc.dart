import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'codeinput_event.dart';
part 'codeinput_state.dart';

class CodeInputBloc extends Bloc<CodeInputEvent, CodeInputState> {
  final int codeValidInputLength;

  CodeInputBloc(this.codeValidInputLength) : super(CodeInputInitial());

  @override
  Stream<CodeInputState> mapEventToState(
    CodeInputEvent event,
  ) async* {
    if (event is CodeCleared) {
      yield CodeInputInProgress("");
      yield CodeInputSuccess("");
    }

    if (event is CodeDigitRemoved) {
      if (event.code != null && event.code.length > 0) {
        yield (CodeInputSuccess(
            event.code.substring(0, event.code.length - 1)));
      }
    }

    if (event is CodeDigitEntered) {
      yield CodeInputInProgress(event.digit);
      if (event.digit != null) {
        String newCode = "${event.digit}";
        if (state.code.length < this.codeValidInputLength){
          newCode = "${event.digit}";
        }
        yield CodeInputSuccess(newCode);
      }
    }
  }
}
