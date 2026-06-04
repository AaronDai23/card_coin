import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/cupertino.dart';

class EditAddressBookState implements GlobalBaseState<EditAddressBookState> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController remarkController;
  bool isAdd = true;

  @override
  EditAddressBookState clone() {
    return EditAddressBookState()
      ..nameController = nameController
      ..addressController = addressController
      ..remarkController = remarkController
      ..languageResource = languageResource
      ..isAdd = isAdd
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

EditAddressBookState initState(Map<String, dynamic>? args) {
  String name = args?['name'] ?? '';
  String address = args?['address'] ?? '';
  String remark = args?['remark'] ?? '';
  bool isAdd = true;
  if (name.isNotEmpty || address.isNotEmpty || remark.isNotEmpty) {
    isAdd = false;
  }
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController addressController =
      TextEditingController(text: address);
  TextEditingController remarkController = TextEditingController(text: remark);
  return EditAddressBookState()
    ..isAdd = isAdd
    ..nameController = nameController
    ..addressController = addressController
    ..remarkController = remarkController;
}
