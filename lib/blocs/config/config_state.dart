part of 'config_bloc.dart';

@immutable
abstract class ConfigState {}

class ConfigInitial extends ConfigState {}

class ConfigInProgress extends ConfigState {}

class ConfigReadSuccess extends ConfigState {
  final Config config;
  ConfigReadSuccess(this.config);
}
class ConfigWrittenSuccess extends ConfigState {
  final Config config;
  ConfigWrittenSuccess(this.config);
}
class ConfigStartWrittenSuccess extends ConfigState {
  final Config config;
  ConfigStartWrittenSuccess(this.config);
}

class ConfigReadFailure extends ConfigState {
  final String code;
  final String message;
  ConfigReadFailure({this.code, this.message});
}
class ConfigUnlockWrittenSuccess extends ConfigState {}
