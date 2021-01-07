import 'dart:convert';

import 'package:zocontact/models/blou_contact.dart';
import 'package:zocontact/utils/utils.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libphonenumber/libphonenumber.dart';

class ContactListRepository {
  final storage = new FlutterSecureStorage();
  final storageKey = StorageKeys.converted_contacts;
  final storageKeyBackup = StorageKeys.backuped_contacts;
  Future<List<BlouContact>> loadContacts(refreshed) async {
    List<BlouContact> blouContacts;
    List<BlouContact> blouContactsFromStorage = await readContactsFromStorage();
    if (refreshed == true) {
      blouContacts = await loadContactsFromContactService();
    } else if (blouContactsFromStorage == null &&
        blouContactsFromStorage.isEmpty) {
      blouContacts = await loadContactsFromContactService();
    } else {
      blouContacts = blouContactsFromStorage;
    }
    return blouContacts;
  }

  Future<List<BlouContact>> loadContactsFromContactService() async {
    List<BlouContact> blouContacts = [];
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    if (contacts != null && contacts.isNotEmpty) {
      for (final contact in contacts) {
        if (contact.phones.length > 0) {
          for (final phone in contact.phones) {
            if (phone.value != null && phone.value.isNotEmpty) {
              bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
                      phoneNumber: "${phone.value}", isoCode: 'CI')
                  .catchError((e) {
                return null;
              });
              String normalizedNumber =
                  await PhoneNumberUtil.normalizePhoneNumber(
                          phoneNumber: "${phone.value}", isoCode: 'CI')
                      .catchError((e) {
                return null;
              });
              if (normalizedNumber != null &&
                  normalizedNumber.startsWith("+225") &&
                  blouContacts.firstWhere(
                          (element) => element.phone == normalizedNumber,
                          orElse: () => null) ==
                      null &&
                  isValid != null) {
                String carrierName = await getCarrierName(normalizedNumber);
                PhoneNumberType phoneNumberType =
                    await PhoneNumberUtil.getNumberType(
                        phoneNumber: "${phone.value}", isoCode: 'CI');
                String convertedPhone = await getConvertedPhone(
                    carrierName, normalizedNumber, phoneNumberType);
                if (carrierName != null && carrierName.isNotEmpty) {
                  blouContacts.add(BlouContact(
                      id: contact.identifier,
                      displayName: contact.displayName,
                      phone: normalizedNumber,
                      originPhone: "${phone.value}",
                      avatar: contact.avatar != null
                          ? new String.fromCharCodes(contact.avatar)
                          : null,
                      familyName: contact.familyName,
                      givenName: contact.givenName,
                      convertedPhone: convertedPhone,
                      carrierName: carrierName,
                      phoneType: phoneNumberType == PhoneNumberType.mobile
                          ? "Mobile"
                          : phoneNumberType == PhoneNumberType.fixedLine
                              ? "fixe"
                              : "",
                      isSelected: false));
                }
              }
            }
          }
        }
      }
    }
    return Set.of(blouContacts).toList();
  }

  Future<List<BlouContact>> searchContacts(String query) async {
    List<BlouContact> blouContactsFromStorage = await readContactsFromStorage();
    if (blouContactsFromStorage.isNotEmpty) {
      final filtredResult = blouContactsFromStorage
          .where((element) =>
              element.displayName.toUpperCase().contains(query.toUpperCase()) ||
              element.familyName.toUpperCase().contains(query.toUpperCase()) ||
              element.givenName.toUpperCase().contains(query.toUpperCase()) ||
              element.phone.toUpperCase().contains(query.toUpperCase()))
          .toList();
      if (filtredResult.isNotEmpty) {
        return filtredResult;
      } else {
        List<BlouContact> blouContactsFromContactService =
            await loadContactsFromContactService();
        final filtredResult = blouContactsFromContactService
            .where((element) =>
                element.displayName
                    .toUpperCase()
                    .contains(query.toUpperCase()) ||
                element.familyName
                    .toUpperCase()
                    .contains(query.toUpperCase()) ||
                element.givenName.toUpperCase().contains(query.toUpperCase()) ||
                element.phone.toUpperCase().contains(query.toUpperCase()))
            .toList();
        return filtredResult;
      }
    } else {
      List<BlouContact> blouContactsFromContactService =
          await loadContactsFromContactService();
      final filtredResult = blouContactsFromContactService
          .where((element) =>
              element.displayName.toUpperCase().contains(query.toUpperCase()) ||
              element.familyName.toUpperCase().contains(query.toUpperCase()) ||
              element.givenName.toUpperCase().contains(query.toUpperCase()) ||
              element.phone.toUpperCase().contains(query.toUpperCase()))
          .toList();
      return filtredResult;
    }
  }

  Future<String> getCarrierName(String normalizedNumber) async {
    String carrierName = await PhoneNumberUtil.getNameForNumber(
            phoneNumber: normalizedNumber, isoCode: 'CI')
        .catchError((e) => null);
    var slitedPhone = normalizedNumber.split("+225");
    if (carrierName != null && carrierName.isNotEmpty) {
      return carrierName;
    } else if (slitedPhone.last.startsWith("07") ||
        slitedPhone.last.startsWith("08") ||
        slitedPhone.last.startsWith("09") ||
        slitedPhone.last.startsWith("47") ||
        slitedPhone.last.startsWith("48") ||
        slitedPhone.last.startsWith("49") ||
        slitedPhone.last.startsWith("57") ||
        slitedPhone.last.startsWith("58") ||
        slitedPhone.last.startsWith("59") ||
        slitedPhone.last.startsWith("67") ||
        slitedPhone.last.startsWith("68") ||
        slitedPhone.last.startsWith("69") ||
        slitedPhone.last.startsWith("77") ||
        slitedPhone.last.startsWith("78") ||
        slitedPhone.last.startsWith("79") ||
        slitedPhone.last.startsWith("87") ||
        slitedPhone.last.startsWith("88") ||
        slitedPhone.last.startsWith("89") ||
        slitedPhone.last.startsWith("97") ||
        slitedPhone.last.startsWith("98") ||
        slitedPhone.last.startsWith("99") ||
        slitedPhone.last.startsWith("202") ||
        slitedPhone.last.startsWith("203") ||
        slitedPhone.last.startsWith("212") ||
        slitedPhone.last.startsWith("213") ||
        slitedPhone.last.startsWith("215") ||
        slitedPhone.last.startsWith("217") ||
        slitedPhone.last.startsWith("224") ||
        slitedPhone.last.startsWith("225") ||
        slitedPhone.last.startsWith("234") ||
        slitedPhone.last.startsWith("235") ||
        slitedPhone.last.startsWith("243") ||
        slitedPhone.last.startsWith("244") ||
        slitedPhone.last.startsWith("245") ||
        slitedPhone.last.startsWith("306") ||
        slitedPhone.last.startsWith("316") ||
        slitedPhone.last.startsWith("319") ||
        slitedPhone.last.startsWith("327") ||
        slitedPhone.last.startsWith("337") ||
        slitedPhone.last.startsWith("347") ||
        slitedPhone.last.startsWith("359") ||
        slitedPhone.last.startsWith("368")) {
      if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
        return "Orange";
      } else {
        return "";
      }
    } else if (slitedPhone.last.startsWith("04") ||
        slitedPhone.last.startsWith("05") ||
        slitedPhone.last.startsWith("06") ||
        slitedPhone.last.startsWith("44") ||
        slitedPhone.last.startsWith("45") ||
        slitedPhone.last.startsWith("46") ||
        slitedPhone.last.startsWith("54") ||
        slitedPhone.last.startsWith("55") ||
        slitedPhone.last.startsWith("56") ||
        slitedPhone.last.startsWith("64") ||
        slitedPhone.last.startsWith("65") ||
        slitedPhone.last.startsWith("66") ||
        slitedPhone.last.startsWith("74") ||
        slitedPhone.last.startsWith("75") ||
        slitedPhone.last.startsWith("76") ||
        slitedPhone.last.startsWith("84") ||
        slitedPhone.last.startsWith("85") ||
        slitedPhone.last.startsWith("86") ||
        slitedPhone.last.startsWith("94") ||
        slitedPhone.last.startsWith("95") ||
        slitedPhone.last.startsWith("96") ||
        slitedPhone.last.startsWith("200") ||
        slitedPhone.last.startsWith("210") ||
        slitedPhone.last.startsWith("220") ||
        slitedPhone.last.startsWith("230") ||
        slitedPhone.last.startsWith("240") ||
        slitedPhone.last.startsWith("300") ||
        slitedPhone.last.startsWith("310") ||
        slitedPhone.last.startsWith("320") ||
        slitedPhone.last.startsWith("330") ||
        slitedPhone.last.startsWith("340") ||
        slitedPhone.last.startsWith("350") ||
        slitedPhone.last.startsWith("360")) {
      if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
        return "MTN";
      } else {
        return "";
      }
    } else if (slitedPhone.last.startsWith("01") ||
        slitedPhone.last.startsWith("02") ||
        slitedPhone.last.startsWith("03") ||
        slitedPhone.last.startsWith("40") ||
        slitedPhone.last.startsWith("41") ||
        slitedPhone.last.startsWith("42") ||
        slitedPhone.last.startsWith("43") ||
        slitedPhone.last.startsWith("50") ||
        slitedPhone.last.startsWith("51") ||
        slitedPhone.last.startsWith("52") ||
        slitedPhone.last.startsWith("53") ||
        slitedPhone.last.startsWith("61") ||
        slitedPhone.last.startsWith("62") ||
        slitedPhone.last.startsWith("63") ||
        slitedPhone.last.startsWith("71") ||
        slitedPhone.last.startsWith("72") ||
        slitedPhone.last.startsWith("73") ||
        slitedPhone.last.startsWith("81") ||
        slitedPhone.last.startsWith("82") ||
        slitedPhone.last.startsWith("83") ||
        slitedPhone.last.startsWith("90") ||
        slitedPhone.last.startsWith("91") ||
        slitedPhone.last.startsWith("92") ||
        slitedPhone.last.startsWith("93") ||
        slitedPhone.last.startsWith("208") ||
        slitedPhone.last.startsWith("218") ||
        slitedPhone.last.startsWith("228") ||
        slitedPhone.last.startsWith("238")) {
      if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
        return "Moov";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<String> getConvertedPhone(String carrierName, String normalizedNumber,
      PhoneNumberType phoneNumberType) async {
    if (phoneNumberType == PhoneNumberType.mobile) {
      switch (carrierName.toUpperCase()) {
        case "ORANGE":
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
            return "+22507${slitedPhone.last}";
          }
          return "";
        case "MTN":
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
            return "+22505${slitedPhone.last}";
          }
          return "";
        case "MOOV":
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
            return "+22501${slitedPhone.last}";
          }
          return "";

        default:
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.startsWith("07") ||
              slitedPhone.last.startsWith("08") ||
              slitedPhone.last.startsWith("09") ||
              slitedPhone.last.startsWith("47") ||
              slitedPhone.last.startsWith("48") ||
              slitedPhone.last.startsWith("49") ||
              slitedPhone.last.startsWith("57") ||
              slitedPhone.last.startsWith("58") ||
              slitedPhone.last.startsWith("59") ||
              slitedPhone.last.startsWith("67") ||
              slitedPhone.last.startsWith("68") ||
              slitedPhone.last.startsWith("69") ||
              slitedPhone.last.startsWith("77") ||
              slitedPhone.last.startsWith("78") ||
              slitedPhone.last.startsWith("79") ||
              slitedPhone.last.startsWith("87") ||
              slitedPhone.last.startsWith("88") ||
              slitedPhone.last.startsWith("89") ||
              slitedPhone.last.startsWith("97") ||
              slitedPhone.last.startsWith("98") ||
              slitedPhone.last.startsWith("99")) {
            if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
              return "+22507${slitedPhone.last}";
            } else {
              return "";
            }
          } else if (slitedPhone.last.startsWith("04") ||
              slitedPhone.last.startsWith("05") ||
              slitedPhone.last.startsWith("06") ||
              slitedPhone.last.startsWith("44") ||
              slitedPhone.last.startsWith("45") ||
              slitedPhone.last.startsWith("46") ||
              slitedPhone.last.startsWith("54") ||
              slitedPhone.last.startsWith("55") ||
              slitedPhone.last.startsWith("56") ||
              slitedPhone.last.startsWith("64") ||
              slitedPhone.last.startsWith("65") ||
              slitedPhone.last.startsWith("66") ||
              slitedPhone.last.startsWith("74") ||
              slitedPhone.last.startsWith("75") ||
              slitedPhone.last.startsWith("76") ||
              slitedPhone.last.startsWith("84") ||
              slitedPhone.last.startsWith("85") ||
              slitedPhone.last.startsWith("86") ||
              slitedPhone.last.startsWith("94") ||
              slitedPhone.last.startsWith("95") ||
              slitedPhone.last.startsWith("96")) {
            if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
              return "+22505${slitedPhone.last}";
            } else {
              return "";
            }
          } else if (slitedPhone.last.startsWith("01") ||
              slitedPhone.last.startsWith("02") ||
              slitedPhone.last.startsWith("03") ||
              slitedPhone.last.startsWith("40") ||
              slitedPhone.last.startsWith("41") ||
              slitedPhone.last.startsWith("42") ||
              slitedPhone.last.startsWith("43") ||
              slitedPhone.last.startsWith("50") ||
              slitedPhone.last.startsWith("51") ||
              slitedPhone.last.startsWith("52") ||
              slitedPhone.last.startsWith("53") ||
              slitedPhone.last.startsWith("61") ||
              slitedPhone.last.startsWith("62") ||
              slitedPhone.last.startsWith("63") ||
              slitedPhone.last.startsWith("71") ||
              slitedPhone.last.startsWith("72") ||
              slitedPhone.last.startsWith("73") ||
              slitedPhone.last.startsWith("81") ||
              slitedPhone.last.startsWith("82") ||
              slitedPhone.last.startsWith("83") ||
              slitedPhone.last.startsWith("90") ||
              slitedPhone.last.startsWith("91") ||
              slitedPhone.last.startsWith("92") ||
              slitedPhone.last.startsWith("93")) {
            if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
              return "+22501${slitedPhone.last}";
            } else {
              return "";
            }
          } else {
            return normalizedNumber;
          }
      }
    } else if (phoneNumberType == PhoneNumberType.fixedLine) {
      switch (carrierName.toUpperCase()) {
        case "ORANGE":
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
            return "+22527${slitedPhone.last}";
          }
          return "";

        case "MTN":
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
            return "+22525${slitedPhone.last}";
          }
          return "";
        case "MOOV":
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
            return "+22521${slitedPhone.last}";
          }
          return "";

        default:
          var slitedPhone = normalizedNumber.split("+225");
          if (slitedPhone.last.startsWith("202") ||
              slitedPhone.last.startsWith("203") ||
              slitedPhone.last.startsWith("212") ||
              slitedPhone.last.startsWith("213") ||
              slitedPhone.last.startsWith("215") ||
              slitedPhone.last.startsWith("217") ||
              slitedPhone.last.startsWith("224") ||
              slitedPhone.last.startsWith("225") ||
              slitedPhone.last.startsWith("234") ||
              slitedPhone.last.startsWith("235") ||
              slitedPhone.last.startsWith("243") ||
              slitedPhone.last.startsWith("244") ||
              slitedPhone.last.startsWith("245") ||
              slitedPhone.last.startsWith("306") ||
              slitedPhone.last.startsWith("316") ||
              slitedPhone.last.startsWith("319") ||
              slitedPhone.last.startsWith("327") ||
              slitedPhone.last.startsWith("337") ||
              slitedPhone.last.startsWith("347") ||
              slitedPhone.last.startsWith("359") ||
              slitedPhone.last.startsWith("368")) {
            if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
              return "+22527${slitedPhone.last}";
            } else {
              return "";
            }
          } else if (slitedPhone.last.startsWith("200") ||
              slitedPhone.last.startsWith("210") ||
              slitedPhone.last.startsWith("220") ||
              slitedPhone.last.startsWith("230") ||
              slitedPhone.last.startsWith("240") ||
              slitedPhone.last.startsWith("300") ||
              slitedPhone.last.startsWith("310") ||
              slitedPhone.last.startsWith("320") ||
              slitedPhone.last.startsWith("330") ||
              slitedPhone.last.startsWith("340") ||
              slitedPhone.last.startsWith("350") ||
              slitedPhone.last.startsWith("360")) {
            if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
              return "+22525${slitedPhone.last}";
            } else {
              return "";
            }
          } else if (slitedPhone.last.startsWith("208") ||
              slitedPhone.last.startsWith("218") ||
              slitedPhone.last.startsWith("228") ||
              slitedPhone.last.startsWith("238")) {
            if (slitedPhone.last.length == 8 || slitedPhone.last.length == 10) {
              return "+22521${slitedPhone.last}";
            } else {
              return "";
            }
          } else {
            return normalizedNumber;
          }
      }
    } else {
      return normalizedNumber;
    }
  }

  Future<bool> convertPhoneBookContacts(
      String originPhoneNumber, String convertedPhoneNumber) async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);

    final Contact contact = contacts.firstWhere(
        (element) =>
            element.phones.firstWhere(
                (element) => element.value == originPhoneNumber,
                orElse: () => null) !=
            null,
        orElse: () => null);
    //final Item phoneNumberItem = contact.phones.firstWhere((element) => element.value == originPhoneNumber);
    if (contact != null &&
        convertedPhoneNumber != null &&
        convertedPhoneNumber.isNotEmpty &&
        convertedPhoneNumber.length >= 8) {
      final int phoneNumberIndex = contact.phones
          .toList()
          .indexWhere((element) => element.value == originPhoneNumber);
      final Item phoneNumberItem = contact.phones.elementAt(phoneNumberIndex);
      final item =
          Item(label: phoneNumberItem.label, value: convertedPhoneNumber);
      List<Item> phones = contact.phones.toList();
      phones[phoneNumberIndex] = item;
      contact.phones = phones;
      return await ContactsService.updateContact(contact).then((res) {
        return true;
      }).catchError((e) => print(e));
    } else {
      return false;
    }
  }

  Future<bool> hardConvertPhoneBookContacts(BlouContact bloucontact) async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    final Contact contact = contacts.firstWhere(
        (element) => element.identifier == bloucontact.id,
        orElse: () => null);

    //final Item phoneNumberItem = contact.phones.firstWhere((element) => element.value == originPhoneNumber);
    if (contact != null) {
      final int phoneNumberIndex = contact.phones
          .toList()
          .indexWhere((element) => element.value.contains(bloucontact.phone));
      if (phoneNumberIndex != -1) {
        final Item phoneNumberItem = contact.phones.elementAt(phoneNumberIndex);
        final item =
            Item(label: phoneNumberItem.label, value: bloucontact.phone);
        List<Item> phones = contact.phones.toList();
        phones[phoneNumberIndex] = item;
        contact.phones = phones;
        print("length: ${phones.length}");
        var data = await ContactsService.updateContact(contact).then((res) {
          return true;
        });
        print("${contact.displayName} $data");

        return data;
      } else {
        List<Item> phones = [];
        final item = Item(label: 'mobile', value: bloucontact.phone);
        phones.add(item);
        contact.phones = phones;
        return await ContactsService.updateContact(contact).then((res) {
          return true;
        }).catchError((e) => print(e));
      }
    } else {
      return false;
    }
  }

  void writeContactsToStorage(List<BlouContact> blouContacts) async {
    final encodedData = json.encode(blouContacts);
    await storage.write(key: storageKey, value: encodedData);
    this.writeContactsToBackupStorage(blouContacts);
  }

  void writeContactsToBackupStorage(List<BlouContact> blouContacts) async {
    List<BlouContact> backup = await this.readBackupContactFromStorage();
    if (backup.isEmpty) {
      final encodedData = json.encode(blouContacts);
      await storage.write(key: storageKeyBackup, value: encodedData);
    }
  }

  Future<List<BlouContact>> readContactsFromStorage() async {
    List<BlouContact> blouContacts = [];
    final String dataString = await storage.read(key: storageKey);
    if (dataString != "null" && dataString != null && dataString.isNotEmpty) {
      List list = json.decode(dataString);
      blouContacts = list
          .map((item) {
            return BlouContact(
                id: item["id"],
                displayName: item["displayName"],
                phone: item["phone"],
                convertedPhone: item["convertedPhone"],
                avatar: item["avatar"],
                familyName: item["familyName"],
                givenName: item["givenName"],
                carrierName: item["carrierName"],
                phoneType: item["phoneType"],
                isSelected: item["isSelected"]);
          })
          .toList()
          .cast<BlouContact>();
    }
    return blouContacts;
  }

  Future<List<BlouContact>> readBackupContactFromStorage() async {
    List<BlouContact> blouContacts = [];
    final String dataString = await storage.read(key: storageKeyBackup);
    if (dataString != "null" && dataString != null && dataString.isNotEmpty) {
      List list = json.decode(dataString);
      blouContacts = list
          .map((item) {
            return BlouContact(
                id: item["id"],
                displayName: item["displayName"],
                phone: item["phone"],
                convertedPhone: item["convertedPhone"],
                avatar: item["avatar"],
                familyName: item["familyName"],
                givenName: item["givenName"],
                carrierName: item["carrierName"],
                phoneType: item["phoneType"],
                isSelected: item["isSelected"]);
          })
          .toList()
          .cast<BlouContact>();
    }
    return blouContacts;
  }

  Future<List<BlouContact>> loadConvertedContactsFromContactService() async {
    List<BlouContact> blouContacts = [];
    Iterable<Contact> contacts = await ContactsService.getContacts();
    if (contacts != null && contacts.isNotEmpty) {
      for (final contact in contacts) {
        if (contact.phones.length > 0) {
          for (final phone in contact.phones) {
            if (phone.value != null && phone.value.isNotEmpty) {
              String normalizedNumber =
                  await PhoneNumberUtil.normalizePhoneNumber(
                          phoneNumber: "${phone.value}", isoCode: 'CI')
                      .catchError((e) => null);
              bool isValid = await isConvertedContact("${phone.value}")
                  .catchError((e) => null);
              if (normalizedNumber != null && phone.value.startsWith("+225") ||
                  normalizedNumber != null && isValid != null) {
                String revertedPhone =
                    await getConvertedPhoneRevert(normalizedNumber);
                if (revertedPhone != null) {
                  blouContacts.add(BlouContact(
                      id: contact.identifier,
                      displayName: contact.displayName,
                      phone: normalizedNumber,
                      originPhone: "${phone.value}",
                      avatar: contact.avatar != null
                          ? new String.fromCharCodes(contact.avatar)
                          : null,
                      familyName: contact.familyName,
                      givenName: contact.givenName,
                      convertedPhone: revertedPhone));
                }
              }
            }
          }
        }
      }
    }
    return Set.of(blouContacts).toList();
  }

  Future<List<BlouContact>> loadConvertedContactsFromBackupStorage() async {
    List<BlouContact> blouContacts = [];
    List<BlouContact> contacts = await readBackupContactFromStorage();
    if (contacts != null && contacts.isNotEmpty) {
      for (final contact in contacts) {
        blouContacts.add(BlouContact(
            id: contact.id,
            displayName: contact.displayName,
            phone: contact.phone,
            originPhone: contact.originPhone,
            avatar: contact.avatar,
            familyName: contact.familyName,
            givenName: contact.givenName,
            convertedPhone: contact.originPhone));
      }
    }
    return blouContacts.toList();
  }

  Future<bool> isConvertedContact(String phoneNumber) async {
    bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
            phoneNumber: phoneNumber.substring(2), isoCode: 'CI')
        .catchError((e) => throw e);
    if (phoneNumber.length == 10 && isValid) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getConvertedPhoneRevert(String normalizedNumber) async {
    if (normalizedNumber != null) {
      var slitedPhone = normalizedNumber.split("+225");
      if (slitedPhone.last.length == 10) {
        return "+225${slitedPhone.last.substring(2)}";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
