import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/repositories/repositories.dart';
part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository repository;
  ContactListBloc({this.repository}) : super(ContactListInitial());

  @override
  Stream<ContactListState> mapEventToState(
    ContactListEvent event,
  ) async* {
    if (event is ContactListReaded) {
        yield ContactListInProgress();
      List<BlouContact> loaded =
          await this.repository.loadContacts(event.refreshed);
          loaded.removeWhere((element) => element.convertedPhone == null || element.convertedPhone.isEmpty);
      if (loaded != null && loaded.isNotEmpty) {
        this.repository.writeContactsToStorage(loaded);
        /* if (event.currentContacts != null) {
          print("skipped: ${event.currentContacts.length -1}");
          print("loaded: ${(loaded.length -1)}");
          List<BlouContact> c = loaded
              .skip(event.currentContacts.length -1)
              .take((event.currentContacts.length-1) + 100 >= (loaded.length - 1)
                  ? (loaded.length -1) - (event.currentContacts.length -1)
                  : (event.currentContacts.length -1 ) + 100)
              .toList();
          contacts = [...currentContacts, ...c].toSet().toList();
        } else {
          contacts = loaded.take(100).toList();
        }
        print("contacts length: ${contacts.length}");
        if ((contacts.length - 1 ) >= (loaded.length -1)) {
           yield ContactListSuccess(event.currentContacts);
        } else { */
          yield ContactListSuccess(loaded);
        
      } else {
        yield ContactListFailure(message: "Aucun contact disponible");
      }
    } else if (event is ContactListSearched) {
      yield ContactListInProgress();

      List<BlouContact> contacts =
          await this.repository.searchContacts(event.query);
      if (contacts != null && contacts.isNotEmpty) {
        yield ContactListSuccess(contacts);
      } else {
        yield ContactListFailure(message: "Aucun contact disponible");
      }
    }
  }
}
