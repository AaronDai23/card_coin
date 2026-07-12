import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<CheckCardState>? buildEffect() {
  return combineEffects(<Object, Effect<CheckCardState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    CheckCardAction.startCheck: _onStartAction,
    CheckCardAction.upload: _onUpload,
    CheckCardAction.resetScan: _onResetCheckStutas,
  });
}

Future<void> _onDispose(Action action, Context<CheckCardState> ctx) async {
  ctx.state.timer?.cancel();
  BlockchainPlatform.instance.resetNfcReaderMode();
}

void _onInit(Action action, Context<CheckCardState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  List<HealthCheckInfo> checkList = [
    HealthCheckInfo(
        name: languageResource.ndefPrefixSet, type: HealthCheckType.ndefPrefix),
    HealthCheckInfo(
        name: languageResource.cardVersion, type: HealthCheckType.cardVersion),
    HealthCheckInfo(
        name: languageResource.shareVersion,
        type: HealthCheckType.shareVersion),
    HealthCheckInfo(
        name: languageResource.ndefVersion, type: HealthCheckType.ndefVersion),
    HealthCheckInfo(
        name: languageResource.cardNumber, type: HealthCheckType.cardNumber),
    HealthCheckInfo(
        name: languageResource.cardVersionCode,
        type: HealthCheckType.cardVersionCode),
    HealthCheckInfo(
        name: languageResource.pinRemaining,
        type: HealthCheckType.pinRemaining),
    HealthCheckInfo(
        name: languageResource.pukRemaining,
        type: HealthCheckType.pukRemaining),
    HealthCheckInfo(
        name: languageResource.signTimes, type: HealthCheckType.signTimes),
    HealthCheckInfo(
        name: languageResource.cardVendorCheck,
        type: HealthCheckType.cardVendorCheck),
    HealthCheckInfo(
        name: languageResource.cardLock, type: HealthCheckType.cardLock),
    HealthCheckInfo(
        name: languageResource.cardDisable, type: HealthCheckType.cardDisable),
    HealthCheckInfo(
        name: languageResource.keyPairGenerated,
        type: HealthCheckType.keyPairGenerated),
    HealthCheckInfo(
        name: languageResource.getDeriveInfo, type: HealthCheckType.deriveInfo),
    HealthCheckInfo(
        name: languageResource.signature, type: HealthCheckType.signature),
    HealthCheckInfo(
        name: languageResource.pinset, type: HealthCheckType.pinSet),
    HealthCheckInfo(
        name: languageResource.exportTimes, type: HealthCheckType.exportTimes),
    HealthCheckInfo(
        name: languageResource.restoreTimes,
        type: HealthCheckType.restoreTimes),
    HealthCheckInfo(
        name: languageResource.syncUid, type: HealthCheckType.syncUid),
    HealthCheckInfo(
        name: languageResource.hdTapTimes, type: HealthCheckType.hdTapTimes),
    HealthCheckInfo(
        name: languageResource.ndefTapTimes,
        type: HealthCheckType.ndefTapTimes),
  ];
  ctx.dispatch(CheckCardActionCreator.onInitTask(checkList));
}

