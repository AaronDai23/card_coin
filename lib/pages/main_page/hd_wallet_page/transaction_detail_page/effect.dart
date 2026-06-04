import 'dart:math';

import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:fish_redux/fish_redux.dart';

// import '../../../../pigeons/tangem_platform_interface.dart';
import 'action.dart';
import 'state.dart';

Effect<TransactionDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<TransactionDetailState>>{
    Lifecycle.initState: _onInit,
    TransactionDetailAction.refresh: _onRefresh,
  });
}

Future<void> _onInit(Action action, Context<TransactionDetailState> ctx) async {
  var wallet = ctx.state.wallet;
  var currencyData = wallet.currencyData;
  var current = CurrencyInfoMessage(
      id: currencyData.id,
      icon: currencyData.icon,
      name: currencyData.name,
      networkId: currencyData.networkId,
      networkName: wallet.networkName,
      networkIcon: "",
      symbol: currencyData.symbol,
      contractAddress: currencyData.contractAddress,
      address: wallet.address);
  var request = TransactionHistoryRequest(
      address: wallet.address!,
      page: "1",
      type: ctx.state.type,
      currencyInfo: current);
  var result =
      await BlockchainPlatform.instance.loadTransactionHistoryList(request);
  List<TransactionsHistory?> list = result;
  List<TransactionsHistory> historyTransactions = [];
  for (var e in list) {
    if (e != null && e.direction == ctx.state.type) {
      historyTransactions.add(e);
    }
  }

  ctx.dispatch(
      TransactionDetailActionCreator.onLoadSuccess(historyTransactions));
  // DateFormat format = DateFormat();
}

Future<void> _onRefresh(
    Action action, Context<TransactionDetailState> ctx) async {
  Future.delayed(const Duration(seconds: 1))
      .then((value) => ctx.state.refreshController.refreshCompleted());

  var wallet = ctx.state.wallet;
  var currencyData = wallet.currencyData;
  var current = CurrencyInfoMessage(
      id: currencyData.id,
      icon: currencyData.icon,
      name: currencyData.name,
      networkId: currencyData.networkId,
      networkName: wallet.networkName,
      networkIcon: "",
      symbol: currencyData.symbol,
      contractAddress: currencyData.contractAddress,
      address: wallet.address);
  var request = TransactionHistoryRequest(
      address: wallet.address!,
      page: "1",
      type: ctx.state.type,
      currencyInfo: current);
  var result =
      await BlockchainPlatform.instance.loadTransactionHistoryList(request);
  List<TransactionsHistory?> list = result;
  List<TransactionsHistory> historyTransactions = [];
  for (var e in list) {
    if (e != null) {
      if (e.direction == ctx.state.type) {
        historyTransactions.add(e);
      }
    }
  }

  ctx.dispatch(
      TransactionDetailActionCreator.onLoadSuccess(historyTransactions));
}
