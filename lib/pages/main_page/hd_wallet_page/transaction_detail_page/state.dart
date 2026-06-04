import 'dart:ui';

import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../bean/blockchain/bit_coin_transaction_info.dart';

class TransactionDetailState implements LoadPageState<TransactionDetailState> {
  late CurrencyInfo wallet;
  List<TransactionsHistory> historyTransactions = [];
  RefreshController refreshController = RefreshController();
  late int type;
  late String walletAddress;

  @override
  TransactionDetailState clone() {
    return TransactionDetailState()
      ..wallet = wallet
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..type = type
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..refreshController = refreshController
      ..historyTransactions = historyTransactions;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg =
      "Current network is unstable. Please check your network and try again later.";

  @override
  LoadType loadStatus = LoadType.loading;
}

TransactionDetailState initState(Map<String, dynamic>? args) {
  CurrencyInfo wallet = args!['wallet'];
  var type = args['type'];
  // var walletManager = WalletState.getInstance().getWalletManager(wallet.currencyData.blockchain);
  // var recentTransactions = walletManager!.wallet.recentTransactions;
  // var list = recentTransactions.where((element) => element.amount.currencySymbol == wallet.currencyData.symbol).toList();
  return TransactionDetailState()
    // ..historyTransactions = list
    // ..walletAddress = walletManager.wallet.address
    ..type = type
    ..loadStatus = LoadType.loading
    ..wallet = wallet;
}
