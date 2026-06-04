
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../pigeons/blockchain_platform_interface.dart';
import 'action.dart';
import 'item_state.dart';
import 'state.dart';

Effect<SelectCurrencyState>? buildEffect() {
  return combineEffects(<Object, Effect<SelectCurrencyState>>{
    Lifecycle.initState: _onInit,
    SelectCurrencyAction.action: _onAction,
    SelectCurrencyAction.showNotSaveTips: _onShowNotSaveTips,
    SelectCurrencyAction.saveClick: _onSaveClick,
    SelectCurrencyAction.loadData: _onLoadData,
    // SelectCurrencyAction.loadTestData: _onLoadTestData,
    SelectCurrencyAction.refresh: _onRefresh,
    SelectCurrencyAction.loading: _onLoading,
    // SelectCurrencyAction.textChanged: _onTextChanged,
  });
}

Future<void> _onRefresh(Action action, Context<SelectCurrencyState> ctx) async {
  ctx.state.page = 1;
  ctx.dispatch(SelectCurrencyActionCreator.onLoadData());
}

Future<void> _onLoading(Action action, Context<SelectCurrencyState> ctx) async {
  ctx.state.page += 1;
  final result = await HttpManager.getInstance().get(
      NetworkAddress.cryptoListUrl,
      queryParameters: {'page': ctx.state.page, 'row': 20});
  if (result.isSuccess) {
    LogUtil.d('result.data:${result.data}');
    List<CoinMessage> tokens = (result.data['rows'] as List)
        .map((e) => CoinMessage.fromJson(e))
        .toList()
        .cast<CoinMessage>();
    if (tokens.isEmpty) {
      ctx.state.page -= 1;
      ctx.state.refreshController.loadComplete();
      return;
    }
    int page = ctx.state.page;
    if (page == 1) {
      final coinList = tokens.map((e) {
        bool isSelected = ctx.state.selectCurrencyList
            .any((element) => element.currencyData.id == e.id);
        CurrencyCoin coin = CurrencyCoin(
            id: e.id,
            icon: e.imageUrl,
            name: e.name,
            symbol: e.symbol,
            tokenNetworks: e.networks);
        final itemState = NetworkItemState()
          ..bean = coin
          ..isSelected = isSelected;
        return itemState;
      }).toList();
      ctx.dispatch(SelectCurrencyActionCreator.onLoadSuccess(coinList));
    } else {
      List<NetworkItemState> currentCoinList = ctx.state.coinList;
      final coinList = tokens.map((e) {
        bool isSelected = ctx.state.selectCurrencyList
            .any((element) => element.currencyData.id == e.id);
        CurrencyCoin coin = CurrencyCoin(
            id: e.id,
            icon: e.imageUrl,
            name: e.name,
            symbol: e.symbol,
            tokenNetworks: e.networks);

        final itemState = NetworkItemState()
          ..bean = coin
          ..isSelected = isSelected;
        return itemState;
      }).toList();
      currentCoinList.addAll(coinList);
      // if (coinList.isEmpty) {
      //   ctx.dispatch(SelectCurrencyActionCreator.onLoadFailed(
      //       "Currency not configured"));
      // } else {
      ctx.dispatch(SelectCurrencyActionCreator.onLoadSuccess(currentCoinList));
      // }
    }
  } else {
    ctx.state.page -= 1;
    ctx.dispatch(SelectCurrencyActionCreator.onLoadFailed(result.message));
  }
  ctx.state.refreshController.loadComplete();
}

// Future<void> _onLoadTestData(
//     Action action, Context<SelectCurrencyState> ctx) async {
//   var tokensJson = await rootBundle.loadString('assets/data/tokens.json');

//   final tokenMap = json.decode(tokensJson);
//   List<CoinMessage> tokens = (tokenMap['coins'] as List)
//       .map((e) => CoinMessage.fromJson(e))
//       .toList()
//       .cast<CoinMessage>();

