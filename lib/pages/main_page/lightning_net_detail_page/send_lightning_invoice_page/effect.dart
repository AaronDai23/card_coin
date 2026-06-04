import 'dart:async';

import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/bean/lightning_sign_info.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/bean/send_invoice_info.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<SendLightningInvoiceState>? buildEffect() {
  return combineEffects(<Object, Effect<SendLightningInvoiceState>>{
    Lifecycle.dispose: _onDispose,
    SendLightningInvoiceAction.action: _onAction,
    SendLightningInvoiceAction.scanQRCode: _onScanQRCode,
    SendLightningInvoiceAction.validateAddress: _onValidateAddress,
    SendLightningInvoiceAction.sendClick: _onSendClick,
  });
}

Future<void> _onDispose(
    Action action, Context<SendLightningInvoiceState> ctx) async {
  ctx.state.validateTimer?.cancel();
}

void _onAction(Action action, Context<SendLightningInvoiceState> ctx) {}

Future<void> _onSendClick(
    Action action, Context<SendLightningInvoiceState> ctx) async {
  if (ctx.state.invoiceInfo!.primaryBalance >
      num.tryParse(ctx.state.flashBalanceDetail.amountValue)!) {
    showToast('余额不足!');
    return;
  }

  final pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance().post(
      NetworkAddress.lightningSignMessageUrl, null,
      data: {'uid': ctx.state.uid, 'signType': 'SEND_PAYMENT'});

  if (result.isSuccess) {
    var signInfo = LightningSignInfo.fromJson(result.data);
    String signedHex;
    try {
      signedHex = await BlockchainPlatform.instance
          .signLightning(signInfo.signMessage, true);
    } catch (error) {
      pr.hide();
      if (error is! PlatformException) {
        showToast(error.toString());
      }

      return;
    }

    var publicKey = await BlockchainPlatform.instance.getBitcoinPublicKey();

    String invoiceAddress = ctx.state.invoiceController.text;

    final params = {
      'uid': ctx.state.uid,
      'signId': signInfo.signId,
      'publicKey': publicKey,
      'signResult': signedHex,
      'invoice': invoiceAddress,
    };

    var paymentResult = await HttpManager.getInstance()
        .post(NetworkAddress.lightningPaymentUrl, null, data: params);
    pr.hide();
    if (paymentResult.isSuccess) {
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return const ZenggeTextAlertDialog('Send successfull！');
          });

      Navigator.of(ctx.context).pop();
    } else {
      pr.hide();
      showToast(paymentResult.message);
    }
  } else {
    pr.hide();
    showToast(result.message);
  }
}

Future<void> _onScanQRCode(
    Action action, Context<SendLightningInvoiceState> ctx) async {
  var result = await Navigator.of(ctx.context).pushNamed('scanQrcodePage');
  if (result != null) {
    String address = result.toString();
    ctx.state.invoiceController.text = address;
    ctx.dispatch(SendLightningInvoiceActionCreator.onValidateAddress(address));
  }
}

Future<void> _onValidateAddress(
    Action action, Context<SendLightningInvoiceState> ctx) async {
  ctx.state.validateTimer?.cancel();
  ctx.state.validateTimer =
      Timer.periodic(const Duration(seconds: 1), (timer) async {
    timer.cancel();
    ctx.dispatch(SendLightningInvoiceActionCreator.onUpdateLoading(true));
    String address = action.payload;
    HttpManager.getInstance().post(NetworkAddress.validateInvoiceUrl, null,
        data: {'invoice': address}).then((response) {
      if (response.isSuccess) {
        var invoiceInfo = SendInvoiceInfo.fromJson(response.data);
        ctx.dispatch(
            SendLightningInvoiceActionCreator.onUpdateInvoiceInfo(invoiceInfo));
      } else {
        ctx.state.isLoading = false;
        ctx.dispatch(
            SendLightningInvoiceActionCreator.onUpdateInvoiceInfo(null));
        showToast('地址格式错误');
      }
    });
  });
}
