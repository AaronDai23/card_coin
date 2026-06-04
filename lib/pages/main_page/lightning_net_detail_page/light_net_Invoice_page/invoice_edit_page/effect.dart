import 'package:card_coin/bean/invoice_info.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

Effect<InvoiceEditState>? buildEffect() {
  return combineEffects(<Object, Effect<InvoiceEditState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    InvoiceEditAction.loadFlashUnit: _onLoadFlashUnitAction,
    InvoiceEditAction.dropdownSelect: _onDropdownSelectAction,
    InvoiceEditAction.textChanged: _onTextChangedAction,
    InvoiceEditAction.pressed: _onPressedAction,
    InvoiceEditAction.uploadInvoice: _onLoadData
  });
}

void _onInit(Action action, Context<InvoiceEditState> ctx) {
  // CurrencyInfo info = ctx.state.bigCurrency;
  // if (info.address != null) {
  ctx.dispatch(InvoiceEditActionCreator.onLoadFlashUnit());
}

void _onDispose(Action action, Context<InvoiceEditState> ctx) {}

void _onLoadFlashUnitAction(
    Action action, Context<InvoiceEditState> ctx) async {
  Map<String, dynamic> parameters = {
    'code': 'BTC',
  };

  var invoiceResult = await HttpManager.getInstance()
      .get(NetworkAddress.getUnitsInfo, queryParameters: parameters);
  if (invoiceResult.isSuccess) {
    if (invoiceResult.data['unit'] != null) {
      ctx.state.unitInfos = <UnitInfo>[];
      List data = invoiceResult.data['unit'];
      print("unitInfos-data:$data");
      ctx.state.unitInfos = data.map((e) => UnitInfo.fromJson(e)).toList();
      ctx.state.unitInfos?.forEach((unitInfo) {
        print("object:${unitInfo.symbol}");
        ctx.state.units.add(unitInfo.symbol.toUpperCase());
      });

      print("unitInfos:${ctx.state.unitInfos}");
      try {
        ctx.state.mainUnitInfo = ctx.state.unitInfos!
            .firstWhere((element) => element.primary == true);
      } catch (error) {
        print('unitInfos21:$error');
      }

      if (ctx.state.mainUnitInfo == null) {
        ctx.state.mainUnitInfo = ctx.state.unitInfos![0];
        print('unitInfos222');
      } else {
        print('unitInfos333');
      }
      ctx.state.selectUnitInfo = ctx.state.mainUnitInfo;
      ctx.state.seletUnit = ctx.state.selectUnitInfo!.symbol;
      print("mainUnitInfo:${ctx.state.mainUnitInfo!.conversion}");
      ctx.state.usdtUnitInfo = ctx.state.unitInfos
          ?.firstWhere((element) => element.symbol.toUpperCase() == "USDT");
      print("usdtUnitInfo:${ctx.state.usdtUnitInfo!.conversion}");
      ctx.dispatch(InvoiceEditActionCreator.onLoadSuccess());
    }
  } else {
    print('unitInfoserror');
    ctx.dispatch(InvoiceEditActionCreator.onLoadFailed(invoiceResult.message));
  }
}

void _onTextChangedAction(Action action, Context<InvoiceEditState> ctx) async {
  String value = action.payload;
  ctx.state.curValue = value;
  if (value.isEmpty) {
    ctx.state.mount = "";
    ctx.state.errorTip = "";
    ctx.dispatch(InvoiceEditActionCreator.onUpdate());
    ctx.state.focusNode2.requestFocus();
    return;
  }
  final RegExp numberRegex = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
  if (!numberRegex.hasMatch(value)) {
    ctx.state.errorTip = "Please enter a valid number";
    ctx.state.mount = "";
    ctx.dispatch(InvoiceEditActionCreator.onUpdate());
    ctx.state.focusNode2.requestFocus();
    print("errorTip-_numberRegex:${ctx.state.errorTip}");
    return;
  }
  bool isDouble = double.tryParse(value) != null;
  if (isDouble) {
    if (double.tryParse(value)! > 100000000000) {
      ctx.state.errorTip = "Enter number is too large";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(InvoiceEditActionCreator.onUpdate());
      ctx.state.focusNode2.requestFocus();
      return;
    }
    if (double.tryParse(value)! <= 0) {
      ctx.state.errorTip = "Enter number is too small";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(InvoiceEditActionCreator.onUpdate());
      ctx.state.focusNode2.requestFocus();
      return;
    }

    if (value.contains(".")) {
      List list = value.split(".");
      String afterStr = list[1];
      print("input value:$afterStr");
      if (afterStr.length > 7) {
        ctx.state.errorTip = "Enter number has too many decimal places";
        ctx.state.mount = "";
        // setState(() {});
        ctx.dispatch(InvoiceEditActionCreator.onUpdate());
        ctx.state.focusNode2.requestFocus();
        return;
      }
    }

    double conversion = double.parse(ctx.state.usdtUnitInfo!.conversion) /
        double.parse(ctx.state.selectUnitInfo!.conversion);

    ctx.state.mount =
        NumberUtils.getCountBetweenTwoNumber(value, conversion.toString(), 2);
    ctx.state.errorTip = "";
    // setState(() {});
    ctx.dispatch(InvoiceEditActionCreator.onUpdate());
    ctx.state.focusNode2.requestFocus();
  } else {
    ctx.state.errorTip = "Please enter a valid number";
    ctx.state.mount = "";
    // setState(() {});
    ctx.dispatch(InvoiceEditActionCreator.onUpdate());
    ctx.state.focusNode2.requestFocus();
  }
}

