import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';
part 'contact_permission_event.dart';
part 'contact_permission_state.dart';

class ContactPermissionBloc
    extends Bloc<ContactPermissionEvent, ContactPermissionState> {
  ContactPermissionBloc() : super(ContactPermissionInitial());
  @override
  Stream<ContactPermissionState> mapEventToState(
      ContactPermissionEvent event) async* {
    yield ContactPermissionInProgress();
    if (event is ContactPermissionStatusAsked) {
      final PermissionStatus status = await Permission.contacts.status;
      if (status.isGranted) {
        yield ContactPermissionSuccess();
      } else {
        yield ContactPermissionFailure();
      }
    } else if (event is ContactPermissionRequested) {
      final status = await Permission.contacts.status;
      if (await Permission.contacts.request().isGranted) {
        yield ContactPermissionSuccess();
      } else if (status.isPermanentlyDenied ||
          status.isDenied ||
          status.isRestricted) {
        openAppSettings();
      } else {
        yield ContactPermissionFailure();
      }
    }
  }
}
