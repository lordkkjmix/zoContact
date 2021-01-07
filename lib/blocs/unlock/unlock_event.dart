part of 'unlock_bloc.dart';

abstract class UnlockEvent extends Equatable {
  const UnlockEvent();

  @override
  List<Object> get props => [];
}

class ActivationCodeEntered extends UnlockEvent {
  final String code;
  ActivationCodeEntered(this.code);
}

class ActivationCodeRequested extends UnlockEvent {
  final String userKey;
  final String activationKey;
  ActivationCodeRequested(this.userKey, this.activationKey);
}
