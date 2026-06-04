import 'dart:async';
import 'dart:ui';

import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/bean/light_spark_transactions.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LightningNetDetailState
    implements LoadPageState<LightningNetDetailState> {
  String uid = "";
  int currentPage = 1;
  Timer? homeTimer;

  int homeSeconds = 60;
  @override
  LightningNetDetailState clone() {
    return LightningNetDetailState()
      ..refreshController = refreshController
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..uid = uid
      ..historyTransactions = historyTransactions
      ..flashBalanceDetail = flashBalanceDetail
      ..homeTimer = homeTimer
      ..homeSeconds = homeSeconds
      ..languageResource = languageResource;
  }

  @override
  String errorMsg = '';

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  LoadType loadStatus = LoadType.loading;

  RefreshController refreshController = RefreshController();

  List<LightSparkTransactions> historyTransactions = [];

  FlashBalance? flashBalanceDetail;
}

LightningNetDetailState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  return LightningNetDetailState()..uid = uid;
}
