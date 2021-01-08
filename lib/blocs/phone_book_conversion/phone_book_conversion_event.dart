part of 'phone_book_conversion_bloc.dart';

abstract class PhoneBookConversionEvent extends Equatable {
  const PhoneBookConversionEvent();

  @override
  List<Object> get props => [];
}

class PhoneBookConversionAsked extends PhoneBookConversionEvent {
  final List<BlouContact> unConvertedContacts;
  final bool isHardBackup;
  PhoneBookConversionAsked(this.unConvertedContacts, {this.isHardBackup});
}

class PhoneBookConversionRestored extends PhoneBookConversionEvent {
  PhoneBookConversionRestored();
}

class PhoneBookConversionHardRestored extends PhoneBookConversionEvent {
  PhoneBookConversionHardRestored();
}

class PhoneBookConversionCleared extends PhoneBookConversionEvent {
  PhoneBookConversionCleared();
}

class PhoneBookConversionStarted extends PhoneBookConversionEvent {
  final List<BlouContact> unConvertedContacts;
  final int currentIndex;
  final bool isHardBackup;
  PhoneBookConversionStarted(this.unConvertedContacts, this.currentIndex,
      {this.isHardBackup});
}
