import 'package:zocontact/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
Future<PermissionStatus> _getPushNotificationPermission() async {
  PermissionStatus permission = await Permission.notification.request();
  if (permission != PermissionStatus.granted && permission != PermissionStatus.restricted) {
    return permission = await Permission.notification.status;
  } else {
    return permission;
  }
}

class PushNotificationRepository {
  Future<PermissionStatus> getPermission() async {
    PermissionStatus permissionStatus = await _getPushNotificationPermission();
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    });
    return permissionStatus;
  }



  Future<String> getFcmToken() async {
    return _firebaseMessaging.getToken().then(
      (String token) async {
        DebugPrinter.printDebug(token);
        return token;
      },
    );
  }
}