import 'dart:async';
import 'dart:ui';
import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/http/requestCanceler.dart';

class CheckCardState implements GlobalBaseState<CheckCardState> {
  late List<HealthCheckInfo> checkList = [];
  RequestCanceler canceler = RequestCanceler();
  String cardId = "";
  double percent = 0.0;
  int count = 0;
  bool showScanTip = false;
  int failCount = 0;
  int from = -1;
  bool fromDeepLink = false; // true 时隐藏顶部返回按钮（从浏览器 deeplink 跳入）
  Timer? timer;
  // late CardInfo cardInfo;
  String? cardNum;
  Completer<bool>? completer;
  // late bool isStarted = false;
  @override
  CheckCardState clone() {
    return CheckCardState()
      ..checkList = checkList
      ..cardId = cardId
      ..completer = completer
      ..count = count
      ..cardNum = cardNum
      ..percent = percent
      ..timer = timer
      ..showScanTip = showScanTip
      ..failCount = failCount
      ..canceler = canceler
      ..fromDeepLink = fromDeepLink
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..from = from;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

CheckCardState initState(Map<String, dynamic>? args) {
  final state = CheckCardState();
  state.fromDeepLink = args?['fromDeepLink'] == true;
  return state;
}
