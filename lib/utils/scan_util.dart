import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/pigeons/method_channel_blockchain.dart';
import 'package:card_coin/utils/compatibility_util.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/runnable/card_common_status_runnable.dart';
import 'package:card_coin/utils/runnable/export_card_data_runnable.dart';
import 'package:card_coin/utils/runnable/get_ndef_data_runnable.dart';
import 'package:card_coin/utils/runnable/get_uid_data_runnable.dart';
import 'package:card_coin/utils/runnable/import_card_data_runnable.dart';
import 'package:card_coin/utils/runnable/store_uid_data_runnable.dart';
import 'package:card_coin/utils/runnable/unlock_card_runnable.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:chipcore_sdk/src/demo/utils/scan_util.dart' as chip_scan;
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../custom_widget/scan_card.dart';
import '../managers/isodep_reader_manager.dart';
import 'hex_utils.dart';
import 'runnable/bean/compatibility_info.dart';

typedef CompletionCallback<T> = Function(T element);

class CardSession {
  String? cardId;
  String? initialMessage;

  CardSession(this.cardId, {this.initialMessage});
}

class ScanResponse<T> {
  bool isSuccess;
  bool? isActivated;
  int? resetCount;
  T? data;
  int? sw1;
  int? sw2;
  String? message;
  CardHealthCommonStatus? commonInfo;

  ScanResponse(this.isSuccess,
      {this.isActivated,
      this.resetCount,
      this.data,
      this.message,
      this.sw1,
      this.sw2,
      this.commonInfo});
}

abstract class CardSessionRunnable<T> {
  Future<ScanResponse<T>> run(
      BuildContext context, IsoDepReaderManager readerManager);

  Uint8List getHeader() {
    throw UnimplementedError('getHeader must be implemented.');
  }

  List<int> getData() {
    return [];
  }

  Future<ScanResponse<CompatibilityInfo>> commonRun(
      BuildContext context, IsoDepReaderManager readerManager) {
    throw UnimplementedError('commonRun must be implemented.');
  }

  ScanResponse<T> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    throw UnimplementedError('handleResponse must be implemented.');
  }
}

class ScanUtil {
  static Future<ScanResponse> scanCardFromNative(BuildContext context,
      {CardSessionRunnable? runnable,
      String? cardId,
      String? newNdef,
      String? cardNo = '',
      bool checkLock = false,
      bool needRun = false,
      bool needSyscUid = false}) async {
    AppLanguageResource languageResource =
        GlobalStore.store.getState().languageResource!;
    var available = await NfcManager.instance.isAvailable();
    if (!available) {
      return ScanResponse(false, message: languageResource.nfcNotAvailable);
    }
    print(
        'iscanCardFromNative_needRun:$needRun,runnable:$runnable, needSyscUid:$needSyscUid');
    if (runnable != null) {
      var header = runnable.getHeader();
      var data = runnable.getData();

      Uint8List command;
      if (data.isNotEmpty) {
        command = Uint8List.fromList([...header, ...data]);
      } else {
        command = Uint8List.fromList(header);
      }
      print('iscanCardFromNative_needRun:$needRun');
      SendCommandResponse commandResponse = await BlockchainPlatform.instance
          .scanCardWithCommand(
              cardId: cardId,
              checkLock: checkLock,
              checkPwd: checkLock,
              ndefLink: newNdef,
              command: command,
              cardNo: cardNo,
              needRun: needRun,
              needSyscUid: needSyscUid);
      await scanCardHandleCompatibility(context,
          cardId: commandResponse.cardId,
          newNdef: newNdef,
          appleVersionCode: commandResponse.appletVersionCode,
          appleVersion: commandResponse.appletVersion);

      if (commandResponse.errorMessage != null &&
          commandResponse.errorMessage!.contains("DeviceLockError")) {
        var cardId =
            StringUtils.extractStacktrace(commandResponse.errorMessage!);
        print('iscanCardFrdno_locked:$cardId');
        return ScanResponse(false,
            message: languageResource.cardLocked,
            data: cardId,
            sw1: 0xAA,
            sw2: 0x23);
      }

      print('init stopSession0000:${commandResponse.data}');
      try {
        if (runnable is BaseRunnable) {
          print('init stopSession011:${commandResponse.data}');
          return runnable.handleResponse(
              CommandResponse.fromData(
                commandResponse.data!,
              ),
              cardId: commandResponse.cardId ?? '',
              isActivated: commandResponse.isActivated,
              resetCount: commandResponse.resetCount ?? 0);
        } else {
          print('init stopSession0222:${commandResponse.data}');
          return ScanResponse(commandResponse.isSuccess,
              isActivated: commandResponse.isActivated,
              resetCount: commandResponse.resetCount ?? 0,
              data: commandResponse.data);
        }
      } catch (error) {
        return ScanResponse(false, message: error.toString());
      }
    } else {
      print('init iscanCardFromNative_cardno:$cardNo');
      SendCommandResponse commandResponse = await BlockchainPlatform.instance
          .scanCardWithCommand(
              cardId: cardId,
              checkLock: checkLock,
              ndefLink: newNdef,
              cardNo: cardNo,
              needRun: needRun);
      await scanCardHandleCompatibility(context,
          cardId: commandResponse.cardId,
          newNdef: newNdef,
          appleVersionCode: commandResponse.appletVersionCode,
          appleVersion: commandResponse.appletVersion);
      print('init stopSession1111');
      if (commandResponse.errorMessage != null &&
          commandResponse.errorMessage!.contains("DeviceLockError")) {
        var cardId =
            StringUtils.extractStacktrace(commandResponse.errorMessage!);
        print('iscanCardFrdno_locked1:$cardId');
        return ScanResponse(false,
            message: languageResource.cardLocked,
            data: cardId,
            sw1: 0xAA,
            sw2: 0x23);
      }
      return ScanResponse(commandResponse.isSuccess,
          isActivated: commandResponse.isActivated,
          resetCount: commandResponse.resetCount,
          data: commandResponse.cardId);
    }
  }

