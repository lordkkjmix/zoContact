import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'blocs/blocs.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';
import 'shared/shared.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ConfigBloc(repository: ConfigRepository()))
        ],
        child: BlocConsumer<ConfigBloc, ConfigState>(
            listener: (context, configState) {
          if (configState is ConfigReadSuccess) {
            BlocProvider.of<ConfigBloc>(context)
                .add(ConfigStartWritten(configState.config));
          } else if (configState is ConfigStartWrittenSuccess) {
            Get.offAll(HomeScreen());
          }
        }, builder: (context, configState) {
          if (configState is ConfigInitial) {
            BlocProvider.of<ConfigBloc>(context).add(ConfigLocalAsked());
          }
          return Scaffold(
              body: Center(
                  child: Loader(
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          )));
        }));
  }
}
