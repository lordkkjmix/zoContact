part of 'codeinput_bloc.dart';

abstract class CodeInputState extends Equatable {
    final String code;
  const CodeInputState({this.code});

  @override
  List<Object> get props => [];
}

class CodeInputInitial extends CodeInputState {}

class CodeInputInProgress extends CodeInputState {
  final String code;
  CodeInputInProgress(this.code);
}

class CodeInputSuccess extends CodeInputState {
  final String code;

  CodeInputSuccess(this.code);
  @override
  List<Object> get props => [code];

  @override
  String toString() => 'CodeInputSuccess { code: $code }';
}
