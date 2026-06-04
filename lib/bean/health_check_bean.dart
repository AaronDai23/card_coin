import 'package:flutter/services.dart';

class CardHealthCommonStatus {
  late String uuid;
  late String cardVersion;
  late bool isLock;
  late bool disable;
  late bool keyPairGenerated;
  late bool pinSet;
  late int pinRemaining;
  late int pukRemaining;
  // late String ndefUrl;
  late int signTimes;
  late String cardVersionCode;
  late bool isActivated;
  late int exportTimes;
  late int rescoutCount;
  late String uid;
  //HD 拍卡次数
  late int hdTapTimes = 0;
  //NDEF 拍卡次数
  late int ndefTapTimes = 0;

  CardHealthCommonStatus.fromData(this.uuid, Uint8List data) {
    // 初始化默认值，防止 late 字段未赋值
    keyPairGenerated = false;
    pinSet = false;
    pinRemaining = 0;
    pukRemaining = 0;
    isLock = false;
    disable = false;
    cardVersion = '';
    signTimes = 0;
    cardVersionCode = '';
    isActivated = false;
    exportTimes = 0;
    rescoutCount = 0;
    uid = '';

    // 顺序 TLV 解析，避免 indexOf 误命中数据域内字节
    // 响应格式：[tag][length][value...] 逐段读取，末尾 90 00 为状态字
    int i = 0;
    while (i + 1 < data.length) {
      final int tag = data[i];
      final int length = data[i + 1];
      if (i + 2 + length > data.length) break;
      final Uint8List value = data.sublist(i + 2, i + 2 + length);

      switch (tag) {
        case 0x99:
          // 1. 是否生成了密钥对
          keyPairGenerated = value[0] != 0;
          break;
        case 0x9A:
          // 2. 是否创建了 PIN
          pinSet = value[0] != 0;
          break;
        case 0x9C:
          // 4. PIN 剩余次数
          pinRemaining = value[0];
          break;
        case 0x9D:
          // 5. PUK 剩余次数
          pukRemaining = value[0];
          break;
        case 0x9E:
          // 6. 卡片是否被锁住
          isLock = value[0] != 0;
          break;
        case 0x9F:
          // 7. 卡片是否失效
          disable = value[0] != 0;
          break;
        case 0xA0:
          // 8. Applet 版本号
          cardVersion = String.fromCharCodes(value);
          break;
        case 0xA1:
          // 9. 签名次数（大端 int）
          final signHex =
              value.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
          signTimes = BigInt.parse(signHex, radix: 16).toInt();
          break;
        case 0xA2:
          // 版本码
          cardVersionCode = String.fromCharCodes(value);
          break;
        case 0xA3:
          // 10. 导出次数（大端 int）
          final exportHex =
              value.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
          exportTimes = BigInt.parse(exportHex, radix: 16).toInt();
          break;
        case 0xA4:
          // 11. 重置次数（大端 int）
          final rescoutHex =
              value.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
          rescoutCount = BigInt.parse(rescoutHex, radix: 16).toInt();
          break;
        case 0xA5:
          // 12. UID（十六进制字符串，大写，空格分隔）
          uid = value
              .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
              .join(' ');
          break;
        case 0xA6:
          // 13. HD 拍卡次数（大端 int）
          final hdHex =
              value.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
          hdTapTimes = BigInt.parse(hdHex, radix: 16).toInt();
          break;
        case 0xA7:
          // 14. NDEF 拍卡次数（大端 int）
          final ndefHex =
              value.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
          ndefTapTimes = BigInt.parse(ndefHex, radix: 16).toInt();
          break;
        case 0x90:
          // 状态字 90 00，解析结束
          i = data.length;
          continue;
      }
      i += 2 + length;
    }

    print('keyPairGenerated:$keyPairGenerated pinSet:$pinSet'
        ' rescoutCount:$rescoutCount uid:$uid');
  }
}

enum HealthStatus { none, process, health, unHealth, failed }

enum HealthCheckType {
  cardVendorCheck,
  cardNumber,
  cardVersion,
  cardLock,
  cardDisable,
  keyPairGenerated,
  deriveInfo,
  signature,
  pinSet,
  pinRemaining,
  pukRemaining,
  ndefPrefix,
  signTimes,
  shareVersion,
  ndefVersion,
  cardVersionCode,
  uid,
  exportTimes,
  restoreTimes,
  syncUid,
  hdTapTimes,
  ndefTapTimes
}

enum TaskStatus { none, process, success, failed }

enum HealthCheckTask {
  cardVendor,
  cardNumber,
  deriveInfo,
  signature,
  commonStatus,
  shareVersion,
  ndefVersion,
  ndefPrefix,
}

class TaskInfo {
  late HealthCheckTask type;
  late TaskStatus status;

  TaskInfo(this.type, {this.status = TaskStatus.none});
}

class HealthCheckInfo {
  late HealthCheckType type;
  late String name;
  late HealthStatus status;
  String? result;

  dynamic get value {
    if (result == 'Yes') {
      return true;
    } else if (result == 'No') {
      return false;
    } else if (result == 'empty' || result == 'Empty') {
      return "";
    } else if (type == HealthCheckType.cardNumber) {
      return result;
    } else if (result != null && int.tryParse(result!) != null) {
      return int.tryParse(result!);
    } else {
      return result ?? false;
    }
  }

  HealthCheckInfo(
      {required this.name,
      required this.type,
      this.status = HealthStatus.none,
      this.result});

  HealthCheckInfo copyWith({HealthStatus? status, String? result}) {
    return HealthCheckInfo(
        name: name,
        type: type,
        status: status ?? this.status,
        result: result ?? this.result);
  }

  // HealthCheckInfo.fromJson(Map<String, dynamic> json) {
  //   symbol = json['symbol'];

  // }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['name'] = name;
  //   data['id'] = this.id;
  //   data['status'] = this.status;
  //   data['content'] = this.content;
  //   data['color'] = this.color;
  //   return data;
  // }
}
