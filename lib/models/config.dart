import 'package:json_annotation/json_annotation.dart';
part 'config.g.dart';

@JsonSerializable(nullable: true)
class Config {
  final bool hasEndOnboarding;
  final String encryptKey;
  final String userKey;
  final String unlockHash;
  final bool unlocked;
  final bool enabledDonation;

  Config(
      {this.hasEndOnboarding,
      this.encryptKey,
      this.userKey,
      this.unlockHash,
      this.unlocked,
      this.enabledDonation});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  @override
  String toString() {
    return _$ConfigToJson(this).toString();
  }

  Config copyWith(
      {final bool hasEndOnboarding,
      final String encryptKey,
      final String deviceImei,
      final String userKey,
      final String unlockHash,
      final bool unlocked,
      final bool enabledDonation}) {
    return Config(
      hasEndOnboarding: hasEndOnboarding ?? this.hasEndOnboarding,
      encryptKey: encryptKey ?? this.encryptKey,
      userKey: userKey ?? this.userKey,
      unlockHash: unlockHash ?? this.unlockHash,
      unlocked: unlocked ?? this.unlocked,
      enabledDonation: enabledDonation ?? this.enabledDonation,
    );
  }
}
