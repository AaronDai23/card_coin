import 'dart:convert';
import 'dart:io';

import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/biometrics_info.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/http/result_data.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

Effect<BiometricsState>? buildEffect() {
  return combineEffects(<Object, Effect<BiometricsState>>{
    Lifecycle.initState: _onInit,
    BiometricsAction.toggleBiometric: _onToggleBiometric,
    BiometricsAction.unBindBiometricStatus: _onUnBindBiometric,
    BiometricsAction.bindBiometricDetail: _onBiometriceDetail,
  });
}

Future<void> _onInit(Action action, Context<BiometricsState> ctx) async {
  ctx.dispatch(BiometricsActionCreator.onBindBiometricDetail());
}

Future<void> _onToggleBiometric(
    Action action, Context<BiometricsState> ctx) async {
  if (!ctx.state.isBiometricEnabled) {
    ProgressDialog pr = ProgressDialog(ctx.context);
    pr.show();

    var pubKey = await BlockchainPlatform.instance.generateKey();
    print("create key suc-pubkey: $pubKey");
    ctx.state.publicKey = pubKey;
    await _getDeviceId(pubKey);

    // 绑定生物识别
    bool bindResult = await bindBiometric(pubKey);
    pr.hide();
    if (bindResult) {
      var storage = const FlutterSecureStorage();
      UserInfo? userInfo = await LocalStorage.getUserInfo();

      await storage.write(
          key: 'isBiometricEnabled', value: '${userInfo!.customer!.id}');
      print("绑定生物识别成功，保存状态: ${userInfo.customer!.id}");
      var currid = await storage.read(key: 'isBiometricEnabled');
      print("读取保存的状态: $currid");
      ctx.dispatch(BiometricsActionCreator.onLoadSuccess(true));
    }
  }
}

Future<String> _getDeviceId(String pubKeyBase64) async {
  var storage = const FlutterSecureStorage();
  var id = await storage.read(key: 'device_id');
  if (id != null && id.isNotEmpty) return id;

  final uuid = const Uuid().v4();
  final hash =
      sha256.convert(utf8.encode(pubKeyBase64)).toString().substring(0, 16);
  final deviceId = '${uuid.substring(0, 8)}-$hash';
  await storage.write(key: 'device_id', value: deviceId);
  print('生成 deviceId: $deviceId');
  return deviceId;
}

/// 登录成功后绑定人脸（生成密钥并上传公钥）
Future<bool> bindBiometric(String pubKeyBase64) async {
  final auth = LocalAuthentication();
  try {
    final supported = await auth.isDeviceSupported();
    if (supported) {
      print('Device supports biometrics');
    }
    if (!supported) return false;
    var result = await loginWithFaceID(pubKeyBase64);
    return result;
  } catch (e) {
    print('bindBiometric error: $e');
    return false;
  }
}

/// 使用 Face ID 登录
Future<bool> loginWithFaceID(String pubKeyBase64) async {
  var storage = const FlutterSecureStorage();
  print('loginWithFaceID1');
  try {
    print('loginWithFaceID2');
    final deviceId = await storage.read(key: 'device_id');

    // 从服务器请求 challenge
    var result = await HttpManager.getInstance()
        .post(NetworkAddress.challenge, null, data: {
      'deviceId': deviceId,
      'challengeType': Platform.isAndroid ? 'TOUCH_ID' : 'FACE_ID'
    });
    if (!result.isSuccess) return false;
    final challenge = result.data['challenge'];
    print('🪪 获取 challenge: $challenge');
    // 调用原生 iOS 插件签名 challenge（会触发 Face ID）
    final signatureBase64 =
        await BlockchainPlatform.instance.signChallenge(challenge);
    final userInfo = await LocalStorage.getUserInfo();
    if (userInfo == null) return false;

    // 上传签名给服务器验证
    final result1 = await _verifySignatureOnServer(
        challenge, deviceId!, signatureBase64, pubKeyBase64);

    if (result1.isSuccess) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('loginWithFaceID error: $e');
    return false;
  }
}

Future<ResultData> _verifySignatureOnServer(String challenge, String deviceId,
    String signatureBase64, String pubKeyBase64) async {
  // 实际上服务器会用存储的公钥验签
  print(
      "服务器验证签名 challenge=$challenge device=$deviceId sig=$signatureBase64, pubKey=$pubKeyBase64");
  var result = await HttpManager.getInstance().post(
    NetworkAddress.bindBiometrics,
    null,
    data: {
      'deviceId': deviceId,
      'challenge': challenge,
      'challengeType': Platform.isAndroid ? 'TOUCH_ID' : 'FACE_ID',
      'signResult': signatureBase64,
      "publicKey": pubKeyBase64
    },
  );
  print("服务器返回验证结果:绑定生物识别成功： ${result.isSuccess}");
  if (!result.isSuccess) {
    showToast("绑定生物识别失败，请重试:\n${result.message}");
  }
  return result;
}

Future<void> _onUnBindBiometric(
    Action action, Context<BiometricsState> ctx) async {
  // 实际上服务器会用存储的公钥验签
  ProgressDialog pr = ProgressDialog(ctx.context);
  pr.show();
  var result = await HttpManager.getInstance().post(
    NetworkAddress.unbindBiometrics,
    null,
    data: {
      'challengeType': Platform.isAndroid ? 'TOUCH_ID' : 'FACE_ID',
    },
  );
  pr.hide();
  if (result.isSuccess) {
    print("解绑生物识别成功");
    var storage = const FlutterSecureStorage();

    await storage.write(key: 'device_id', value: '');
    await storage.write(key: 'isBiometricEnabled', value: '');

    ctx.dispatch(BiometricsActionCreator.onLoadSuccess(false));
  }
}

Future<void> _onBiometriceDetail(
    Action action, Context<BiometricsState> ctx) async {
  // 实际上服务器会用存储的公钥验签

  var result =
      await HttpManager.getInstance().get(NetworkAddress.biometricDetail);
  if (result.isSuccess) {
    List<BiometricsInfo> biometricsList = [];
    for (var item in result.data) {
      biometricsList.add(BiometricsInfo.fromJson(item));
    }

    var storage = const FlutterSecureStorage();

    var customerId = await storage.read(key: 'isBiometricEnabled');
    var deviceId = await storage.read(key: 'device_id');
    print("isBiometricEnabled=$customerId, device_id=$deviceId");
    if (customerId == null || customerId.isEmpty) {
      ctx.dispatch(BiometricsActionCreator.onLoadSuccess(false));
      return;
    }

    bool isEnabled = false;
    for (var info in biometricsList) {
      print(
          "biometricsName=${info.biometricsName}, biometricsType=${info.biometricsType}, deveiceId=${info.deviceId}, customerId=${info.customerId}, enable=${info.enable}");
      if (info.enable == true) {
        if (info.customerId == customerId && info.deviceId == deviceId) {
          isEnabled = true;
          break;
        }
      }
    }
    if (isEnabled) {
      print("获取生物识别详情成功222");
      ctx.dispatch(BiometricsActionCreator.onLoadSuccess(true));
    } else {
      print("获取生物识别详情成功4444");
      var storage = const FlutterSecureStorage();

      await storage.write(key: 'isBiometricEnabled', value: '');
      ctx.dispatch(BiometricsActionCreator.onLoadSuccess(false));
    }

    print("获取生物识别详情成功");
  } else {
    print("获取生物识别详情失败");
  }
}
