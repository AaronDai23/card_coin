import 'dart:async';
import 'dart:io';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/dialogs.dart';
import 'package:card_coin/utils/runnable/reset_card_runnable.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:oktoast/oktoast.dart';

import '../../../utils/scan_util.dart';
import 'action.dart';
import 'reset_card_dialog_page/page.dart';
import 'state.dart';

Effect<ResetFactorySettingsState>? buildEffect() {
  return combineEffects(<Object, Effect<ResetFactorySettingsState>>{
    Lifecycle.initState: _onInit,
    ResetFactorySettingsAction.onResetCard: _onResetCard,
    ResetFactorySettingsAction.onRealResetCard: _onRealResetCard,
    ResetFactorySettingsAction.oniOSResetCard: _oniOSScanSendResetCommand,
    ResetFactorySettingsAction.sendResetCommand: _onSendResetCommand
  });
}

void _onInit(Action action, Context<ResetFactorySettingsState> ctx) async {
  // ctx.dispatch(ResetInfoActionCreator.onLoadCardInfo());
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
}

Future<void> _onResetCard(
    Action action, Context<ResetFactorySettingsState> ctx) async {
  if (Platform.isIOS && !ctx.state.isPinSet) {
    print('_onResetCard');

    ctx.dispatch(ResetFactorySettingsActionCreator.oniOSRetsetCard());
    return;
  }
  String? pwd = "";
  if (ctx.state.isPinSet) {
    print('_onResetCard-showInput');
    List<int>? pinCode = await _onShowPinCodeDialog(ctx);
    if (pinCode == null || pinCode.isEmpty) {
      return;
    }
    pwd = pinCode.join();
  }
  if (Platform.isAndroid) {
    ScanResponse? result = await showModalBottomSheet<ScanResponse>(
      context: ctx.context,
      isDismissible: true,
      enableDrag: false,
      builder: (_) {
        return ResetCardDialogPage().buildPage({
          'cardId': ctx.state.cardId,
          'isPinSet': false,
          'languageResource': ctx.state.languageResource,
          'pwd': pwd,
          'cardNo': ctx.state.cardNo,
        });
      },
    );

    print('showModalBottomSheet result:$result');
    if (result != null) {
      if (result.isSuccess) {
        ctx.dispatch(ResetFactorySettingsActionCreator.onRealResetCard());
      } else {
        showToast(result.message ?? '');
      }
    }
  } else {
    if (pwd.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        ctx.state.pwd = pwd!;
        ctx.dispatch(ResetFactorySettingsActionCreator.oniOSRetsetCard());
      });
    }
  }
}

Future<List<int>?> _onShowPinCodeDialog(
    Context<ResetFactorySettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  List<int>? pinCode = [];
  pinCode = await Dialogs.showPinInputDialog(
      languageResource: languageResource,
      context: ctx.context,
      title: languageResource.inputPinCode);
  return pinCode;
}

Future<void> _onRealResetCard(
    Action action, Context<ResetFactorySettingsState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  String? cardUuid = await LocalStorage.getCardUuid();
  final stringList =
      await LocalStorage.getStringList(LocalStorage.cardInfoList + cardUuid!);
  if (stringList != null) {
    stringList.removeWhere((element) => element.contains(ctx.state.cardId));
    LocalStorage.remove(LocalStorage.cardInfoList + cardUuid);
  }

  ///清除原生本地缓存数据
  BlockchainPlatform.instance.clearLocalCurrency(ctx.state.cardId, []);
  await LocalStorage.remove(LocalStorage.cardInfo + ctx.state.cardId);
  String keyBTCInit = "${cardUuid}_btc_init";
  await LocalStorage.remove(keyBTCInit);

  await showDialog(
      context: ctx.context,
      barrierDismissible: false,
      builder: (context) {
        return ZenggeTextAlertDialog(languageResource.resetSuccess);
      });

  Navigator.pushNamedAndRemoveUntil(
      ctx.context, 'cardBaseMainPage', (route) => false);
}

