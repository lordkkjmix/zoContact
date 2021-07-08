part of 'contact_permission_bloc.dart';

abstract class ContactPermissionEvent extends Equatable {
  const ContactPermissionEvent();
  @override
  List<Object> get props => [];
}

class ContactPermissionRequested extends ContactPermissionEvent {}
class ContactPermissionStatusAsked extends ContactPermissionEvent {}
