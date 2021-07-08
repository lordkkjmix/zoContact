import 'package:equatable/equatable.dart';

abstract class PushNotificationEvent extends Equatable {
  const PushNotificationEvent();

  @override
  List<Object> get props => [];
}

class PushNotificationAsked extends PushNotificationEvent {
  const PushNotificationAsked();
}

class PushNotificationPermissionRequested extends PushNotificationEvent {
  final bool forcedRequest;
  const PushNotificationPermissionRequested({this.forcedRequest = false});
}

class PushNotificationRead extends PushNotificationEvent {
  final bool displayNotificationTray;
  const PushNotificationRead({this.displayNotificationTray = true});
}

class PushNotificationListened extends PushNotificationEvent {
  final Map<String, dynamic> message;
  PushNotificationListened(this.message);
}

class PushNotificationDisplayed extends PushNotificationEvent {
  final Map<String, dynamic> message;
  PushNotificationDisplayed(this.message);
}
