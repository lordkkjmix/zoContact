part of 'codeinput_bloc.dart';

abstract class CodeInputEvent extends Equatable {
  const CodeInputEvent();

  @override
  List<Object> get props => [];
}

class CodeCleared extends CodeInputEvent {}

class CodeDigitEntered extends CodeInputEvent {
  final String digit;
  const CodeDigitEntered(this.digit);

  @override
  List<Object> get props => [digit];

  @override
  String toString() =>
      'CodeDigitEntered { digit: $digit }';
}

class CodeDigitRemoved extends CodeInputEvent {
  final String code;
  const CodeDigitRemoved(this.code);

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'CodeDigitRemoved { code: $code }';
}
