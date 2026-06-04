import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/utils/date_util.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../custom_widget/load_image.dart';
import '../../../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

const double userPhototSize = 66;

Widget buildView(
    GroupCardDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(state.cardGroup.groupName ?? ''),
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      onReload: () {
        dispatch(GroupCardDetailActionCreator.onShowLoading());
        dispatch(GroupCardDetailActionCreator.onLoadData());
      },
      onLoadSuccess: () {
        if (state.isFirstLoading) {
          return _buildSkeletonGrid();
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: state.refreshController,
          onRefresh: () {
            state.currentPage = 1;
            dispatch(GroupCardDetailActionCreator.onLoadData());
          },
          onLoading: () {
            dispatch(GroupCardDetailActionCreator.onLoadData(isLoadMore: true));
          },
          child: state.smartCardItemList.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 6.0,
                    childAspectRatio: 2 / 3,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 6.0),
                  itemCount: state.smartCardItemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final smartCardItem = state.smartCardItemList[index];
                    return GestureDetector(
                      onTap: () {
                        if (smartCardItem.category != 'INVESTMENT') {
                          dispatch(GroupCardDetailActionCreator.onItemClick(
                              smartCardItem.uid ?? ''));
                        }
                      },
                      onLongPress: () => dispatch(
                          GroupCardDetailActionCreator.onShowDeleteDialog(
                              smartCardItem)),
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF159bfc).withOpacity(0.3),
                              offset: const Offset(6.0, 6.0),
                              blurRadius: 5.0)
                        ], borderRadius: BorderRadius.circular(10.0)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF2FacFD).withAlpha(220),
                                      const Color(0xFF2FacFD)
                                    ],
                                    stops: const [0.5, 1],
                                  ).createShader(bounds);
                                },
                                child: const LoadAssetImage(
                                  '1/smart_card_bg',
                                  fit: BoxFit.fill,
                                )),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Text(
                                smartCardItem.cardNo?.isNotEmpty ?? false
                                    ? smartCardItem.cardNo!
                                    : '',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 1.0,
                                        color: Color.fromARGB(180, 0, 0, 0),
                                      ),
                                    ]),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 10,
                              right: 10,
                              child: smartCardItem.category == 'INVESTMENT'
                                  ? buildInvestmentView(state, dispatch,
                                      viewService, smartCardItem)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          smartCardItem.contact ?? '',
                                          maxLines: 4,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              smartCardItem.mobile ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        if (smartCardItem.email?.isNotEmpty ??
                                            false)
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.email_outlined,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                smartCardItem.email ?? '-',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                            ),
                            Positioned(
                                bottom: 10,
                                right: 20,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade300,
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(60, 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onPressed: () {
                                    if (smartCardItem.category !=
                                        'INVESTMENT') {
                                      dispatch(GroupCardDetailActionCreator
                                          .onShowDetailDialog(smartCardItem));
                                    } else {
                                      final investment =
                                          smartCardItem.investment;
                                      if (investment == null) {
                                        dispatch(GroupCardDetailActionCreator
                                            .onShowDetailDialog(smartCardItem));
                                      } else if (investment.status ==
                                          'INACTIVE') {
                                        dispatch(GroupCardDetailActionCreator
                                            .onPushInvestmentActviteClick(
                                                smartCardItem));
                                      } else {
                                        dispatch(GroupCardDetailActionCreator
                                            .onInvestmentPage(smartCardItem));
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Detail',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const EmptyListView(),
        );
      },
      onLoadFailure: () {
        return Container();
      },
    ),
  );
}

Widget _buildSkeletonGrid() {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 6.0,
      childAspectRatio: 2 / 3,
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6.0),
    itemCount: 6,
    itemBuilder: (context, index) {
      return const _GroupCardSkeleton();
    },
  );
}

class _GroupCardSkeleton extends StatefulWidget {
  const _GroupCardSkeleton();

  @override
  State<_GroupCardSkeleton> createState() => _GroupCardSkeletonState();
}

class _GroupCardSkeletonState extends State<_GroupCardSkeleton>
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
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF159bfc).withOpacity(0.12),
            offset: const Offset(6.0, 6.0),
            blurRadius: 5.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2FacFD).withAlpha(220),
                    const Color(0xFF2FacFD)
                  ],
                  stops: const [0.5, 1],
                ).createShader(bounds);
              },
              child: const LoadAssetImage(
                '1/smart_card_bg',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _waveBox(width: 56, height: 14, radius: 7),
            ),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _waveBox(width: 110, height: 16, radius: 8),
                  const SizedBox(height: 10),
                  _waveBox(width: 70, height: 14, radius: 7),
                  const SizedBox(height: 8),
                  _waveBox(width: 120, height: 14, radius: 7),
                  const SizedBox(height: 8),
                  _waveBox(width: 90, height: 14, radius: 7),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 20,
              child: _waveBox(width: 60, height: 30, radius: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waveBox(
      {required double width, required double height, required double radius}) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0x66FFFFFF),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      builder: (context, child) {
        return ShaderMask(
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
        );
      },
    );
  }
}

