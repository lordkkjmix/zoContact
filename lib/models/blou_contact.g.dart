// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blou_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlouContact _$BlouContactFromJson(Map<String, dynamic> json) {
  return BlouContact(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      phone: json['phone'] as String,
      originPhone: json['originPhone'] as String,
      convertedPhone: json['convertedPhone'] as String,
      avatar: json['avatar'] as String,
      familyName: json['familyName'] as String,
      givenName: json['givenName'] as String,
      carrierName: json['carrierName'] as String,
      phoneType: json['phoneType'] as String,
      isSelected: json['isSelected'] as bool);
}

Map<String, dynamic> _$BlouContactToJson(BlouContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'phone': instance.phone,
      'originPhone': instance.originPhone,
      'convertedPhone': instance.convertedPhone,
      'avatar': instance.avatar,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'carrierName': instance.carrierName,
      'phoneType': instance.phoneType,
      'isSelected': instance.isSelected
    };