Future<void> _oniOSScanSendResetCommand(
    Action action, Context<ResetFactorySettingsState> ctx) async {
  NfcManager.instance.startSession(
    pollingOptions: {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
    },
    alertMessage:
        'Hold your card near iPhone camera on upper back, until you see a ✅',
    onDiscovered: (NfcTag tag) async {
      Iso7816? isoDep;
      print('showModalBottomSheet result88');

      if (tag.data.keys.contains('iso7816')) {
        var iso7816 = Iso7816.from(tag);
        if (iso7816!.initialSelectedAID == '6864696E7374616361736800') {
          print('read iso7816:$iso7816');
          isoDep = iso7816;
        }
      }

      if (isoDep != null) {
        final readerManager = Platform.isAndroid
            ? IsoDepReaderManager(isoDep as IsoDep?)
            : IsoDepReaderManager(null, ios7816Dep: isoDep);
        if (readerManager.cardId != ctx.state.cardId) {
          var languageResource = ctx.state.languageResource!;

          NfcManager.instance.stopSession();
          await showDialog(
              context: ctx.context,
              builder: (_) {
                return ZenggeTextAlertDialog(
                  languageResource.sameDeviceTips,
                  enableCancel: false,
                  confirmText: "Confirm",
                );
              });

          return;
        }
        // ProgressDialog pr = ProgressDialog(ctx.context);
        // await pr.show();
        print('IsoDepReaderManager1');
        ctx.state.completer = Completer();
        ctx.dispatch(ResetFactorySettingsActionCreator.onUpdateScanned(true));
        ctx.dispatch(ResetFactorySettingsActionCreator.onSendResetCommand(
            readerManager));
        print('IsoDepReaderManager2');
        var result = await ctx.state.completer?.future;
        print('IsoDepReaderManager3');
        // pr.hide();
        NfcManager.instance.stopSession();
        if (result != null) {
          print('IsoDepReaderManager4');
          if (result.isSuccess) {
            ctx.dispatch(ResetFactorySettingsActionCreator.onRealResetCard());
          } else {
            // showToast(result.message ?? '');
            if (result.message != null &&
                result.message!.isNotEmpty &&
                result.message!.length < 70) {
              await showDialog(
                  context: ctx.context,
                  builder: (_) {
                    return ZenggeTextAlertDialog(
                      result.message!,
                      enableCancel: false,
                      confirmText: "Confirm",
                    );
                  });
            }
          }
        }
      } else {
        NfcManager.instance.stopSession();

        await showDialog(
            context: ctx.context,
            builder: (_) {
              return const ZenggeTextAlertDialog(
                "The card can't get IsoDep manager",
                enableCancel: false,
                confirmText: "Confirm",
              );
            });
      }
    },
    onError: (NfcError error) async {
      NfcManager.instance.stopSession();
      if (error.message.isNotEmpty && error.message.length < 50) {
        await showDialog(
            context: ctx.context,
            builder: (_) {
              return ZenggeTextAlertDialog(
                error.message,
                enableCancel: false,
                confirmText: "Confirm",
              );
            });
      }
    },
  );
}

Future<void> _onSendResetCommand(
    Action action, Context<ResetFactorySettingsState> ctx) async {
  IsoDepReaderManager readerManager = action.payload;
  try {
    print('_onSendResetCommand-start');
    String? pwd = ctx.state.pwd;
    List<int>? pinCode;
    if (pwd.isNotEmpty) {
      pinCode = [];
      for (int i = 0; i < pwd.length; i++) {
        pinCode.add(int.parse(pwd[i]));
      }
      print('_onSendResetCommand-start5555');
    }
    print('_onSendResetCommand-start1');
    var runnable = ResetCardRunnable(pinCode: pinCode);
    var response = await runnable.run(ctx.context, readerManager);
    if (response.isSuccess) {
      int count = response.data!;
      print('count :$count');
      ctx.state.timer = Timer(const Duration(milliseconds: 1000), () async {
        ctx.dispatch(ResetFactorySettingsActionCreator.onSendResetCommand(
            readerManager));
      });
      if (count == 10) {
        count = 0;
      }
      print('_onSendResetCommand-start2');
      ctx.dispatch(ResetFactorySettingsActionCreator.onUpdateCount(count));
    } else {
      if (response.sw1 == 0xAA && response.sw2 == 0x30) {
        print('reset success');
        ctx.state.completer?.complete(ScanResponse(true));
      } else {
        print('reset error');
        ctx.state.completer?.complete(response);
      }
    }
  } catch (error) {
    print('runnable error:$error');
    ctx.dispatch(ResetFactorySettingsActionCreator.onUpdateScanned(false));
    if (error is PlatformException) {
      return;
    }
    ctx.state.completer
        ?.complete(ScanResponse(false, message: error.toString()));
  }
}
