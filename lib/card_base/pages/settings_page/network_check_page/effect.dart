import 'dart:async';
import 'dart:io';

import 'package:card_coin/card_base/bean/diagnostic_bean.dart';
import 'package:card_coin/card_base/widgets/diagnostic_widget.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<NetworkCheckState>? buildEffect() {
  return combineEffects(<Object, Effect<NetworkCheckState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    NetworkCheckAction.action: _onAction,
  });
}

void _onInit(Action action, Context<NetworkCheckState> ctx) {
  _startCheck(action, ctx);
}

void _onDispose(Action action, Context<NetworkCheckState> ctx) {
  ctx.state.pingListener?.cancel();
}

void _onAction(Action action, Context<NetworkCheckState> ctx) {}

Future<void> _startCheck(Action action, Context<NetworkCheckState> ctx) async {

  var languageResource = ctx.state.languageResource!;
  ctx.state.resultList = [DiagnosticItemResult(languageResource.checkingPhoneNetwork),DiagnosticItemResult('',state: ResultState.normal)];
  List<String> hostAddresses;

  if (Platform.isIOS) {
    hostAddresses = ['apple.com', 'baidu.com'];
  } else {
    hostAddresses = ['google.com', 'baidu.com'];
  }
  PingResponseInfo? phoneNetworkInfo = await _checkAppNetworkTask(ctx,hostAddresses);

  if (phoneNetworkInfo != null) {
    String networkDes;
    if (phoneNetworkInfo.signal == NetworkSignal.strong) {
      networkDes = languageResource.normalSignalTips;
    } else if (phoneNetworkInfo.signal == NetworkSignal.moderate) {
      networkDes = languageResource.moderateSignalTips;
    } else if (phoneNetworkInfo.signal == NetworkSignal.weak) {
      networkDes = languageResource.poorSignalTips;
    } else {
      networkDes = languageResource.veryPoorSignalTips;
    }

    if (phoneNetworkInfo.packetLoss ?? false) {
      networkDes += '（${languageResource.lossPacketTips}）';
    }
    ctx.dispatch(NetworkCheckActionCreator.onUpdateResult(0, DiagnosticItemResult(networkDes, state: ResultState.pass)));
  } else {
    ctx.dispatch(NetworkCheckActionCreator.onUpdateResult(0, DiagnosticItemResult(languageResource.networkAbnormalityTips, state: ResultState.fail)));
    return;
  }

  ctx.dispatch(NetworkCheckActionCreator.onUpdateResult(1, DiagnosticItemResult(languageResource.checkingNetwork, state: ResultState.processing)));
  PingResponseInfo? serverConnectInfo = await _checkAppNetworkTask(ctx,['api.dropromo.com']);
  if(serverConnectInfo != null){
    String networkDes;
    if (serverConnectInfo.signal == NetworkSignal.strong) {
      networkDes = languageResource.serverNormal;
    } else if (serverConnectInfo.signal == NetworkSignal.moderate) {
      networkDes = languageResource.serverSlightlySlow;
    } else if (serverConnectInfo.signal == NetworkSignal.weak) {
      networkDes = languageResource.serverSlow;
    } else {
      networkDes = languageResource.serverVerySlow;
    }

    if (serverConnectInfo.packetLoss ?? false) {
      networkDes += '（${languageResource.lossPacketTips}）';
    }
    ctx.dispatch(NetworkCheckActionCreator.onUpdateResult(1, DiagnosticItemResult(networkDes,signal: serverConnectInfo.signal, state: ResultState.pass)));
  }else{
    ctx.dispatch(NetworkCheckActionCreator.onUpdateResult(1, DiagnosticItemResult(languageResource.serverAbnormality, state: ResultState.fail)));
  }

}

Future<PingResponseInfo?> _checkAppNetworkTask(Context<NetworkCheckState> ctx,List<String> hostAddresses) async {
  for (int i = 0; i < hostAddresses.length; i++) {
    Ping ping = Ping(hostAddresses[i], count: 5);
    PingResponseInfo pingResponseInfo = await _pingHost(ctx, ping);
    if (pingResponseInfo.enable) {
      return pingResponseInfo;
    }
  }
  return null;
}


Future<PingResponseInfo> _pingHost(Context<NetworkCheckState> ctx, Ping ping) {
  Completer<PingResponseInfo> completer = Completer();
  List<PingResponse> list = [];
  ctx.state.pingListener?.cancel();
  ctx.state.pingListener = ping.stream.listen((event) {
    print('ping info:$event');

    PingError? pingError = event.error;
    if(pingError != null){
      if(pingError.error == ErrorType.unknownHost){
        completer.complete(PingResponseInfo(false));
      }
      return;
    }

    PingResponse? response = event.response;
    if (response != null) {
      list.add(response);
    }
    PingSummary? summary = event.summary;


    if (summary != null) {
      if (summary.received == 0) {
        completer.complete(PingResponseInfo(false));
      } else {
        bool packetLoss = summary.transmitted != summary.received;
        int time = 0;
        int timeCount = 0;
        int totalTime = 0;
        for (int i = 0; i < list.length; i++) {
          final pingResponse = list[i];
          totalTime += pingResponse.time!.inMilliseconds;
          timeCount++;
        }
        time = totalTime ~/ timeCount;
        completer.complete(PingResponseInfo(true, time: time, packetLoss: packetLoss));
      }
    }
  });

  return completer.future;
}
