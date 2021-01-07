import 'package:equatable/equatable.dart';

abstract class PushNotificationState extends Equatable {
  final bool displayNotificationTray;
  const PushNotificationState({this.displayNotificationTray = true});

  @override
  List<Object> get props => [displayNotificationTray];
}
class PushNotificationInitial extends PushNotificationState {}

class PushNotificationInProgress extends PushNotificationState {}
class PushNotificationReadSuccess extends PushNotificationState {
  final bool displayNotificationTray;
  PushNotificationReadSuccess({this.displayNotificationTray});
}

class PushNotificationSuccess extends PushNotificationState {
  final bool agreeToReceiveNotifications;
  final bool isSupportedBadge;
  const PushNotificationSuccess({this.agreeToReceiveNotifications=false, this.isSupportedBadge});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'PushNotificationSuccess {agreeToReceiveNotifications:$agreeToReceiveNotifications }';
}

class PushNotificationListenerSuccess extends PushNotificationState {
  final Map<String, dynamic> message;
    final bool displayNotificationTray;
  const PushNotificationListenerSuccess(this.message,{this.displayNotificationTray});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PushNotificationListenerSuccess{ message: ${message.toString()} }';
}

class PushNotificationReceived extends PushNotificationState {
  final Map<String, dynamic> message;
  const PushNotificationReceived([this.message]);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PushNotificationReceived { message: ${message.toString()} }';
}

class PushNotificationFailure extends PushNotificationState {
  final int statusCode;
  final String message;
  const PushNotificationFailure(this.statusCode, this.message);

  @override
  List<Object> get props => [statusCode, message];

  @override
  String toString() =>
      'PushNotificationFailure { statusCode: $statusCode, message: $message }';
}