Future<void> _onStartAction(Action action, Context<CheckCardState> ctx) async {
  ctx.dispatch(CheckCardActionCreator.onUpdateShowScan(true));

  NfcManager.instance.stopSession();

  ctx.state.timer?.cancel();
  // 30s没反应到扫卡，则报提示
  ctx.state.timer = Timer(const Duration(milliseconds: 30000), () async {
    showDialog(
        context: ctx.context,
        builder: (context) {
          return const ZenggeTextAlertDialog(
            "time out to scan card",
            titleText: "",
            enableCancel: false,
            confirmText: "I know",
          );
        }).then((isConfirm) {
      if (isConfirm) {
        NfcManager.instance.stopSession();
        var list = ctx.state.checkList
            .map((e) => e.copyWith(status: HealthStatus.none)..result = null)
            .toList();
        ctx.dispatch(CheckCardActionCreator.onUpdateShowScan(false));
        ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
      }
    });
  });

  List<TaskInfo> taskList = [
    TaskInfo(HealthCheckTask.deriveInfo),
    TaskInfo(HealthCheckTask.signature),
    TaskInfo(HealthCheckTask.commonStatus),
    TaskInfo(HealthCheckTask.ndefPrefix),

    ///网络请求任务放后 面
    TaskInfo(HealthCheckTask.cardVendor),
    TaskInfo(HealthCheckTask.cardNumber),
    TaskInfo(HealthCheckTask.shareVersion),
    TaskInfo(HealthCheckTask.ndefVersion),
  ];

  NfcManager.instance.startSession(
    pollingOptions: {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
    },
    alertMessage:
        'Hold your card near iPhone camera on upper back, until you see a ✅',
    onDiscovered: (NfcTag tag) async {
      if (ctx.state.showScanTip) {
        ctx.dispatch(CheckCardActionCreator.onUpdateShowScan(false));
      }
      var isProcess =
          taskList.any((element) => element.status == TaskStatus.process);
      if (isProcess) {
        return;
      }

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
        final readerManager = Platform.isAndroid
            ? IsoDepReaderManager(isoDepAndroid)
            : IsoDepReaderManager(null, ios7816Dep: isoDepIos);
        final languageResource = ctx.state.languageResource!;
        String cardId = readerManager.cardId;

        for (int i = 0; i < taskList.length; i++) {
          final task = taskList[i];

          ///当任务已成功或已经在进行中时跳过
          if (task.status == TaskStatus.process ||
              task.status == TaskStatus.success) {
            continue;
          }
          task.status = TaskStatus.process;

          if (task.type == HealthCheckTask.cardVendor) {
            var result = await HttpManager.getInstance().post(
                NetworkAddress.checkUid, null,
                data: {'uid': cardId},
                cancelToken: ctx.state.canceler.newToken());

            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.cardVendorCheck);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (result.isSuccess) {
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.health, result: 'Yes');
              task.status = TaskStatus.success;
            } else {
              newCheckInfo =
                  checkInfo.copyWith(status: HealthStatus.failed, result: 'No');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.cardNumber) {
            var result = await HttpManager.getInstance().post(
                NetworkAddress.getCardNumber, null,
                data: {'uid': cardId},
                noTip: true,
                cancelToken: ctx.state.canceler.newToken());

            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.cardNumber);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (result.isSuccess) {
              if (result.data != null && result.data != '') {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.health, result: result.data);
              } else {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.unHealth,
                    result: languageResource.empty);
              }
              task.status = TaskStatus.success;
            } else {
              newCheckInfo =
                  checkInfo.copyWith(status: HealthStatus.failed, result: 'No');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.deriveInfo) {
            var result = await readerManager.getDeriveInfo();

            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.deriveInfo);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (result.isSuccess) {
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.health, result: 'Yes');
              task.status = TaskStatus.success;
            } else {
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.unHealth, result: 'No');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.signature) {
            var result = await readerManager.signature();

            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.signature);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (result.isSuccess) {
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.health, result: 'Yes');
              task.status = TaskStatus.success;
            } else {
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.unHealth, result: 'No');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.shareVersion) {
            List<int> shareList = _getShareAid();

            final readerManager1 = Platform.isAndroid
                ? IsoDepReaderManager(isoDepAndroid, appletId: shareList)
                : IsoDepReaderManager(null,
                    appletId: shareList, ios7816Dep: isoDepIos);
            print('readerManager1 cardId:$cardId');
            var versionResponse = await readerManager1.shareVersion();
            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.shareVersion);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (versionResponse.isSuccess) {
              print('readerManager1 success');
              String version =
                  String.fromCharCodes(versionResponse.data!.sublist(2));

              if (version == "") {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.unHealth, result: "Empty");
              } else {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.health, result: version);
              }
              task.status = TaskStatus.success;
            } else {
              print('readerManager1 fail');
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.failed, result: 'Empty');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.ndefVersion) {
            List<int> ndeefList = _getNDEFAid();
            final readerManager2 = Platform.isAndroid
                ? IsoDepReaderManager(isoDepAndroid, appletId: ndeefList)
                : IsoDepReaderManager(null,
                    appletId: ndeefList, ios7816Dep: isoDepIos);
            var versionResponse = await readerManager2.ndedfVersion();
            print('readerManager2 cardId:$cardId');
            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.ndefVersion);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (versionResponse.isSuccess) {
              print('readerManager success');
              String version =
                  String.fromCharCodes(versionResponse.data!.sublist(2));
              if (version == "") {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.unHealth, result: "Empty");
                task.status = TaskStatus.failed;
              } else {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.health, result: version);
              }
              task.status = TaskStatus.success;
            } else {
              print('readerManager2 fail');
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.failed, result: 'Empty');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.ndefPrefix) {
            var ndefLinkRespon = await readerManager.getNDEFData();
            print('readerManager2 cardId:${ndefLinkRespon.data}');
            final list = ctx.state.checkList.toList();
            var index = list.indexWhere(
                (element) => element.type == HealthCheckType.ndefPrefix);
            HealthCheckInfo checkInfo = list[index];
            HealthCheckInfo newCheckInfo;
            if (ndefLinkRespon.isSuccess) {
              print('readerManager2 success');
              int ndefLenght = ndefLinkRespon.data![1];
              String ndefUrl = String.fromCharCodes(
                  ndefLinkRespon.data!.sublist(2, 2 + ndefLenght));

              if (ndefUrl == "") {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.unHealth, result: "Empty");
                task.status = TaskStatus.failed;
              } else {
                newCheckInfo = checkInfo.copyWith(
                    status: HealthStatus.health, result: ndefUrl);
              }
              task.status = TaskStatus.success;
            } else {
              print('readerManager2 fail');
              newCheckInfo = checkInfo.copyWith(
                  status: HealthStatus.failed, result: 'Empty');
              task.status = TaskStatus.failed;
            }
            list[index] = newCheckInfo;
            ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
          } else if (task.type == HealthCheckTask.commonStatus) {
            var response = await readerManager.queryCardStatus();
            if (response.isSuccess) {
              var data = response.data!;

              print("queryCardStatus333:${StringUtils.uint8ToHex(data)}");
              CardHealthCommonStatus commonStatus =
                  CardHealthCommonStatus.fromData(readerManager.cardId, data);
              var list = ctx.state.checkList.toList();
              for (int i = 0; i < list.length; i++) {
                final checkInfo = list[i];
                if (checkInfo.type == HealthCheckType.cardVersion) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.cardVersion);
                } else if (checkInfo.type == HealthCheckType.cardLock) {
                  list[i] = checkInfo.copyWith(
                      status: commonStatus.isLock
                          ? HealthStatus.unHealth
                          : HealthStatus.health,
                      result: commonStatus.isLock ? 'Yes' : 'No');
                } else if (checkInfo.type == HealthCheckType.cardDisable) {
                  list[i] = checkInfo.copyWith(
                      status: commonStatus.disable
                          ? HealthStatus.unHealth
                          : HealthStatus.health,
                      result: commonStatus.disable ? 'Yes' : 'No');
                } else if (checkInfo.type == HealthCheckType.keyPairGenerated) {
                  list[i] = checkInfo.copyWith(
                      status: commonStatus.keyPairGenerated
                          ? HealthStatus.health
                          : HealthStatus.unHealth,
                      result: commonStatus.keyPairGenerated ? 'Yes' : 'No');
                } else if (checkInfo.type == HealthCheckType.pinSet) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.pinSet ? 'Yes' : 'No');
                } else if (checkInfo.type == HealthCheckType.pinRemaining) {
                  list[i] = checkInfo.copyWith(
                      status: commonStatus.pinRemaining == 0
                          ? HealthStatus.unHealth
                          : HealthStatus.health,
                      result: commonStatus.pinRemaining.toString());
                } else if (checkInfo.type == HealthCheckType.pukRemaining) {
                  list[i] = checkInfo.copyWith(
                      status: commonStatus.pukRemaining == 0
                          ? HealthStatus.unHealth
                          : HealthStatus.health,
                      result: commonStatus.pukRemaining.toString());
                } else if (checkInfo.type == HealthCheckType.signTimes) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.signTimes.toString());
                }
                // else if (checkInfo.type == HealthCheckType.ndefPrefix) {
                //   list[i] = checkInfo.copyWith(
                //       status: commonStatus.ndefUrl.length == 0
                //           ? HealthStatus.unHealth
                //           : HealthStatus.health,
                //       result: commonStatus.ndefUrl.length == 0
                //           ? "Empty"
                //           : commonStatus.ndefUrl);
                // }
                else if (checkInfo.type == HealthCheckType.cardVersionCode) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.cardVersionCode);
                } else if (checkInfo.type == HealthCheckType.exportTimes) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.exportTimes.toString());
                } else if (checkInfo.type == HealthCheckType.restoreTimes) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.rescoutCount.toString());
                } else if (checkInfo.type == HealthCheckType.syncUid) {
                  list[i] = checkInfo.copyWith(
                      status: commonStatus.uid.isEmpty
                          ? HealthStatus.unHealth
                          : HealthStatus.health,
                      result: commonStatus.uid.isEmpty
                          ? "Empty"
                          : commonStatus.uid);
                } else if (checkInfo.type == HealthCheckType.hdTapTimes) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.hdTapTimes.toString());
                } else if (checkInfo.type == HealthCheckType.ndefTapTimes) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.health,
                      result: commonStatus.ndefTapTimes.toString());
                }
              }
              task.status = TaskStatus.success;
              ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
            } else {
              var list = ctx.state.checkList.toList();
              for (int i = 0; i < list.length; i++) {
                final checkInfo = list[i];
                if (checkInfo.type == HealthCheckType.cardLock ||
                    checkInfo.type == HealthCheckType.cardDisable ||
                    checkInfo.type == HealthCheckType.keyPairGenerated ||
                    checkInfo.type == HealthCheckType.pinSet) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.failed, result: 'No');
                } else if (checkInfo.type == HealthCheckType.cardVersion ||
                    checkInfo.type == HealthCheckType.syncUid) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.failed, result: 'Empty');
                } else if (checkInfo.type == HealthCheckType.pinRemaining ||
                    checkInfo.type == HealthCheckType.pukRemaining ||
                    checkInfo.type == HealthCheckType.signTimes ||
                    checkInfo.type == HealthCheckType.cardVersionCode ||
                    checkInfo.type == HealthCheckType.exportTimes ||
                    checkInfo.type == HealthCheckType.restoreTimes ||
                    checkInfo.type == HealthCheckType.hdTapTimes ||
                    checkInfo.type == HealthCheckType.ndefTapTimes) {
                  list[i] = checkInfo.copyWith(
                      status: HealthStatus.failed, result: "0");
                }
              }
              task.status = TaskStatus.failed;
              ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
            }
          }
        }

        ///上传日志
        ctx.dispatch(CheckCardActionCreator.onUploadAction(cardId));
      }

      ctx.state.timer?.cancel();
      NfcManager.instance.stopSession();
      await BlockchainPlatform.instance.resetNfcReaderMode();
    },
    onError: (NfcError error) async {
      ctx.state.timer?.cancel();
      NfcManager.instance.stopSession();
      await BlockchainPlatform.instance.resetNfcReaderMode();
      // 判断是否是取消错误

      if (error.message.contains('Session invalidated by user')) {
        print('User cancelled NFC session');
        ctx.state.timer?.cancel();
        var list = ctx.state.checkList
            .map((e) => e.copyWith(status: HealthStatus.none)..result = null)
            .toList();
        ctx.dispatch(CheckCardActionCreator.onUpdateShowScan(false));
        ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
      }
    },
  );
}

