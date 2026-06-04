import 'package:card_coin/bean/address_book_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class AddressBookState extends LoadPageState<AddressBookState> {
  List<AddressBookInfo> items = [];
  String? title;
  @override
  AddressBookState clone() {
    return AddressBookState()
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..title = title
      ..items = items;
  }
}

AddressBookState initState(Map<String, dynamic>? args) {
  return AddressBookState()..title = args?['title'];
}
