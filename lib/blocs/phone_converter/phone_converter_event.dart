part of 'phone_converter_bloc.dart';

abstract class PhoneConverterEvent extends Equatable {
  const PhoneConverterEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberConvertionAsked extends PhoneConverterEvent {
  final String phoneNumber;
  PhoneNumberConvertionAsked(this.phoneNumber);
}
class PhoneNumberListConvertionAsked extends PhoneConverterEvent {
  final String contactIdentifier;
  final String originPhoneNumber;
  final String convertedPhoneNumber;
  PhoneNumberListConvertionAsked(this.contactIdentifier,this.originPhoneNumber, this.convertedPhoneNumber);
}
