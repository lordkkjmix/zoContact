part of 'phone_pad_bloc.dart';

abstract class PhonePadEvent extends Equatable {
  final String phoneNumber;
  const PhonePadEvent(this.phoneNumber);

  @override
  List<Object> get props => [];
}

class PhonePadCleared extends PhonePadEvent {
  PhonePadCleared() : super("");
}

class PhonePadDigitEntered extends PhonePadEvent {
  final String phoneNumber;
  final String digit;
  const PhonePadDigitEntered(this.phoneNumber, this.digit)
      : super(phoneNumber);

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() =>
      'PhonePadDigitEntered { phoneNumber: $phoneNumber, digit: $digit }';
}

class PhonePadDigitRemoved extends PhonePadEvent {
  final String phoneNumber;
  const PhonePadDigitRemoved(this.phoneNumber) : super(phoneNumber);

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'PhonePadDigitRemoved { phoneNumber: $phoneNumber }';
}
