part of 'phone_book_conversion_bloc.dart';

abstract class PhoneBookConversionState extends Equatable {
  const PhoneBookConversionState();
  
  @override
  List<Object> get props => [];
}

class PhoneBookConversionInitial extends PhoneBookConversionState {}
class PhoneBookConversionFailure extends PhoneBookConversionState {}
class PhoneBookConversionSuccess extends PhoneBookConversionState {
  final List<BlouContact> unConvertedContacts;
  final int currentIndex;
  PhoneBookConversionSuccess(this.unConvertedContacts,this.currentIndex);
}
class PhoneBookConversionDone extends PhoneBookConversionState {}
