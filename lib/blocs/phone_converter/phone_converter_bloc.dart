import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:zocontact/models/models.dart';
import 'package:zocontact/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:libphonenumber/libphonenumber.dart';

part 'phone_converter_event.dart';
part 'phone_converter_state.dart';

class PhoneConverterBloc
    extends Bloc<PhoneConverterEvent, PhoneConverterState> {
  final ContactListRepository repository;
  PhoneConverterBloc({this.repository}) : super(PhoneConverterInitial());

  @override
  Stream<PhoneConverterState> mapEventToState(
    PhoneConverterEvent event,
  ) async* {
    if (event is PhoneNumberConvertionAsked) {
      bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: event.phoneNumber, isoCode: 'CI');
      if (isValid) {
        String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
            phoneNumber: event.phoneNumber, isoCode: 'CI');
        String carrierName =
            await this.repository.getCarrierName(normalizedNumber);
        PhoneNumberType phoneNumberType = await PhoneNumberUtil.getNumberType(
            phoneNumber: event.phoneNumber, isoCode: 'CI');
        String convertedPhoneNumber = await this
            .repository
            .getConvertedPhone(carrierName, normalizedNumber, phoneNumberType);
        yield PhoneConverterSuccess(convertedPhoneNumber,carrierName:carrierName);
      }else if(event is PhoneNumberListConvertionAsked){
        }else{
        yield PhoneConverterFailure();
      }
    }
  }
}