void _onDropdownSelectAction(
    Action action, Context<InvoiceEditState> ctx) async {
  String newValue = action.payload;
  ctx.state.seletUnit = newValue;
  ctx.state.selectUnitInfo = ctx.state.unitInfos?.firstWhere(
      (element) => element.symbol.toUpperCase() == ctx.state.seletUnit);
  // 处理下拉选择事件
  print("selct value:$newValue");
  print("selct convation:${ctx.state.selectUnitInfo!.conversion.toString()}");
  _updateTipCount(action, ctx, ctx.state.curValue);
  // setState(() {});
  ctx.dispatch(InvoiceEditActionCreator.onUpdate());
}

void _updateTipCount(
    Action action, Context<InvoiceEditState> ctx, String value) {
  if (value.isEmpty) {
    ctx.state.mount = "";
    ctx.state.errorTip = "";
    return;
  }
  final RegExp numberRegex = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
  if (!numberRegex.hasMatch(value)) {
    ctx.state.errorTip = "Please enter a valid number";
    ctx.state.mount = "";
    return;
  }
  bool isDouble = double.tryParse(value) != null;
  if (isDouble) {
    if (double.tryParse(value)! > 100000000000) {
      ctx.state.errorTip = "Enter number is too large";
      ctx.state.mount = "";
      return;
    }
    if (double.tryParse(value)! <= 0) {
      ctx.state.errorTip = "Enter number is too small";
      ctx.state.mount = "";
      return;
    }

    double conversion = double.parse(ctx.state.usdtUnitInfo!.conversion) /
        double.parse(ctx.state.selectUnitInfo!.conversion);
    ctx.state.mount =
        NumberUtils.getCountBetweenTwoNumber(value, conversion.toString(), 2);
    ctx.state.errorTip = "";
  } else {
    ctx.state.errorTip = "Please enter a valid number";
    ctx.state.mount = "";
  }
}

void _onPressedAction(Action action, Context<InvoiceEditState> ctx) {
  if (ctx.state.errorTip.isNotEmpty) {
    print("_onPressedActionerrorTip:${ctx.state.errorTip}");
    return;
  }
  if (ctx.state.curValue.isEmpty) {
    // Navigator.of(ctx.context).pop(false);
    // Navigator.of(.context).pop(false);
    return;
  }

  if (double.tryParse(ctx.state.curValue)! < 0) {
    // Navigator.of(ctx.context).pop(false);
    // Navigator.of(context).pop(false);
    print("_onPressedtryParse-wrong:${ctx.state.errorTip}");
    return;
  }

  if (ctx.state.seletUnit.isNotEmpty) {
    print("select_unit:${ctx.state.seletUnit}");
    LocalStorage.saveString("select_unit", ctx.state.seletUnit);
    // html.window.localStorage['select_unit'] = seletUnit;
  }
  if (ctx.state.curValue.isNotEmpty) {
    if (ctx.state.curValue.contains(".")) {
      List list = ctx.state.curValue.split(".");
      String afterStr = list[1];
      if (afterStr.length > 7) {
        //  Navigator.of(context).pop(false);
        return;
      }
    }
    String newMount = ctx.state.curValue.replaceAll(',', '');
    print("mount22322:${ctx.state.mount},newMount:$newMount");
    LocalStorage.saveString("select_mount", newMount);
    LocalStorage.saveString("select_usdmount", ctx.state.mount);
    ctx.dispatch(InvoiceEditActionCreator.onUploadInvoice());
    // html.window.localStorage['select_mount'] = newMount;
    // html.window.localStorage['select_usdmount'] = mount;
  } else {
    // Navigator.of(ctx.context).pop(false);
    // Navigator.of(context).pop(false);
  }
}

Future<void> _onLoadData(Action action, Context<InvoiceEditState> ctx) async {
  Map<String, dynamic> parameters = {};
  String? selectMount = await LocalStorage.getString('select_mount');

  String? selectUnit = await LocalStorage.getString('select_unit');

  String resolvedUnit = selectUnit ?? "";
  print("show londingseletunit:$resolvedUnit");
  if (resolvedUnit.isNotEmpty) {
    parameters = {
      'amount': double.tryParse(selectMount ?? "0"),
      'uid': ctx.state.uid,
      'unit': resolvedUnit
    };
    print("parameters1:$parameters");
  } else {
    parameters = {
      'amount': 0,
      'uid': ctx.state.uid,
    };
    print("parameters2:$parameters");
  }

  HttpManager.getInstance()
      .post(NetworkAddress.invoiceUrl, null, data: parameters)
      .then((invoiceResult) {
    if (invoiceResult.isSuccess) {
      InvoiceInfo.fromJson(invoiceResult.data);
      Navigator.of(ctx.context).pop(true);
    } else {
      if (invoiceResult.code == 82005) {
        showToast(invoiceResult.message,
            duration: const Duration(milliseconds: 2000));
        LocalStorage.saveString('select_unit', '');
        LocalStorage.saveString('select_mount', '0');
        LocalStorage.saveString('select_usdmount', '0');
      } else {
        showToast(invoiceResult.message,
            duration: const Duration(milliseconds: 2000));
      }
    }
  });
}