Widget buildInvestmentView(GroupCardDetailState state, Dispatch dispatch,
    ViewService viewService, SmartCardDetail detail) {
  final investment = detail.investment;
  if (investment == null) {
    return const SizedBox.shrink();
  }

  return investment.status == 'INACTIVE'
      ? buildInvestmentInActiveView(state, dispatch, viewService, detail)
      : buildInvestmentActiveView(state, dispatch, viewService, detail);
}

Widget buildInvestmentInActiveView(GroupCardDetailState state,
    Dispatch dispatch, ViewService viewService, SmartCardDetail detail) {
  String? investime;
  if (detail.investment != null) {
    var inv = detail.investment!;
    switch (inv.intervalType) {
      case 'MINUTES':
        break;
      case 'HOURS':
        break;
      case 'DAYS':
        investime = state.investmentSelectInfo == null
            ? detail.investment?.intervalExtend1
            : state.investmentSelectInfo?.displayValue;
        break;
      case 'WEEKS':
        investime = state.investmentSelectInfo == null
            ? detail.investment?.intervalExtend2
            : state.investmentSelectInfo?.displayValue;
        break;
      case 'MONTH':
        investime = state.investmentSelectInfo == null
            ? detail.investment?.intervalExtend2
            : state.investmentSelectInfo?.displayValue;
        break;
      case 'YEAR':
        investime = state.investmentSelectInfo == null
            ? detail.investment?.intervalExtend2
            : state.investmentSelectInfo?.displayValue;
        break;
      default:
        break;
    }
  }
  if (investime != null) {
    state.investmentSelectInfo = detail.investmentInterval?.intervalTime
        ?.firstWhere((element) => element.displayValue == investime);
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        detail.investment != null ? detail.investment!.name! : "",
        maxLines: 2,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      const SizedBox(
        height: 1,
      ),
      Row(
        children: [
          Text("Coin:${detail.investment?.assetToName}",
              style: const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(
            width: 5,
          ),
          LoadImage(
            detail.investment?.assetToImageUrl ?? '',
            height: 16.0,
            width: 16.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
      const SizedBox(
        height: 1,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          "Card balance: \$${detail.usdtBalance}",
          maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ]),
      // const SizedBox(height: 1),
      // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      //   Text(
      //     "Cycle: ${detail?.investment != null ? detail!.investment!.intervalDescription : ""}",
      //     maxLines: 1,
      //     style: const TextStyle(color: Colors.white, fontSize: 15),
      //   )
      // ]),
      const SizedBox(height: 1),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          "Amount: \$${detail.investment != null ? detail.investment!.assetFromAmount : ""}",
          maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        )
      ]),
      const SizedBox(height: 1),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          "Maximum periods: ${detail.investmentForecast != null ? detail.investmentForecast!.investmentCount : ""}",
          maxLines: 4,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        )
      ]),
      const SizedBox(height: 1),
      // 点击调起时间选择器
      // GestureDetector(
      //   onTap: () {
      //     _showTimePicker(dispatch, state, viewService.context, detail);
      //   },
      //   child: Container(
      //     padding: const EdgeInsets.all(1),
      //     width: double.infinity,
      //     color: Colors.transparent,
      //     child:
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     const Text("Execute Time:",
      //         style: TextStyle(fontSize: 15, color: Colors.white)),
      //     Row(
      //       children: [
      //         Container(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: const BorderRadius.horizontal(
      //               left: Radius.circular(20),
      //               right: Radius.circular(20),
      //             ),
      //           ),
      //           child: Text(
      //             investime ?? "00:00",
      //             style: const TextStyle(
      //               fontSize: 15,
      //               color: Colors.black,
      //             ),
      //           ),
      //         ),
      //         const SizedBox(width: 1),
      // ],
      // ),
      // ],
      // ),
      // ),
      // )
    ],
  );
}

Widget buildInvestmentActiveView(GroupCardDetailState state, Dispatch dispatch,
    ViewService viewService, SmartCardDetail detail) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        detail.investment?.name ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      const SizedBox(
        height: 1,
      ),
      Row(
        children: [
          Text("Coin:${detail.investment?.assetToName}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // 或者换成 clip、fade
              style: const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(
            width: 5,
          ),
          LoadImage(
            detail.investment?.assetToImageUrl ?? '',
            height: 16.0,
            width: 16.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
      const SizedBox(
        height: 1,
      ),
      detail.investment!.previousTriggerTime != null
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "Next time: ${DateUtil.formatTimestamp(detail.investment!.previousTriggerTime ?? 0)}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // 或者换成 clip、fade
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ])
          : const SizedBox(),
      detail.investment!.previousTriggerTime == null
          ? const SizedBox(height: 1)
          : const SizedBox(),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          "Executed Count: ${detail.investment!.executedCount}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // 或者换成 clip、fade
          style: const TextStyle(color: Colors.white, fontSize: 15),
        )
      ]),
      const SizedBox(height: 1),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          "Status: ${detail.investment!.statusName}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // 或者换成 clip、fade
          style: const TextStyle(color: Colors.white, fontSize: 15),
        )
      ]),
      const SizedBox(height: 1),
    ],
  );
}