//   final coinList = tokens.map((e) {
//     final networkList = e.networks.map((network) {
//       bool isSelected = ctx.state.selectCurrencyList.any((element) =>
//           element.currencyData.id == e.id &&
//           element.currencyData.networkId == network.networkId);
//       final itemState = NetworkItemState()
//         ..bean = network
//         ..isSelected = isSelected;
//       return itemState;
//     }).toList();
//     return CurrencyCoin(
//         id: e.id,
//         icon: e.imageUrl,
//         name: e.name,
//         symbol: e.symbol,
//         tokenNetworks: networkList);
//   }).toList();

//   ctx.dispatch(SelectCurrencyActionCreator.onLoadSuccess(coinList));
// }

Future<void> _onLoadData(
    Action action, Context<SelectCurrencyState> ctx) async {
  final result = await HttpManager.getInstance()
      .get(NetworkAddress.cryptoListUrl, queryParameters: {
    'page': ctx.state.page,
    'row': 20,
    'uid': ctx.state.uid
  });
  if (result.isSuccess) {
    LogUtil.d('result.data:${result.data}');
    List<CoinMessage> tokens = (result.data['rows'] as List)
        .map((e) => CoinMessage.fromJson(e))
        .toList()
        .cast<CoinMessage>();

    final coinList = tokens.map((e) {
      bool isSelected = ctx.state.selectCurrencyList
          .any((element) => element.currencyData.id == e.id);
      CurrencyCoin coin = CurrencyCoin(
          id: e.id,
          icon: e.imageUrl,
          name: e.name,
          symbol: e.symbol,
          tokenNetworks: e.networks);
      final itemState = NetworkItemState()
        ..bean = coin
        ..isSelected = isSelected;
      return itemState;
    }).toList();

    ctx.dispatch(SelectCurrencyActionCreator.onLoadSuccess(coinList));
  } else {
    ctx.dispatch(SelectCurrencyActionCreator.onLoadFailed(result.message));
  }
  ctx.state.refreshController.refreshCompleted();
}

Future<void> _onInit(Action action, Context<SelectCurrencyState> ctx) async {
  ctx.dispatch(SelectCurrencyActionCreator.onLoadData());
  // ctx.dispatch(SelectCurrencyActionCreator.onLoadTestData());
}

Future<void> _onSaveClick(
    Action action, Context<SelectCurrencyState> ctx) async {
  String selectedStatusStr = ctx.state.coinList.map((e) => e.isSelected).join(',');
  if(selectedStatusStr == ctx.state.selectedStatusStr){
    Navigator.of(ctx.context).pop();
    return;
  }

  List<CurrencyInfo> selectCurrencyList = [];

  for (var coinItem in ctx.state.coinList) {
    if (coinItem.isSelected) {
      final selectItems = coinItem.bean.tokenNetworks;
      final currencyList = selectItems.map((e) {
        return CurrencyInfo(
            imageUrl: coinItem.bean.icon,
            currencyData: CurrencyData(coinItem.bean.id, e.imageUrl,
                coinItem.bean.name, coinItem.bean.symbol, e.networkId,
                decimals: e.decimalCount, contractAddress: e.contractAddress));
      }).toList();
      selectCurrencyList.addAll(currencyList);
    }
  }

  ///请求数字币数据
  final scanResponse = await BlockchainPlatform.instance
      .addCurrencyList(currencyList: selectCurrencyList);
  if (scanResponse.isSuccess) {
    Navigator.of(ctx.context).pop(selectCurrencyList);
  } else {
    showToast(scanResponse.message ?? '');

    if (scanResponse.message != null &&
        scanResponse.message!.contains("uid not same")) {
      showToast(scanResponse.message!);
    } else {
      showToast(scanResponse.message ?? '');
    }
  }
}

void _onAction(Action action, Context<SelectCurrencyState> ctx) {}

Future<void> _onShowNotSaveTips(Action action, Context<SelectCurrencyState> ctx) async {
  var result = await showDialog(context: ctx.context, builder: (context){
    var languageResource = ctx.state.languageResource!;
    return ZenggeTextAlertDialog(languageResource.notSaveTips,enableCancel: true,);
  });
  if(result == true){
    Navigator.of(ctx.context).pop();
  }
}
