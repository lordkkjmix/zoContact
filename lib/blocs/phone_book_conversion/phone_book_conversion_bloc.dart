import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'phone_book_conversion_event.dart';
part 'phone_book_conversion_state.dart';

class PhoneBookConversionBloc
    extends Bloc<PhoneBookConversionEvent, PhoneBookConversionState> {
  final ContactListRepository repository;
  PhoneBookConversionBloc({this.repository})
      : super(PhoneBookConversionInitial());

  @override
  Stream<PhoneBookConversionState> mapEventToState(
    PhoneBookConversionEvent event,
  ) async* {
    if (event is PhoneBookConversionAsked) {
      yield PhoneBookConversionSuccess(event.unConvertedContacts, 1);
     add(PhoneBookConversionStarted(event.unConvertedContacts, 0, isHardBackup:event.isHardBackup));
    } else if (event is PhoneBookConversionStarted) {

      try {
        if (event.currentIndex < event.unConvertedContacts.length) {
              print("next:${event.unConvertedContacts.length} ${event.currentIndex}");
         if(event.isHardBackup != null && event.isHardBackup == true){
            final res = await this
              .repository
              .hardConvertPhoneBookContacts(
                  event.unConvertedContacts
                      .elementAt(event.currentIndex)
                      )
              .catchError((e) => {print(e)});
              print(res);
         
          if (res != null && res == true) {/* 
             yield PhoneBookConversionSuccess(
              event.unConvertedContacts, event.currentIndex + 1); */
            Future.delayed(Duration(milliseconds: 300), () {

              add(PhoneBookConversionStarted(
                  event.unConvertedContacts, event.currentIndex + 1, isHardBackup:event.isHardBackup));
            });
          
          } else {
            yield PhoneBookConversionFailure();
          }
         }else{
          final res = await this
              .repository
              .convertPhoneBookContacts(
                  event.unConvertedContacts
                      .elementAt(event.currentIndex)
                      .originPhone,
                  event.unConvertedContacts
                      .elementAt(event.currentIndex)
                      .convertedPhone)
              .catchError((e) => {});
         
          if (res != null && res == true) {/* 
             yield PhoneBookConversionSuccess(
              event.unConvertedContacts, event.currentIndex + 1); */
            Future.delayed(Duration(milliseconds: 300), () {
              add(PhoneBookConversionStarted(
                  event.unConvertedContacts, event.currentIndex + 1));
            });
          
          } else {
            yield PhoneBookConversionFailure();
          }
         }
        } else {
          yield PhoneBookConversionDone();
        }
      } catch (e) {
        yield PhoneBookConversionFailure();
      }
    } else if (event is PhoneBookConversionRestored) {
      final List<BlouContact> revertedContacts =
          await this.repository.loadConvertedContactsFromContactService();
      if (revertedContacts != null && revertedContacts.isNotEmpty) {
        add(PhoneBookConversionAsked(revertedContacts));
      }
    } else if (event is PhoneBookConversionHardRestored) {
      final List<BlouContact> revertedContacts =
          await this.repository.loadConvertedContactsFromBackupStorage();
      if (revertedContacts != null && revertedContacts.isNotEmpty) {
        add(PhoneBookConversionAsked(revertedContacts, isHardBackup: true));
      } 
    }else if(event is PhoneBookConversionCleared){
      yield PhoneBookConversionInitial();
    }
  }
}
