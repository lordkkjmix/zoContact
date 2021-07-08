import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'unlock_event.dart';
part 'unlock_state.dart';

class UnlockBloc extends Bloc<UnlockEvent, UnlockState> {
  final ConfigRepository repository;

  UnlockBloc({this.repository}) : super(UnlockInitial());

  @override
  Stream<UnlockState> mapEventToState(
    UnlockEvent event,
  ) async* {
    if (event is ActivationCodeEntered) {
      if (event.code != null && event.code.length == 5) {
        yield ActivationCodeEnteredSuccess(code: event.code);
      } else {
        yield ActivationCodeEnteredFailure(code: event.code);
      }
    } else if (event is ActivationCodeRequested) {
      yield ActivationProccessing();
      final bool activation =
          await this.repository.activationVerification(event.userKey, event.activationKey);
      if (activation) {
        yield ActivationSuccess();
      } else {
        yield ActivationFailure();
      }
    }
  }
}
