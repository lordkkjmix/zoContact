import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:zocontact/models/models.dart';
import 'package:zocontact/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
//import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class ConfigRepository {
  final storage = new FlutterSecureStorage();
  final storageKey = StorageKeys.config;
  ConfigRepository();
  void writeConfigToStorage(Config config) async {
    await storage.write(key: storageKey, value: json.encode(config));
  }

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<Config> readConfigFromStorage() async {
    final String data = await storage.read(key: storageKey);
    final Map<String, dynamic> settings = await getRemoteSetting();
    if (data != "null" && data != null && data.isNotEmpty) {
      Map<String, dynamic> oldConfig = json.decode(data);
      Config currentConfig = Config.fromJson(oldConfig);
      if (currentConfig.unlocked == true) {
        if (currentConfig.enabledDonation == null) {
          this.writeConfigToStorage(Config(
              hasEndOnboarding: currentConfig.hasEndOnboarding,
              encryptKey: currentConfig.encryptKey,
              userKey: currentConfig.userKey,
              unlockHash: currentConfig.unlockHash,
              unlocked: currentConfig.unlocked,
              enabledDonation: settings["enabledDonation"] != null
                  ? settings["enabledDonation"]
                  : false));
          return Config(
              hasEndOnboarding: currentConfig.hasEndOnboarding,
              encryptKey: currentConfig.encryptKey,
              userKey: currentConfig.userKey,
              unlockHash: currentConfig.unlockHash,
              unlocked: currentConfig.unlocked,
              enabledDonation: settings["enabledDonation"] != null
                  ? settings["enabledDonation"]
                  : false);
        } else {
          return currentConfig;
        }
      } else {
        return Config(
          hasEndOnboarding: currentConfig.hasEndOnboarding,
          encryptKey: StorageKeys.encryptionKey,
          userKey: currentConfig.userKey,
          unlockHash: currentConfig.unlockHash,
          unlocked: settings["unlocked"],
          enabledDonation: settings["enabledDonation"],
        );
      }
    } else {
      final userKey = getRandomString(5);
      final String encodeKey = "${userKey}_${StorageKeys.encryptionKey}";
      final String hashkey = generateMd5(encodeKey);
      return Config(
        hasEndOnboarding: false,
        encryptKey: StorageKeys.encryptionKey,
        userKey: userKey,
        unlockHash: hashkey,
        unlocked: settings["unlocked"],
        enabledDonation: settings["enabledDonation"],
      );
    }
  }

  Future<Map<String, dynamic>> getRemoteSetting() async {
    try {
      Response response = await Dio().get("https://bloucontact.page.link/ghHK");
      if (response != null && response.statusCode == 200) {
        var list = json.decode(response.data);
        Map<String, dynamic> data = {
          "unlocked": Platform.isAndroid
              ? list["unlocked"] == true || list["unlocked"] == "true"
                  ? true
                  : false
              : list["unlockedIos"] == true || list["unlockedIos"] == "true"
                  ? true
                  : false,
          "enabledDonation": list["enabledDonation"] == true ||
                  list["enabledDonation"] == "true"
              ? true
              : false,
        };
        return data;
      } else {
        return {"unlocked": false, "enabledDonation": true};
      }
    } catch (e) {
      return {"unlocked": false, "enabledDonation": true};
    }
  }

  void clearAppConfigFromStorage() async {
    await storage.delete(key: this.storageKey);
  }

  Future<bool> activationVerification(
      String userKey, String activationKey) async {
    if (userKey.isNotEmpty && activationKey.isNotEmpty) {
      final String encodeKey = "${userKey}_${StorageKeys.encryptionKey}";
      final String hashkey = generateMd5(encodeKey);
      final String extractedActivationKey =
          hashkey.substring(hashkey.length - 5);
      if (activationKey.toLowerCase() == extractedActivationKey.toLowerCase()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
