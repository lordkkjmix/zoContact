import 'dart:async';
import 'package:zocontact/blocs/push_notification/push_notification.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:zocontact/utils/utils.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationRepository repository;

  PushNotificationBloc({@required this.repository}) : super(PushNotificationInitial());
  @override
  // ignore: override_on_non_overriding_member
  PushNotificationState get initialState => PushNotificationInitial();

  @override
  Stream<PushNotificationState> mapEventToState(
    PushNotificationEvent event,
  ) async* {
    yield PushNotificationInProgress();
    if (event is PushNotificationPermissionRequested) {
      // ignore: close_sinks
      final bloc = this;
      PermissionStatus permissionStatus = await this.repository.getPermission();
      if (!event.forcedRequest) {
        bloc.add(PushNotificationAsked());
      } else if (permissionStatus.isPermanentlyDenied || permissionStatus.isDenied) {
        //openAppSettings();
      } else {
        bloc.add(PushNotificationAsked());
      }
    }
    PermissionStatus permissionStatus = await this.repository.getPermission();
    // final fcmKey = await this.repository.getFcmToken();
    //DjamoPrint.printDebug('BeforeAskPermission'+fcmKey.toString());
    if (permissionStatus.isGranted || permissionStatus.isUndetermined) {
      if (event is PushNotificationAsked) {
        try {
          final fcmKey = await this.repository.getFcmToken();
          if (fcmKey != null) {
            yield PushNotificationSuccess(agreeToReceiveNotifications: true);
          }
        } catch (e) {
          yield PushNotificationFailure(e.statusCode, "Erreur inconnue");
        }
      } else if (event is PushNotificationRead) {
        // ignore: close_sinks
        final bloc = this;
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            DebugPrinter.printDebug(message);
            bloc.add(PushNotificationListened(message));
            DebugPrinter.printDebug("after bloc.add");
          },
          onLaunch: (Map<String, dynamic> message) async {
            DebugPrinter.printDebug("onLaunch: $message");
          },
          onResume: (Map<String, dynamic> message) async {
            DebugPrinter.printDebug("onResume: $message");
          },
        );
        yield PushNotificationReadSuccess(displayNotificationTray: event.displayNotificationTray);
      } else if (event is PushNotificationListened) {
        yield PushNotificationListenerSuccess(event.message, displayNotificationTray: state.displayNotificationTray);
      }
    } else {
      yield PushNotificationFailure(401, 'Nous avons besoin de votre accord pour que vous puissiez recevoir des notifications.');
    }
  }
}