Future<void> _onUpload(Action action, Context<CheckCardState> ctx) async {
  Map requests = {};
  String cardId = action.payload;
  requests['uid'] = cardId;
  for (HealthCheckInfo element in ctx.state.checkList) {
    requests[element.type.name] = element.value;
  }
  print('log param:${jsonEncode(requests)}');
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.healthCheck, null, data: requests);
  if (result.isSuccess) {
    print('upload success');
  } else {
    print('upload failed');
  }
}

List<int> _getShareAid() {
  /// 68 64 69 6E 73 74 61 63 61 73 68 01
  final List<int> shareAidAppletId = [
    0x68,
    0x64,
    0x69,
    0x6E,
    0x73,
    0x74,
    0x61,
    0x63,
    0x61,
    0x73,
    0x68,
    0x01
  ];
  return shareAidAppletId;
}

List<int> _getNDEFAid() {
  ///
  ///D2 76 00 00 85 01 01
  final List<int> ndefAppletId = [0xD2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01];
  return ndefAppletId;
}

Future<void> _onResetCheckStutas(
    Action action, Context<CheckCardState> ctx) async {
  NfcManager.instance.stopSession();
  ctx.state.canceler.cancelAll("");
  var list = ctx.state.checkList
      .map((e) => e.copyWith(status: HealthStatus.none)..result = null)
      .toList();
  ctx.dispatch(CheckCardActionCreator.onUpdateShowScan(false));
  ctx.dispatch(CheckCardActionCreator.onUpdateCheckInfoList(list));
}
