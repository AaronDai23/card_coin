import 'package:card_coin/bean/address_book_info.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<AddressBookState>? buildEffect() {
  return combineEffects(<Object, Effect<AddressBookState>>{
    Lifecycle.initState: _onInit,
    AddressBookAction.onAdd: _onAdd,
    AddressBookAction.onEdit: _onEdit,
    AddressBookAction.onDelete: _onDelete,
    AddressBookAction.onCopyAddress: _onCopyAddress,
  });
}

Future<void> _onInit(Action action, Context<AddressBookState> ctx) async {
  List<AddressBookInfo> items = await LocalStorage.getAddressBookInfoList();
  ctx.dispatch(AddressBookActionCreator.onInit(items));
}

Future<void> _onAdd(Action action, Context<AddressBookState> ctx) async {
  var result = await Navigator.pushNamed(ctx.context, 'editAddressBookPage');

  if (result == null) return;
  result as Map<String, dynamic>;
  List<AddressBookInfo> items = ctx.state.items.toList();
  items.insert(
      0,
      AddressBookInfo(
        name: result['name'],
        address: result['address'],
        remark: result['remark'],
      ));
  ctx.dispatch(AddressBookActionCreator.onUpdateItems(items));
  await LocalStorage.saveAddressBookInfoList(items);
}

Future<void> _onEdit(Action action, Context<AddressBookState> ctx) async {
  int index = action.payload;
  List<AddressBookInfo> items = ctx.state.items.toList();
  var result =
      await Navigator.pushNamed(ctx.context, 'editAddressBookPage', arguments: {
    'name': items[index].name,
    'address': items[index].address,
    'remark': items[index].remark
  });
  if (result == null) return;
  result as Map<String, dynamic>;
  items[index] = items[index].copy(
    name: result['name'],
    address: result['address'],
    remark: result['remark'],
  );
  ctx.dispatch(AddressBookActionCreator.onUpdateItems(items));
  await LocalStorage.saveAddressBookInfoList(items);
}

Future<void> _onDelete(Action action, Context<AddressBookState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  int index = action.payload;
  List<AddressBookInfo> items = ctx.state.items.toList();
  bool? value = await showDialog(
    context: ctx.context,
    builder: (_) {
      return ZenggeTextAlertDialog(
        languageResource.getDeleteAddressTips(items[index].name),
        enableCancel: true,
      );
    },
  );
  if (value == null || value == false) return;
  items.removeAt(index);
  ctx.dispatch(AddressBookActionCreator.onUpdateItems(items));
  await LocalStorage.saveAddressBookInfoList(items);
}

void _onCopyAddress(Action action, Context<AddressBookState> ctx) {
  String value = action.payload;
  var languageResource = ctx.state.languageResource!;
  Clipboard.setData(ClipboardData(text: value));
  showToast(languageResource.copySuccess);
}
