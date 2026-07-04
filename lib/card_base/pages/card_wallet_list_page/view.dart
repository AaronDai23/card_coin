import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:collection/collection.dart';

import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../custom_widget/load_image.dart';
import '../../../pages/main_page/hd_wallet_list_page/item_state.dart';
import '../../../pages/main_page/hd_wallet_page/utils/cryptos_prices_utils.dart';
import '../../../utils/number_util.dart';
import '../../../widget/base_page_loading.dart';
import '../../../widget/device_info_card.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CardWalletListState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  // 使用 MediaQuery 获取屏幕宽度
  double screenWidth = MediaQuery.of(viewService.context).size.width;
  CurrencyInfo? btcInfo = state.cardInfo.wallets.firstWhereOrNull(
      (element) => element.currencyData.id.toLowerCase() == "btc");

  if (btcInfo != null && btcInfo.isHide == true) {}
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text('ChipBase Wallet'),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(viewService.context).pushNamed('settingsPage',
                  arguments: {
                    'cardId': state.cardInfo.cardId,
                    'cardInfo': state.cardInfo
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
            state.isIncompatible == false
                ? const SizedBox()
                : SizedBox(
                    width: screenWidth,
                    height: 20,
                    child: InkWell(
                      child: Marquee(
                        text: state.incompatibleTip,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            backgroundColor: AppConfig.of(viewService.context)
                                        .appInternalId !=
                                    AppType.bestWish
                                ? const Color(0xFFBBDEFB) // light blue
                                : Colors.yellow[200]),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20.0,
                        velocity: 100.0,
                        pauseAfterRound: const Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: const Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                      onTap: () {
                        dispatch(CardWalletListActionCreator
                            .onShowIncompatibleHelpAction());
                      },
                    ),

                    // ),
                  ),
            state.isIncompatible == false
                ? const SizedBox()
                : const SizedBox(
                    height: 10,
                  ),
            SizedBox(
              height: 210,
              child: cardDetail != null
                  ? DeviceInfoCard(
                      cardDetail: cardDetail,
                      nickname: state.cardInfo.nickName,
                      editNameClick: () => dispatch(
                          CardWalletListActionCreator.onShowNickNameAlert()),
                    )
                  : const _TopCardWaveSkeleton(),
            ),
            Visibility(
                visible: state.cardInfo.nickName.isEmpty,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: ListTile(
                    leading: const Icon(Icons.report_problem,
                        color: Colors.orange, size: 26),
                    title: Text(languageResource.changeWalletNickNameTip,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    enabled: true,
                    onTap: () {
                      dispatch(
                          CardWalletListActionCreator.onShowNickNameAlert());
                    },
                  ),
                )),
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
                                CardWalletListActionCreator.onUpdateCurrency());
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
                                      ? '+${NumberUtils.formatNumber(num.tryParse(state.flashBalanceDetail!.amountValue)!, 10)} ${state.flashBalanceDetail!.amountUnit} (${state.flashBalanceDetail!.usdDisplayAmount}) (${state.homeSeconds}s)'
                                      : "+ 0 (~\$ 0)",
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
                                child: const Text('Detail',
                                    style: TextStyle(
                                        color: Colors.orange,
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
                    dispatch(CardWalletListActionCreator.onRefresh()),
                controller: state.refreshController,
                child: state.currencyList.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final itemState = state.currencyList[index];
                          CurrencyInfo bean = itemState.bean;
                          return GestureDetector(
                            onTap: itemState.loadType == LoadType.loadSuccess
                                ? () => dispatch(CardWalletListActionCreator
                                    .onBlockchainClick(bean))
                                : null,
                            onLongPress: () {
                              dispatch(
                                  CardWalletListActionCreator.onItemLongPress(
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
                                      _buildImageView(itemState),
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: CCButton(
            //       onPressed: () {
            //         if (isProApp) {
            //           dispatch(
            //               HDWalletListActionCreator.onAddBlockchainClick());
            //         } else {
            //           dispatch(HDWalletListActionCreator.onAddBlockchainTip());
            //         }
            //       },
            //       child: Center(
            //           child: Text(
            //             languageResource.addBlockchain,
            //             style: isProApp ? TextStyle(color: Colors.white) : null,
            //           ))),
            // ),
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

class _TopCardWaveSkeleton extends StatelessWidget {
  const _TopCardWaveSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EAF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1D2B3A),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WaveSkeletonBox(
                width: 56,
                height: 56,
                radius: 18,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WaveSkeletonBox(
                      width: 120,
                      height: 16,
                      radius: 8,
                    ),
                    SizedBox(height: 10),
                    _WaveSkeletonBox(
                      height: 14,
                      radius: 8,
                    ),
                    SizedBox(height: 8),
                    _WaveSkeletonBox(
                      width: 180,
                      height: 14,
                      radius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          _WaveSkeletonBox(
            width: 92,
            height: 12,
            radius: 6,
          ),
          SizedBox(height: 8),
          _WaveSkeletonBox(
            height: 20,
            radius: 10,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _WaveSkeletonBox(
                  height: 34,
                  radius: 12,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _WaveSkeletonBox(
                  height: 34,
                  radius: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveSkeletonBox extends StatefulWidget {
  const _WaveSkeletonBox({
    this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<_WaveSkeletonBox> createState() => _WaveSkeletonBoxState();
}

class _WaveSkeletonBoxState extends State<_WaveSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.radius);
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EEF5),
          borderRadius: borderRadius,
        ),
      ),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) {
              final shift = _controller.value * 2 - 1;
              return LinearGradient(
                begin: Alignment(-1.0 + shift, 0),
                end: Alignment(1.0 + shift, 0),
                colors: const [
                  Color(0x00FFFFFF),
                  Color(0xAAFFFFFF),
                  Color(0x00FFFFFF),
                ],
                stops: const [0.2, 0.5, 0.8],
              ).createShader(rect);
            },
            child: child,
          ),
        );
      },
    );
  }
}

Widget _buildImageView(CurrencyItemState itemState) {
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
