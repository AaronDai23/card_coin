import 'dart:async';

import 'package:card_coin/bean/invoice_info.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'action.dart';
import 'state.dart';
import 'package:flutter/material.dart' hide Action;

Effect<LightNetInvoiceState>? buildEffect() {
  return combineEffects(<Object, Effect<LightNetInvoiceState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    LightNetInvoiceAction.editAction: _editAction,
    LightNetInvoiceAction.copy: _copyAction,
    LightNetInvoiceAction.loadData: _onLoadData,
  });
}

void _onInit(Action action, Context<LightNetInvoiceState> ctx) {
  // CurrencyInfo info = ctx.state.bigCurrency;
  // if (info.address != null) {
  ctx.dispatch(LightNetInvoiceActionCreator.onLoadData());
  startTime(ctx);
}

void _onDispose(Action action, Context<LightNetInvoiceState> ctx) {
  cancleTimer(ctx);
}

Future<void> _onLoadData(
    Action action, Context<LightNetInvoiceState> ctx) async {
  Map<String, dynamic> parameters = {};
  String? selectMount = await LocalStorage.getString('select_mount');
  if (selectMount != null) {
    ctx.state.select_mount = selectMount;
  }

  String? selectUnit = await LocalStorage.getString('select_unit');
  if (selectUnit != null) {
    ctx.state.select_unit = selectUnit;
  }
  String resolvedUnit = ctx.state.select_unit;
  print("show londingseletunit:$resolvedUnit");
  if (resolvedUnit.isNotEmpty) {
    parameters = {
      'amount': double.tryParse(ctx.state.select_mount),
      'uid': ctx.state.uid,
      'unit': resolvedUnit
    };
    print("parameters2:$parameters");
  }

  HttpManager.getInstance()
      .post(NetworkAddress.invoiceUrl, null, data: parameters)
      .then((invoiceResult) {
    if (invoiceResult.isSuccess) {
      InvoiceInfo invoiceInfo = InvoiceInfo.fromJson(invoiceResult.data);
      QrCode qrCode = QrCode.fromData(
        data: invoiceInfo.invoiceUrl,
        errorCorrectLevel: QrErrorCorrectLevel.H,
      );

      QrImage qrImage = QrImage(qrCode);
      ctx.state.qrImage = qrImage;
      ctx.dispatch(LightNetInvoiceActionCreator.onLoadSuccess(invoiceInfo));
    } else {
      if (invoiceResult.code == 82005) {
        showToast(invoiceResult.message,
            duration: const Duration(milliseconds: 2000));

        ctx.state.select_mount = "0";
        ctx.state.select_unit = "";
        LocalStorage.saveString('select_unit', '');
        LocalStorage.saveString('select_mount', '0');
        LocalStorage.saveString('select_usdmount', '0');
      } else {
        ctx.dispatch(
            LightNetInvoiceActionCreator.onLoadFailed(invoiceResult.message));
      }
    }
  });
}

Future<void> _editAction(
    Action action, Context<LightNetInvoiceState> ctx) async {
  cancleTimer(ctx);
  var result = await Navigator.of(ctx.context)
      .pushNamed('invoiceEditPage', arguments: {'uid': ctx.state.uid});
  if (result == true) {
    print("html.window.loca1");
    // html.window.location =
    //     html.window.document.rootElement;
    // html.window.location.reload();
    String? selectMount = await LocalStorage.getString('select_mount');
    if (selectMount != null) {
      ctx.state.select_mount = selectMount;
    }

    String? selectUnit = await LocalStorage.getString('select_unit');
    if (selectUnit != null) {
      ctx.state.select_unit = selectUnit;
    }
    ctx.dispatch(LightNetInvoiceActionCreator.onLoadData());
    startTime(ctx);
  } else {
    print('show londingerror');
    // if (networkResult.code == 82005) {
    //   // EasyLoading.showToast("${networkResult.message}",
    //   //     duration: Duration(seconds: 2));

    //   ctx.state.select_mount = "0";
    //   ctx.state.select_unit = "";
    //   LocalStorage.saveString('select_unit','');
    //   LocalStorage.saveString('select_mount','0');
    //   LocalStorage.saveString('select_usdmount','0');
    //   // html.window.localStorage['select_unit'] = "";
    //   // html.window.localStorage['select_mount'] = "0";
    //   // html.window.localStorage['select_usdmount'] = "0";
    // } else {
    //   // Tost
    //   // EasyLoading.showToast(
    //   //     "errorcode:${networkResult.code},message:${networkResult.message}",
    //   //     duration: Duration(seconds: 2));
    // }
    // 两秒后执行的代码
    // print(
    //     "QrCodeStatus_networkR2222esult is  errorcode:${networkResult.code},message:${networkResult.message}");
    // }
  }
  startTime(ctx);
}

void _copyAction(Action action, Context<LightNetInvoiceState> ctx) {
  Clipboard.setData(ClipboardData(text: ctx.state.invoiceInfo!.invoiceUrl));
  showToast("Copy success");
}

void startTime(Context<LightNetInvoiceState> ctx) {
  const oneSec = Duration(seconds: 1);
  if (ctx.state.timer != null) {
    ctx.state.timer!.cancel();
  }

  ctx.state.timer = Timer.periodic(oneSec, (Timer timer) {
    ctx.state.seconds--;
    print("invoice second:${ctx.state.timer}");
    if (ctx.state.seconds == 0) {
      // _loadCurrencyInfo(currentIndex);
      ctx.state.seconds = 60;
      print("_home _loadCurrencyInfo start");
    }
  });
}

void cancleTimer(Context<LightNetInvoiceState> ctx) {
  if (ctx.state.timer != null) {
    ctx.state.timer!.cancel();
  }
}
