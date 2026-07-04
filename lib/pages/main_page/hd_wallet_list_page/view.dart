import 'package:card_coin/app.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/item_state.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/utils/cryptos_prices_utils.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/device_info_card.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    HDWalletListState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  bool isProApp = AppConfig.of(navigatorKey.currentContext!).isProApp;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text('AirChip3'),
      leading: IconButton(
          onPressed: () {
            dispatch(HDWalletListActionCreator.onShowCardInfoList());
          },
          icon: const Icon(Icons.account_balance_wallet_rounded)),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(viewService.context)
                  .pushNamed('settingsPage', arguments: {
                'cardId': state.cardInfoList[state.currentIndex].cardId,
                'cardInfo': state.cardInfoList[state.currentIndex]
              });
            },
            icon: const Icon(Icons.settings))
      ],
    ),
    body: PageDataLoadingView(
      onLoadSuccess: () {
        final cardDetail = state.cardInfo.cardDetail;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 230,
              child: cardDetail != null
                  ? DeviceInfoCard(
                      cardDetail: cardDetail,
                      nickname: state.cardInfoList
                          .elementAt(state.currentIndex)
                          .nickName,
                      editNameClick: () => dispatch(
                          HDWalletListActionCreator.onShowNickNameAlert()),
                    )
                  : const SizedBox(),
            ),
            Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          state.currentFiat.symbol == 'USDT'
                              ? languageResource.totalBalance
                              : languageResource.totalFiatBalance,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12, height: 1.2),
                        ),
                        const Expanded(
                          child: Text(''), // 中间用Expanded控件
                        ),
                        InkWell(
                          onTap: () {
                            dispatch(
                                HDWalletListActionCreator.onUpdateCurrency());
                          },
                          child: Row(
                            children: [
                              Text(
                                state.currentFiat.symbol,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Transform.scale(
                                scaleY: -1,
                                child: const Icon(Icons.expand_less),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                          // ignore: prefer_interpolation_to_compose_strings
                          text: "${state.currentFiat.symbol} " +
                              CryptosPriceUtils.cryptoTotalPrice(
                                  state.cryptoTotalPrice, 0),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                // ignore: prefer_interpolation_to_compose_strings
                                text: "." +
                                    CryptosPriceUtils.cryptoTotalPrice(
                                        state.cryptoTotalPrice, 1),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ]),
                      textDirection: TextDirection.ltr,
                    ),
                    enabled: true,
                    onTap: () {
                      // dispatch(HdWalletActionCreator.onShowNickNameAlert());
                    },
                  ),
                  state.showLightningNet
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 15, bottom: 10, top: 1, right: 1),
                          child: Row(
                            children: [
                              Text(
                                  state.flashBalanceDetail != null
                                      ? '+${NumberUtils.formatNumber(num.parse(state.flashBalanceDetail!.amountValue), 10)} ${state.flashBalanceDetail!.amountUnit} ~(\$ ${state.flashBalanceDetail!.usd}) (${state.homeSeconds}s)'
                                      : "+ 0 ~(\$ 0)",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      height: 1.2)),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(viewService.context).pushNamed(
                                      'lightningNetDetailPage',
                                      arguments: {
                                        'uid': state.cardInfo.cardDetail!.uid
                                      });
                                },
                                child: Text('Detail',
                                    style: TextStyle(
                                        color: AppConfig.of(navigatorKey
                                                        .currentContext!)
                                                    .appInternalId ==
                                                AppType.bestWish
                                            ? Colors.blue
                                            : Colors.orange,
                                        fontSize: 12,
                                        height: 1.2)),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                onRefresh: () =>
                    dispatch(HDWalletListActionCreator.onRefresh()),
                controller: state.refreshController,
                child: state.currencyList.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final itemState = state.currencyList[index];
                          CurrencyInfo bean = itemState.bean;
                          return GestureDetector(
                            onTap: itemState.loadType == LoadType.loadSuccess
                                ? () => dispatch(
                                    HDWalletListActionCreator.onBlockchainClick(
                                        bean))
                                : null,
                            onLongPress: () {
                              dispatch(
                                  HDWalletListActionCreator.onItemLongPress(
                                      bean));
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      _buidlImageView(itemState),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bean.currencyData.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0),
                                            ),
                                            Text(
                                              "${state.currentFiat.symbol} ${CryptosPriceUtils.cryptoPairPrice(state.currentFiat, state.cryptosPriceMap, bean, 0)}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      itemState.loadType == LoadType.loadSuccess
                                          ? Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${state.currentFiat.symbol} ${itemState.bean.balance != null ? NumberUtils.getCountBetweenThreeNumber("1", CryptosPriceUtils.cryptoPairPrice(state.currentFiat, state.cryptosPriceMap, itemState.bean, 1), itemState.bean.balance!, 2) : "--"}",
                                                      style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black)),
                                                  Text(
                                                      "${itemState.bean.currencyData.symbol} ${itemState.bean.balance != null ? NumberUtils.getFullCount(itemState.bean.balance!) : '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            )
                                          : itemState.loadType ==
                                                  LoadType.loadFailure
                                              ? const Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Load failed',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ]))
                                              : const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                      itemState.loadType == LoadType.loadSuccess
                                          ? const Expanded(
                                              flex: 1,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('...',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ))
                                                  ]))
                                          : const SizedBox(
                                              width: 5,
                                              height: 5,
                                            )
                                    ],
                                  )),
                            ),
                          );
                        },
                        itemCount: state.currencyList.length)
                    : const EmptyListView(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CCButton(
                  onPressed: () {
                    if (isProApp) {
                      dispatch(
                          HDWalletListActionCreator.onAddBlockchainClick());
                    } else {
                      dispatch(HDWalletListActionCreator.onAddBlockchainTip());
                    }
                  },
                  child: Center(
                      child: Text(
                    languageResource.addBlockchain,
                    style:
                        isProApp ? const TextStyle(color: Colors.white) : null,
                  ))),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      },
      loadStatus: state.loadStatus,
    ),
  );
}

Widget _buidlImageView(CurrencyItemState itemState) {
  CurrencyInfo bean = itemState.bean;

  return Stack(
    children: [
      ClipOval(
        //圆形头像
        child: LoadImage(
          bean.imageUrl,
          width: 20.0,
          height: 20.0,
          holderImg: const SizedBox(
            height: 10,
            width: 10,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    ],
  );
}