  static Future<void> scanCardHandleCompatibility(BuildContext context,
      {CardSessionRunnable? runnable,
      String? cardId,
      String? newNdef,
      bool checkLock = false,
      String? appleVersionCode,
      String? appleVersion}) async {
    print('init startSession4');
    // 拦截处理兼容性检测
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      String key = "${cardId}_${appleVersionCode}_${packageInfo.buildNumber}";
      CompatibilityInfo? compatibility =
          await LocalStorage.getCompatibility(key);
      if (appleVersion != null || appleVersion!.isEmpty) {
        await LocalStorage.saveString("${cardId}_appleVersion", appleVersion);
      }

      print("CardSessionRunnable:commonRun:key:$key");
      if (compatibility == null && cardId != null && appleVersionCode != null) {
        // 说明之前存储过,这种情况下可以不用请求兼容性接口
        print("CardSessionRunnable:commonRun:");
        CompatibilityUtil.updateCompatibilitySmartCard(
            cardId, appleVersionCode, appleVersion);
      }
    } catch (error) {}
  }

  ///[oCardId] 验证正在扫卡的uid跟传入的uid是否一致，如果[oCardId]为null，则不需要验证
  ///[appletId] 应用ID，不填使用默认的
  static Future<ScanResponse> scanCard(
    BuildContext context, {
    List<int>? appletId,
    CardSessionRunnable? runnable,
    String? oCardId,
    String? newNdef,
    bool checkLock = false,
    bool useNative = true,
    bool commonInfo = false,
    String? cardNo,
    bool? needRun = false,
    bool? needSyscUid = false,
  }) async {
    AppLanguageResource languageResource =
        GlobalStore.store.getState().languageResource!;
    Completer<ScanResponse> completer = Completer();
    if (Platform.isIOS) {
      // NfcManager.instance
      //     .stopSession(errorMessage: "Session invalidated by user");
    }

    ///只支持Android平台，IOS平台任何情况都返回true;
    bool isAvailable = await NfcManager.instance.isAvailable();
    print('nfc needRun:$needRun');
    if (isAvailable) {
      bool showDialog = false;
      if (Platform.isAndroid) {
        if (useNative) {
          if (runnable != null && runnable is ExportCardDataRunnable ||
              (runnable != null && runnable is ImportCardDataRunnable) ||
              (runnable != null && runnable is UnlockCardRunnable) ||
              (runnable != null && runnable is GetUidDataRunnable) ||
              (runnable != null && runnable is StoreUidDataRunnable)) {
            showDialog = true;
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              builder: (context) => ScanCard(
                appLanguageResource: languageResource,
                onCancel: () {
                  Navigator.of(context).pop();
                  NfcManager.instance.stopSession();
                  completer.complete(ScanResponse(false,
                      message: languageResource.userCancel));
                  // completer.completeError('User cancel');
                },
              ),
            );
          } else {
            scanCardFromNative(context,
                    runnable: runnable,
                    cardId: oCardId,
                    newNdef: newNdef,
                    checkLock: checkLock,
                    cardNo: cardNo,
                    needRun: needRun!,
                    needSyscUid: needSyscUid ?? false)
                .then((value) {
              completer.complete(value);
            });
            return completer.future;
          }
        } else {
          showDialog = true;
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            builder: (context) => ScanCard(
              appLanguageResource: languageResource,
              onCancel: () {
                Navigator.of(context).pop();
                NfcManager.instance.stopSession();
                completer.complete(
                    ScanResponse(false, message: languageResource.userCancel));
                // completer.completeError('User cancel');
              },
            ),
          );
        }
      } else if (Platform.isIOS && useNative) {
        // iOS 与 Android 对齐：通过 chipcore_sdk 原生通道扫卡，无需手动管理 NFC session
        scanCardFromNative(context,
                runnable: runnable,
                cardId: oCardId,
                newNdef: newNdef,
                checkLock: checkLock,
                cardNo: cardNo,
                needRun: needRun ?? false,
                needSyscUid: needSyscUid ?? false)
            .then((value) {
          completer.complete(value);
        });
        return completer.future;
      }

      NfcManager.instance.startSession(
          pollingOptions: {
            NfcPollingOption.iso14443,
            NfcPollingOption.iso15693,
          },
          alertMessage:
              'Hold your card near iPhone camera on upper back, until you see a ✅',
          onDiscovered: (NfcTag tag) async {
            print('tag data:${jsonEncode(tag.data)}');
            IsoDep? isoDepAndroid;
            Iso7816? isoDepIos;
            if (Platform.isAndroid) {
              if (tag.data.keys.contains('isodep')) {
                isoDepAndroid = IsoDep.from(tag);
              }
            } else {
              if (tag.data.keys.contains('iso7816')) {
                final iso7816 = Iso7816.from(tag);
                if (iso7816!.initialSelectedAID == '6864696E7374616361736800') {
                  print('read iso7816:$iso7816');
                  isoDepIos = iso7816;
                }
              }
            }

            if (isoDepAndroid != null || isoDepIos != null) {
              var cardId = HexUtils.uint8ListToHex(Platform.isAndroid
                  ? isoDepAndroid!.identifier
                  : isoDepIos!.identifier);
              final readerManager = Platform.isAndroid
                  ? IsoDepReaderManager(isoDepAndroid, appletId: appletId)
                  : IsoDepReaderManager(null,
                      appletId: appletId, ios7816Dep: isoDepIos);
              print("readerManager:$readerManager");

              ///执行Ndef读写
              // if (newNdef?.isNotEmpty ?? false) {
              //   ndefRunner = GetNdefDataRunnable();
              //   var ndefResponse = await ndefRunner.run(context, readerManager);
              //   if (ndefResponse.isSuccess) {
              //     List<int> pukIntList = newNdef!.codeUnits;
              //     final storeNdefResponse =
              //         await StoreNdefDataRunnable(ndef: pukIntList)
              //             .run(context, readerManager);
              //     if (storeNdefResponse.isSuccess) {
              //       print('NdefDataresponse20');
              //       // completer.complete(storeNdefResponse);
              //     } else {
              //       print('NdefDataresponse21');
              //       // completer.complete(ScanResponse(false,
              //       //     message: storeNdefResponse.message));
              //     }
              //   } else {
              //     print('NdefDataresponse11');
              //     // completer.complete(
              //     //     ScanResponse(false, message: ndefResponse.message));
              //   }
              //   runnable = ndefRunner as BaseRunnable; // 强制类型转换
              //   print('init startSession3');
              //   // return;
              // }
              print("startSession-cardId:$cardId");
              if (runnable != null) {
                // 执行从头开始传入的runnable
                ///如果传入的cardID不为空，则需要验证CardID是否一致
                if (oCardId != null && oCardId != cardId) {
                  completer.complete(ScanResponse(false,
                      message:
                          'This card does not contain the current wallet'));
                  NfcManager.instance.stopSession(
                      errorMessage:
                          'This card does not contain the current wallet');
                  if (showDialog) {
                    Navigator.of(context).pop();
                  }
                  return;
                }

                if (runnable is BaseRunnable) {
                  print('init startSession4');
                  ScanResponse<dynamic>? response;
                  try {
                    response = await runnable.run(context, readerManager);

                    print('init stopSession2222:$response, runnable:$runnable');
                    if (runnable is GetNdefDataRunnable) {
                      // 如果是读NDEF的runnable，直接返回cardid
                      response.data = readerManager.cardId;
                      response.isSuccess = true;
                    } else if (runnable is StoreUidDataRunnable) {
                      // 如果是读UID的runnable，直接返回cardid
                      response.data = readerManager.cardId;
                      response.isSuccess = true;
                    }
                  } catch (error) {
                    if (error is PlatformException) {
                      ///如果是由于感应时间太短导致，不执行任何操作
                      return;
                    }
                  }
                  // runnable.run 抛出非 PlatformException 时 response 为 null，直接跳过
                  if (response == null) return;
                  // 拦截处理兼容性检测
                  try {
                    final commonInfoResponse =
                        await runnable.commonRun(context, readerManager);

                    CompatibilityInfo? compatibility = commonInfoResponse.data;
                    CardHealthCommonStatus? commonInfo =
                        commonInfoResponse.commonInfo;
                    if (compatibility != null) {
                      if (compatibility.data.targetName == null) {
                        // 说明之前没有存储过,需要请求兼容性接口，并存储兼容性数据
                        CompatibilityUtil.updateCompatibilitySmartCard(
                            cardId,
                            commonInfo!.cardVersionCode,
                            commonInfo.cardVersion);
                      }
                    }

                    if (checkLock && commonInfo != null && commonInfo.isLock) {
                      print('card is locked:${commonInfo.isLock}');
                      completer.complete(ScanResponse(false,
                          message: languageResource.cardLocked,
                          data: cardId,
                          commonInfo: commonInfo,
                          isActivated: commonInfo.isActivated,
                          resetCount: commonInfo.rescoutCount,
                          sw1: 0xAA,
                          sw2: 0x23));
                      NfcManager.instance.stopSession(
                          errorMessage: languageResource.cardLocked);
                      if (showDialog) {
                        Navigator.of(context).pop();
                      }
                      return;
                    }
                    // 成功查询兼容性
                    if (runnable is CardCommonStatusRunnable) {
                      completer.complete(ScanResponse(
                          commonInfoResponse.isSuccess,
                          data: commonInfoResponse.commonInfo,
                          resetCount:
                              commonInfoResponse.commonInfo!.rescoutCount,
                          isActivated:
                              commonInfoResponse.commonInfo!.isActivated));
                    } else {
                      // 其他情况返回runnable的response
                      print('response caranc-reslut:${response.isSuccess}');
                      completer.complete(ScanResponse(response.isSuccess,
                          data: response.data,
                          message: response.message,
                          sw1: response.sw1,
                          sw2: response.sw2,
                          resetCount:
                              commonInfoResponse.commonInfo!.rescoutCount,
                          isActivated:
                              commonInfoResponse.commonInfo!.isActivated));
                    }

                    // } else {
                    //   completer.complete(ScanResponse(commonInfoResponse.isSuccess, data: cardId));
                    //   NfcManager.instance.stopSession();
                    //   if (showDialog) {
                    //     Navigator.of(context).pop();
                    //   }
                    //   return;
                    // }
                  } catch (error) {
                    if (error is PlatformException) {
                      ///如果是由于感应时间太短导致，不执行任何操作
                      return;
                    }
                    completer.complete(
                        ScanResponse(false, message: error.toString()));
                    NfcManager.instance
                        .stopSession(errorMessage: error.toString());
                    if (showDialog) {
                      Navigator.of(context).pop();
                    }
                    return;
                  }
                } else {
                  try {
                    var response = await runnable.run(context, readerManager);
                    completer.complete(response);
                  } catch (error) {
                    if (error is PlatformException) {
                      ///如果是由于感应时间太短导致，不执行任何操作
                      return;
                    }
                    completer.complete(
                        ScanResponse(false, message: error.toString()));
                    print('init stopSession2222');
                    NfcManager.instance.stopSession();
                    if (showDialog) {
                      Navigator.of(context).pop();
                    }
                    return;
                  }
                }
              } else {
                if (checkLock) {
                  final response = await readerManager.queryCardStatus();
                  if (response.isSuccess) {
                    CardHealthCommonStatus commonStatus =
                        CardHealthCommonStatus.fromData(
                            readerManager.cardId, response.data!);
                    if (commonStatus.isLock) {
                      completer.complete(ScanResponse(false,
                          message: languageResource.cardLocked));
                    } else {
                      completer.complete(ScanResponse(true, data: cardId));
                    }
                  } else {
                    completer.complete(
                        ScanResponse(false, message: response.message));
                  }
                } else {
                  completer.complete(ScanResponse(true, data: cardId));
                }
              }
            } else {
              print('init failure isoDep is null');
              completer.complete(
                  ScanResponse(false, message: 'Unsupported IsoDep1'));
            }
            print('init stopSession');
            NfcManager.instance.stopSession();
            if (showDialog) {
              Navigator.of(context).pop();
            }
          },
          onError: (NfcError error) async {
            print('NfcError:${error.message}');

            NfcManager.instance.stopSession(errorMessage: error.message);
            completer.complete(ScanResponse(false, message: error.message));
          });
    } else {
      NfcManager.instance.stopSession();
      completer.complete(
          ScanResponse(false, message: languageResource.nfcNotAvailable));
    }

    return completer.future;
  }

  static Future<void> unlockTip(
      ScanResponse response, BuildContext context, String? cardId) async {
    print("unlockTip-response:${response.sw1},${response.sw2}, cardId:$cardId");
    // NFC IO 错误（如 tag lost）时 sw1/sw2 为 null，直接 toast 错误信息
    if (response.sw1 == null || response.sw2 == null) {
      final msg = response.message ?? 'NFC error';
      if (msg.isNotEmpty && msg.length < 100) {
        showToast(msg);
      }
      return;
    }
    String message = _getErrorMsg(response.sw1!, response.sw2!);
    if (response.sw1 == 0xAA && response.sw2 == 0x23) {
      var result = await showDialog(
          context: context,
          builder: (_) {
            return ZenggeTextAlertDialog(
              "$message, please unlock the card first.",
              enableCancel: true,
              confirmText: "Confirm",
              cancelText: "Cancel",
            );
          });
      if (result == true) {
        print("unlockTip-unlockPinCode-response0000:${response.message}");
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context)
            .pushNamed('unlockPinCodePage', arguments: {'cardId': cardId});
        return;
      }
    } else {
      print('unlockTip-message:$message');
      if (Platform.isIOS) {
        await showDialog(
            context: context,
            builder: (_) {
              return ZenggeTextAlertDialog(message,
                  enableCancel: false, confirmText: "Confirm");
            });
      } else {
        if (message.isNotEmpty && message.length < 100) {
          showToast(message);
        }
      }
    }
  }

  static String _getErrorMsg(int b1, int b2) {
    if (b1 == 0xAA && b2 == 0x00) {
      return 'Command not allowed';
    } else if (b1 == 0xAA && b2 == 0x02) {
      return 'P1 and/or P2 incorrect';
    } else if (b1 == 0xAA && b2 == 0x03) {
      return 'Wrong length';
    } else if (b1 == 0xAA && b2 == 0x10) {
      return 'UID length error';
    } else if (b1 == 0xAA && b2 == 0x11) {
      return 'UID validate failed';
    } else if (b1 == 0xAA && b2 == 0x12) {
      return 'UID data failed';
    } else if (b1 == 0xAA && b2 == 0x20) {
      return 'Data invalid';
    } else if (b1 == 0xAA && b2 == 0x21) {
      return 'Error code thrown if entered PIN was incorrect';
    } else if (b1 == 0xAA && b2 == 0x22) {
      return 'PIN required';
    } else if (b1 == 0xAA && b2 == 0x23) {
      return 'Card is locked';
    } else if (b1 == 0xAA && b2 == 0x24) {
      return 'Error code thrown if entered PUK was incorrect';
    } else if (b1 == 0xAA && b2 == 0x25) {
      return 'The card has expired,over the maximum number of failed PUK';
    } else if (b1 == 0xAA && b2 == 0x30) {
      return 'ECC Key pair not exist';
    } else if (b1 == 0xAA && b2 == 0x31) {
      return 'ECC Key pair exist';
    } else if (b1 == 0xAB && b2 == 0x12) {
      return 'PUK TAG ERROR';
    } else {
      return 'Unknown error';
    }
  }

  // ── chipcore_sdk 统一扫卡接口 ─────────────────────────────────

  /// 仅扫卡（无额外 APDU），通过 chipcore_sdk 原生通道执行。
  /// 返回的 ScanResponse.data 为卡片 cardId（String）。
  static Future<ScanResponse> chipScanOnly({
    bool checkLock = false,
    bool needSyncUid = false,
    String? ndefLink,
  }) async {
    final chipResp = await chip_scan.ScanUtil.scanOnly(
      checkLock: checkLock,
      needSyncUid: needSyncUid,
      ndefLink: ndefLink,
    );
    return ScanResponse(
      chipResp.isSuccess,
      isActivated: chipResp.data?.isActivated,
      resetCount: chipResp.data?.resetCount,
      // chipcore 返回小写 hex，对齐旧 SDK 大写格式，避免服务器查询失败
      data: chipResp.data?.cardId.toUpperCase(),
      message: chipResp.message,
      sw1: chipResp.sw1,
      sw2: chipResp.sw2,
    );
  }

  /// 发送一条 APDU 命令（通过 chipcore_sdk），并用 [runnable] 解析响应。
  /// 调用方不再需要持有 BuildContext。
  static Future<ScanResponse> chipScanWithRunnable(
    CardSessionRunnable runnable, {
    bool checkLock = false,
    bool needSyncUid = false,
    String? ndefLink,
    String? expectedCardId,
    String? cardNo,
  }) async {
    final header = runnable.getHeader();
    final data = runnable.getData();
    // chipcore 的 send() 把位置 4 当 Lc，从位置 5 开始加密。
    // 必须在 header(4字节) 和 TLV data 之间插入正确的 Lc，
    // 使 plainData = apdu[5:] = TLV data（含 TAG 字节），卡片才能正确解析。
    final command = data.isNotEmpty
        ? Uint8List.fromList([...header, data.length, ...data])
        : Uint8List.fromList(header);

    final chipResp = await chip_scan.ScanUtil.sendCommand(
      command,
      checkLock: checkLock,
      needSyncUid: needSyncUid,
      ndefLink: ndefLink,
      cardId: expectedCardId,
      cardNo: cardNo,
    );

    // UID 一致性校验：放在 isSuccess 判断之前，确保失败响应也能比对
    // 当 SDK 检测到 uid-mismatch 时，会把实际扫到的 cardId 放入 chipResp.data.cardId
    if (expectedCardId != null &&
        expectedCardId.isNotEmpty &&
        chipResp.data != null) {
      final scannedId = chipResp.data!.cardId;
      if (scannedId.isNotEmpty &&
          scannedId.toUpperCase() != expectedCardId.toUpperCase()) {
        return ScanResponse(
          false,
          message: 'Wrong card. Please use the correct card.',
        );
      }
    }

    if (!chipResp.isSuccess) {
      return ScanResponse(
        false,
        message: chipResp.message,
        sw1: chipResp.sw1,
        sw2: chipResp.sw2,
      );
    }

    final rawData = chipResp.data?.data;
    if (rawData == null || rawData.isEmpty) {
      return ScanResponse(true, data: chipResp.data?.cardId.toUpperCase());
    }

    // chipcore SDK 返回的 data 是解密后的纯 TLV 数据（不含 SW1+SW2 字节），
    // 不能用 CommandResponse.fromData（会把末尾两字节当 SW 解析导致误判失败）。
    // chipcore 侧已完成 APDU 校验，直接构造 success 状态传入 handleResponse。
    return runnable.handleResponse(
      CommandResponse(0x90, 0x00, true, data: rawData),
      cardId: chipResp.data!.cardId.toUpperCase(),
      isActivated: chipResp.data!.isActivated,
      resetCount: chipResp.data!.resetCount,
    );
  }
}
