part of 'contact_list_bloc.dart';

@immutable
abstract class ContactListState {}

class ContactListInitial extends ContactListState {}

class ContactListSuccess extends ContactListState {
  final List<BlouContact> contacts;
  ContactListSuccess(this.contacts);
}

class ContactListFailure extends ContactListState {
  final String code;
  final String message;
  ContactListFailure({this.code, this.message});
}

class ContactListInProgress extends ContactListState {}
