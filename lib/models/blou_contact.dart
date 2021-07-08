import 'package:json_annotation/json_annotation.dart';
part 'blou_contact.g.dart';

@JsonSerializable(nullable: true)
class BlouContact {
  final String id;
  final String displayName;
  final String phone;
  final String originPhone;
  final String convertedPhone;
  final String avatar;
  final String familyName;
  final String givenName;
  final String carrierName;
  final String phoneType;
  final bool isSelected;

  const BlouContact(
      {this.id,
      this.displayName,
      this.phone,
      this.originPhone,
      this.convertedPhone,
      this.avatar,
      this.familyName,
      this.givenName,
      this.carrierName,
      this.phoneType,
      this.isSelected});

  factory BlouContact.fromJson(Map<String, dynamic> json) =>
      _$BlouContactFromJson(json);
  Map<String, dynamic> toJson() => _$BlouContactToJson(this);

  @override
  String toString() {
    return _$BlouContactToJson(this).toString();
  }

  BlouContact copyWith(
      {final String id,
      final String displayName,
      final String phone,
      final String originPhone,
      final String convertedPhone,
      final String avatar,
      final String familyName,
      final String givenName,
      final String carrierName,
      final String phoneType,
      final bool isSelected}) {
    return BlouContact(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        phone: phone ?? this.phone,
        originPhone: originPhone ?? this.originPhone,
        convertedPhone: convertedPhone ?? this.convertedPhone,
        avatar: avatar ?? this.avatar,
        familyName: familyName ?? this.familyName,
        givenName: givenName ?? this.givenName,
        carrierName: carrierName ?? this.carrierName,
        phoneType: phoneType ?? this.phoneType,
        isSelected: isSelected ?? this.isSelected);
  }
}
