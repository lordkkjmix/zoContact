part of 'unlock_bloc.dart';

abstract class UnlockState extends Equatable {
  const UnlockState();
  
  @override
  List<Object> get props => [];
}

class UnlockInitial extends UnlockState {}
class ActivationCodeEnteredSuccess extends UnlockState {
  final String code;
  const ActivationCodeEnteredSuccess({this.code});
}
class ActivationCodeEnteredFailure extends UnlockState {
  final String code;
  const ActivationCodeEnteredFailure({this.code});
}
class ActivationProccessing extends UnlockState {}
class ActivationSuccess extends UnlockState {}
class ActivationFailure extends UnlockState {}
