part of 'phone_converter_bloc.dart';

abstract class PhoneConverterState extends Equatable {
  const PhoneConverterState();
  
  @override
  List<Object> get props => [];
}

class PhoneConverterInitial extends PhoneConverterState {}
class PhoneConverterFailure extends PhoneConverterState {}
class PhoneConverterSuccess extends PhoneConverterState {
  final String phoneNumber;
  final String carrierName;
  const PhoneConverterSuccess(this.phoneNumber,{this.carrierName});
}
class PhoneListConverterSuccess extends PhoneConverterState {
  final List<BlouContact> contacts;
  const PhoneListConverterSuccess(this.contacts);
}
