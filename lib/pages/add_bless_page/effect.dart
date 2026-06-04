import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

Effect<AddBlessState>? buildEffect() {
  return combineEffects(<Object, Effect<AddBlessState>>{
    AddBlessAction.action: _onAction,
    AddBlessAction.send: _onSend,
    AddBlessAction.selectCard: _onSelectCard,
  });
}

void _onAction(Action action, Context<AddBlessState> ctx) {}

Future<void> _onSend(Action action, Context<AddBlessState> ctx) async {
  final bless = ctx.state.blessController.text;
  final cardNumber = ctx.state.amountController.text;

  if (bless.isEmpty) {
    ScaffoldMessenger.of(ctx.context)
        .showSnackBar(const SnackBar(content: Text("Message cannot be empty")));
    return;
  }

  if (cardNumber.isEmpty) {
    showToast("Receiver Card Number cannot be empty");
    return;
  }

  var receiveUid = ctx.state.selectedCard.uid;

  // var resultData = await HttpManager.getInstance().get(
  //     NetworkAddress.smartCardCardNumberPage,
  //     queryParameters: {'cardNo': cardNumber});

  // if (resultData.isSuccess) {
  //   var list = resultData.data['rows'] as List;
  //   if (list.isEmpty) {
  //     showToast("Receiver Card Number does not exist");
  //     return;
  //   }
  //   receiveUid = list[0]['uid'];
  // } else {
  //   showToast("Failed to check Receiver Card Number");
  //   return;
  // }

  print("祝福语: $bless");
  print("接收人卡号: $cardNumber, 接收人uid: $receiveUid");
  var senderUid = await LocalStorage.getCardUuid();
  var resultData1 = await HttpManager.getInstance().post(
      NetworkAddress.chainStampPersonalCreate, null,
      data: {'uid': receiveUid, 'message': bless, "senderUid": senderUid});
  if (resultData1.isSuccess) {
    showToast("Message sent successfully");
    Navigator.of(ctx.context).pop();
  } else {
    showToast("Failed to send message");
  }
  // TODO: 这里写你提交逻辑
  //
}

void _onSelectCard(Action action, Context<AddBlessState> ctx) {
  ctx.state.selectedCard = action.payload;
}
