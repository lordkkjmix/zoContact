part of 'phone_pad_bloc.dart';

abstract class PhonePadState extends Equatable {
    final String phoneNumber;
  const PhonePadState(this.phoneNumber);
  
  @override
  List<Object> get props => [];
}

class PhonePadInitial extends PhonePadState {
  PhonePadInitial():super("");
}
class PhonePadInputInProgress extends PhonePadState {
  final String phoneNumber;
  PhonePadInputInProgress(this.phoneNumber) : super(phoneNumber);
}

class PhonePadInputSuccess extends PhonePadState {
  final String phoneNumber;

  PhonePadInputSuccess(this.phoneNumber) : super(phoneNumber);
  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'PhonePadInputSuccess { phoneNumber: $phoneNumber }';
}
