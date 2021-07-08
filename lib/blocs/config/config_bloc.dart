import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/repositories/repositories.dart';

part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository repository;
  ConfigBloc({this.repository}) : super(ConfigInitial());

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is ConfigLocalAsked) {
      yield ConfigInProgress();
      final Config config = await this.repository.readConfigFromStorage();
      if (config != null) {
        yield ConfigReadSuccess(config);
      } else {
        yield ConfigReadFailure(
            message:
                "Erreur de chargement de la configuration. Veuillez réessayer plustard.");
      }
    } else if (event is ConfigHasEndOnboardingWritten) {
      Config newConfig;
      final Config config = await this.repository.readConfigFromStorage();
      newConfig = config.copyWith(hasEndOnboarding: event.hasEndOnboarding);
      yield ConfigWrittenSuccess(newConfig);
    } else if (event is ConfigStartWritten) {
      this.repository.writeConfigToStorage(event.config);
      yield ConfigStartWrittenSuccess(event.config);
    } else if (event is ConfigCleared) {
      this.repository.clearAppConfigFromStorage();
    }else if(event is ConfigUnlockWritten){
      final Config currentConfig = await  this.repository.readConfigFromStorage();
      final Config newConfig = currentConfig.copyWith(unlocked:true);
      this.repository.writeConfigToStorage(newConfig);
        yield ConfigUnlockWrittenSuccess();
    }else if(event is ConfigReset){
      yield ConfigInitial();
    }
  }
}
