import 'dart:ui';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/investment_config.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_active_page/action.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class InvestmentActiveState
    implements GlobalBaseState<InvestmentActiveState>, PageLoad {
  List<CurrencyInfo> defaultCurrencyList = [];
  late String cardId;
  bool needBTC = false;
  bool needShowInitStatus = false;
  InvestmentConfig? investmentConfig;

  bool sysnWallet = false;
  bool activteSucc = false;
  bool isSingle = false;
  bool pushed = false;
  ActivitedStatus activeStatus = ActivitedStatus.PreActivite;

  String activedErrorMsg = '';
  String activedSignId = '';
  String activedSignMessage = '';
  String activedSignReslut = '';
  String activedDSignId = '';
  String activedDSignMessage = '';
  String activedDSignReslut = '';
  List<CurrencyInfo> wallets = [];

  String? intervalExtend1;
  String? intervalExtend2;
  String? intervalExtend3;
  String? assetFrom;
  int progress = 0;
  String address = '';
  String id = '';

  @override
  InvestmentActiveState clone() {
    return InvestmentActiveState()
      ..errorMsg = errorMsg
      ..cardId = cardId
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..loadStatus = loadStatus
      ..needBTC = needBTC
      ..needShowInitStatus = needShowInitStatus
      ..defaultCurrencyList = defaultCurrencyList
      ..investmentConfig = investmentConfig
      ..wallets = wallets
      ..sysnWallet = sysnWallet
      ..activteSucc = activteSucc
      ..activeStatus = activeStatus
      ..activedErrorMsg = activedErrorMsg
      ..pushed = pushed
      ..activedSignId = activedSignId
      ..activedSignMessage = activedSignMessage
      ..activedDSignId = activedDSignId
      ..activedSignReslut = activedSignReslut
      ..activedDSignMessage = activedDSignMessage
      ..activedDSignReslut = activedDSignReslut
      ..assetFrom = assetFrom
      ..address = address
      ..progress = progress
      ..isSingle = isSingle
      ..id = id
      ..intervalExtend1 = intervalExtend1
      ..intervalExtend2 = intervalExtend2
      ..intervalExtend3 = intervalExtend3;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;
}

InvestmentActiveState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  bool needShowInitStatus = false;
  needShowInitStatus = args['needShowInitStatus'] ?? false;
  String? intervalExtend1 = args['intervalExtend1'];
  String? intervalExtend2 = args['intervalExtend2'];
  String? intervalExtend3 = args['intervalExtend3'];

  String? assetFrom = args['intervalExtend3'];
  bool? isSingle = args['isSingle'];
  print(
      'intervalExtend1:$intervalExtend1,intervalExtend2:$intervalExtend2,intervalExtend3:$intervalExtend3');

  InvestmentConfig? investmentConfig = args['investmentConfig'];
  String id = args['id'] ?? '';
  return InvestmentActiveState()
    ..cardId = cardId
    ..needShowInitStatus = needShowInitStatus
    ..investmentConfig = investmentConfig
    ..assetFrom = assetFrom
    ..isSingle = isSingle ?? false
    ..id = id
    ..intervalExtend1 = intervalExtend1
    ..intervalExtend2 = intervalExtend2
    ..intervalExtend3 = intervalExtend3;
}
