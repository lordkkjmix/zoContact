part of 'contact_permission_bloc.dart';
class ContactPermissionInitial extends ContactPermissionState {}

class ContactPermissionFailure extends ContactPermissionState {}

class ContactPermissionInProgress extends ContactPermissionState {}

abstract class ContactPermissionState extends Equatable {
  const ContactPermissionState();

  @override
  List<Object> get props => [];
}

class ContactPermissionSuccess extends ContactPermissionState {}
