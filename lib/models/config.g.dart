// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
    hasEndOnboarding: json['hasEndOnboarding'] as bool,
    encryptKey: json['encryptKey'] as String,
    userKey: json['userKey'] as String,
    unlockHash: json['unlockHash'] as String,
    unlocked: json['unlocked'] as bool,
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'hasEndOnboarding': instance.hasEndOnboarding,
      'encryptKey': instance.encryptKey,
      'userKey': instance.userKey,
      'unlockHash': instance.unlockHash,
      'unlocked': instance.unlocked,
    };
