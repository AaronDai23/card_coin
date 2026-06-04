import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:card_coin/card_base/bean/card_info_bean.dart';
import 'package:card_coin/card_base/managers/isodep_reader_manager.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../../generated/l10n.dart';
import '../../utils/string_util.dart';
import '../../widget/custom_alert_dialog.dart';
import '../widgets/scan_card_view.dart';

class CardUtil {
  static String? getCardId(NfcTag tag) {
    String? identifier;
    for (int i = 0; i < tag.data.keys.length; i++) {
      var map = tag.data.entries.elementAt(i);
      if (map.value['identifier'] != null) {
        List<int> identifierBytes = map.value['identifier'];
        identifier =
            StringUtils.uint8ToHex(Uint8List.fromList(identifierBytes));
        break;
      }
    }
    return identifier;
  }

  static Future<BaseCardInfo?> scanPostCard(BuildContext context) async {
    var completer = Completer<BaseCardInfo?>();

    ///只支持Android平台，IOS平台任何情况都返回true;
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      if (Platform.isAndroid) {
        showMaterialModalBottomSheet(
          expand: false,
          context: context,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          builder: (context) => ScanCardView(
            onCancelClick: () {
              Navigator.of(context).pop();
              completer.completeError('User cancel');
            },
          ),
        );
      }

      print('nfc:=======start session');
      NfcManager.instance.startSession(
          pollingOptions: {
            NfcPollingOption.iso14443,
            NfcPollingOption.iso15693,
          },
          alertMessage:
              'Hold your card near iPhone camera on upper back, until you see a ✅',
          onDiscovered: (NfcTag tag) async {
            print('read card info:${json.encode(tag.data)}');
            BaseCardInfo? cardInfo;
            var globalState = GlobalStore.store.getState();
            var languageResource = globalState.languageResource!;
            if (Platform.isAndroid) {
              Navigator.of(context).pop();
              if (tag.data.keys.contains('isodep')) {
                var isoDep = IsoDep.from(tag);
                if (isoDep != null) {
                  var readerManager = IsoDepReaderManager(isoDep);
                  try {
                    cardInfo = await readerManager.getCardInfo();
                  } catch (error) {
                    print('IsoDepReaderManager error');
                    NfcManager.instance.stopSession(
                        errorMessage: languageResource.readCardError);
                    completer.completeError(languageResource.readCardError);
                    // await showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return ZenggeTextAlertDialog(languageResource.readCardError);
                    //     });
                    return;
                  }
                }
              } else {
                cardInfo = OtherCardInfo(null);
              }
            } else {
              CommandApi? commandApi;
              if (tag.data.keys.contains('iso7816')) {
                var iso7816 = Iso7816.from(tag);
                print('read iso7816:$iso7816');
                if (iso7816 != null) {
                  if (iso7816.initialSelectedAID == '00000000000000') {
                    commandApi = Iso7816CommandApi(iso7816);
                    CommandResponse result = await commandApi.sendCommand(
                        Uint8List.fromList(emoneyBytes.sublist(0, 13)));
                    if (result.isSuccess) {
                      cardInfo = EmoneyCardInfo(commandApi);
                    }
                  } else if (iso7816.initialSelectedAID == 'A000424E491000') {
                    commandApi = Iso7816CommandApi(iso7816);
                    print(
                        '========bArr request tapcash:${Uint8List.fromList(tapBytes.sublist(0, 13))}');
                    CommandResponse result = await commandApi.sendCommand(
                        Uint8List.fromList(tapBytes.sublist(0, 13)));
                    if (result.isSuccess) {
                      cardInfo = TapCashCardInfo(commandApi);
                    }
                    //A0000000180F00000100
                  } else if (iso7816.initialSelectedAID == 'A000000003000000') {
                    commandApi = Iso7816CommandApi(iso7816);
                    CommandResponse result = await commandApi.sendCommand(
                        Uint8List.fromList(flazzBytes.sublist(0, 16)));
                    if (result.isSuccess) {
                      cardInfo = FlazzCardInfo(commandApi);
                    }
                  } else if (iso7816.initialSelectedAID == 'D2760000850100') {
                    commandApi = Iso7816BrizziCommandApi(iso7816);
                    CommandResponse result = await commandApi.sendCommand(
                        Uint8List.fromList(brizziBytes.sublist(0, 9)));
                    if (result.isSuccess) {
                      print('brizziResponse.isSuccess');
                      cardInfo = BrizziCardInfo(commandApi);
                    }
                  }
                }
              } else if (tag.data.keys.contains('mifare')) {
                var miFare = MiFare.from(tag);

                if (miFare != null) {
                  print('mifare family:${miFare.mifareFamily}');
                  commandApi = FareIso7816CommandApi(miFare);
                  print(
                      '========bArr request servcie${Uint8List.fromList(brizziBytes.sublist(0, 9))}');
                  CommandResponse result = await commandApi.sendCommand(
                      Uint8List.fromList(brizziBytes.sublist(0, 9)));
                  if (result.isSuccess) {
                    cardInfo = BrizziCardInfo(commandApi);
                  }
                }
              } else {
                // var response = await runnable.run(ctx.context, readerManager);
              }

              cardInfo ??= OtherCardInfo(null);
            }

            print('cardInfo requestData');
            await cardInfo?.requestData();

            if (cardInfo == null) {
              completer.completeError(languageResource.unsupporetCard);
              NfcManager.instance
                  .stopSession(errorMessage: S.current.unsupporetCard);
              return;
            }

            var identifier = CardUtil.getCardId(tag);

            if (identifier == null) {
              if (!completer.isCompleted) {
                completer.completeError(S.current.readCardIdError);
              }
              NfcManager.instance
                  .stopSession(alertMessage: 'Scan card successfully！');
              return;
            }

            cardInfo.identifier = identifier;
            if (!completer.isCompleted) {
              completer.complete(cardInfo);
            }
            NfcManager.instance
                .stopSession(alertMessage: 'Scan card successfully！');
          },
          onError: (NfcError error) async {
            print(
                'nfc error type:${error.type},message:${error.message},detail:${error.details}');
            if (Platform.isAndroid) {
              Navigator.of(context).pop();
            }
            if (!completer.isCompleted) {
              completer.completeError(error.type);
            }
          });
    } else {
      if (!completer.isCompleted) {
        completer.complete(null);
      }

      var result = await showDialog(
          context: context,
          builder: (context) {
            return ZenggeTextAlertDialog(
              S.current.nfcOffTip,
              titleText: S.current.nfcOffTitle,
              confirmText: S.current.settings,
              enableCancel: true,
              cancelText: S.current.cancel,
            );
          });
      if (result != null && result) {
        AppSettings.openAppSettings(type: AppSettingsType.nfc);
      }

      // print('Nfc not isAvailable');
    }

    return completer.future;
  }
}
