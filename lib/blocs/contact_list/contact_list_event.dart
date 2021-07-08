part of 'contact_list_bloc.dart';

@immutable
abstract class ContactListEvent {}

class ContactListReaded extends ContactListEvent {
  final bool refreshed;
  ContactListReaded({this.refreshed});
}
/* class ContactListReadedMore extends ContactListEvent {
  final bool hasMoreContacts;
  final List<BlouContact> totalContacts;
  ContactListReadedMore({this.hasMoreContacts, this.totalContacts});
}
 */
class ContactListSearched extends ContactListEvent {
  final String query;
  ContactListSearched(this.query);
}

