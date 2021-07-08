part of 'config_bloc.dart';

@immutable
abstract class ConfigEvent {}

class ConfigWritten extends ConfigEvent {
  final Config config;
  ConfigWritten(this.config);
}
class ConfigHasEndOnboardingWritten extends ConfigEvent {
  final bool hasEndOnboarding;
  ConfigHasEndOnboardingWritten(this.hasEndOnboarding);
}
class ConfigStartWritten extends ConfigEvent {
  final Config config;
  ConfigStartWritten(this.config);
}

class ConfigLocalAsked extends ConfigEvent {
  ConfigLocalAsked();
}

class ConfigCleared extends ConfigEvent {}
class ConfigUnlockWritten extends ConfigEvent {}
class ConfigReset extends ConfigEvent {}
