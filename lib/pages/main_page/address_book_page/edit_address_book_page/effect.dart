import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<EditAddressBookState>? buildEffect() {
  return combineEffects(<Object, Effect<EditAddressBookState>>{
    EditAddressBookAction.onSave: _onSave,
    EditAddressBookAction.action: _onAction,
  });
}

void _onSave(Action action, Context<EditAddressBookState> ctx) {
  final name = ctx.state.nameController.text.trim();
  final address = ctx.state.addressController.text.trim();
  final remark = ctx.state.remarkController.text.trim();
  var lang = ctx.state.languageResource!;
  if (name.isEmpty) {
    showToast(lang.addressNameEmpty);
    return;
  }
  if (address.isEmpty) {
    showToast(lang.addressEmpty);
    return;
  }
  final map = {'name': name, 'address': address, 'remark': remark};
  Navigator.of(ctx.context).pop(map);
}

void _onAction(Action action, Context<EditAddressBookState> ctx) {}
