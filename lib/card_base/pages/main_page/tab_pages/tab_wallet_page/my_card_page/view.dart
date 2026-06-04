import 'package:animated_number/animated_number.dart';
import 'package:card_coin/bean/sales_data.dart';
import 'package:card_coin/card_base/bean/Investment_select_info.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/view/card_bottom_action_bar.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/view/circle_content.dart';
import 'package:card_coin/card_base/widgets/slide_toact_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/utils/cryptos_prices_utils.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:card_coin/widget/onInvestment_card_section.dart';
import 'package:card_coin/widget/time_update_view.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/picker.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../widget/base_page_loading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'action.dart';
import 'state.dart';
import 'package:intl/intl.dart';

Widget buildView(
    MyCardState state, Dispatch dispatch, ViewService viewService) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    StartupTime.markOnce('mycard_page_visible');
    if (state.loadStatus == LoadType.loadSuccess &&
        state.cardDetail != null &&
        !state.hasReportedPrimaryContentVisible) {
      state.hasReportedPrimaryContentVisible = true;
      StartupTime.mark('mycard_primary_content_visible');
    }
  });
  var languageResource = state.languageResource!;
  // 获取屏幕尺寸信息
  var screenSize = MediaQuery.of(viewService.context).size;

  return PageDataLoadingView(
      loadingView: _buildLoadingContent(
        state,
        dispatch,
        viewService,
        screenSize,
      ),
      onReload: () {
        if (state.loadStatus == LoadType.loading) {
          return;
        }
        if (state.cardDetail == null) {
          dispatch(MyCardActionCreator.onScanCardClick());
          return;
        }
        dispatch(MyCardActionCreator.onShowLoading());
        dispatch(MyCardActionCreator.onLoadData());
      },
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onLoadSuccess: () {
        if (state.cardDetail != null) {
          return buildNewInActiveView(state, dispatch, viewService);
        } else {
          return Center(
            child: GestureDetector(
                onTap: () {
                  dispatch(MyCardActionCreator.onScanCardClick());
                },
                child: Column(
                  children: [
                    SizedBox(height: screenSize.width <= 480 ? 120 : 130),
                    CircledContainer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const LoadAssetImage(
                            '1/nfc_icon',
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: screenSize.width <= 480 ? 10 : 20),
                          Text(
                            languageResource.scanCardTip,
                            style: TextStyle(
                              fontSize: screenSize.width <= 480 ? 17 : 30,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          );
        }

        // return state.cardDetail != null
        //     ? Column(children: [
        //         /// 内容区（≈ 2/3 屏）
        //         Expanded(
        //           flex: 2,
        //           child: SingleChildScrollView(
        //             padding: const EdgeInsets.symmetric(
        //                 horizontal: 20, vertical: 16),
        //             child: Column(
        //               children: [
        //                 NonInvestmentCardSection(
        //                   state: state,
        //                   languageResource: languageResource,
        //                 ),
        //                 const SizedBox(height: 20),
        //                 if (state.pageConfig?.isShowDapplist == true &&
        //                     state.dapplist?.isNotEmpty == true)
        //                   buildDappList(dispatch, state, viewService),
        //               ],
        //             ),
        //           ),
        //         ),

        //         /// 底部固定按钮
        //         CardBottomActionBar(
        //           state: state,
        //           dispatch: dispatch,
        //         )
        //       ])
        //     : Center(
        //         child: GestureDetector(
        //             onTap: () {
        //               dispatch(MyCardActionCreator.onScanCardClick());
        //             },
        //             child: Column(
        //               children: [
        //                 SizedBox(height: screenSize.width <= 480 ? 120 : 130),
        //                 CircledContainer(
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       LoadAssetImage(
        //                         '1/nfc_icon',
        //                         color: Colors.blueAccent,
        //                       ),
        //                       SizedBox(
        //                           height: screenSize.width <= 480 ? 10 : 20),
        //                       Text(
        //                         languageResource.scanCardTip,
        //                         style: TextStyle(
        //                           fontSize: screenSize.width <= 480 ? 17 : 30,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 )
        //               ],
        //             )),
        //       );
      },
      onLoadFailure: () {
        return Center(
          child: GestureDetector(
              onTap: () {
                if (state.loadStatus == LoadType.loading) {
                  return;
                }
                if (state.cardDetail == null) {
                  dispatch(MyCardActionCreator.onScanCardClick());
                  return;
                }
                dispatch(MyCardActionCreator.onReloadMainData());
              },
              child: Column(
                children: [
                  SizedBox(height: screenSize.width <= 480 ? 120 : 130),
                  CircledContainer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoadAssetImage(
                          '1/nfc_icon',
                          color: Colors.blueAccent,
                        ),
                        SizedBox(height: screenSize.width <= 480 ? 10 : 20),
                        Text(
                          languageResource.scanCardTip,
                          style: TextStyle(
                            fontSize: screenSize.width <= 480 ? 17 : 30,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        );
      });
}

Widget _buildLoadingContent(
  MyCardState state,
  Dispatch dispatch,
  ViewService viewService,
  Size screenSize,
) {
  if (state.cardDetail != null) {
    return Stack(
      children: [
        buildNewInActiveView(state, dispatch, viewService),
        Positioned.fill(
          child: Container(
            color: Colors.white.withValues(alpha: 0.78),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.6),
                ),
                const SizedBox(height: 14),
                Text(
                  state.languageResource?.loading ?? 'Loading…',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1E3A5F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  return _buildLoadingSkeleton(screenSize);
}

Widget _buildLoadingSkeleton(Size screenSize) {
  return Container(
    color: const Color(0xFFF6F9FC),
    child: SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonBox(
              height: screenSize.width <= 480 ? 214 : 250,
              radius: 24,
            ),
            const SizedBox(height: 18),
            _buildSkeletonBox(height: 18, width: 140, radius: 10),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildSkeletonBox(height: 86, radius: 18)),
                const SizedBox(width: 12),
                Expanded(child: _buildSkeletonBox(height: 86, radius: 18)),
              ],
            ),
            const SizedBox(height: 18),
            _buildSkeletonBox(height: 20, width: 180, radius: 10),
            const SizedBox(height: 12),
            _buildSkeletonBox(height: 132, radius: 20),
            const SizedBox(height: 18),
            _buildSkeletonBox(height: 20, width: 120, radius: 10),
            const SizedBox(height: 12),
            _buildSkeletonBox(height: 92, radius: 20),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSkeletonBox({
  required double height,
  double? width,
  double radius = 16,
}) {
  return _WaveSkeletonBox(
    width: width,
    height: height,
    radius: radius,
  );
}

class _WaveSkeletonBox extends StatefulWidget {
  const _WaveSkeletonBox({
    required this.height,
    required this.radius,
    this.width,
  });

  final double height;
  final double? width;
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
          color: const Color(0xFFE7EEF6),
          borderRadius: borderRadius,
          border: Border.all(color: const Color(0xFFD7E2EF)),
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
                  Color(0x88FFFFFF),
                  Color(0x00FFFFFF),
                ],
                stops: const [0.18, 0.5, 0.82],
              ).createShader(rect);
            },
            child: child,
          ),
        );
      },
    );
  }
}

Widget buildInActiveView(
    MyCardState state, Dispatch dispatch, ViewService viewService) {
  print("ssss333333build333");
  var screenSize = MediaQuery.of(viewService.context).size;
  var mainLineColor = const Color.fromARGB(255, 255, 94, 13);

  var textStyle = const TextStyle(
    fontSize: 20,
    // fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 13, 122, 255),
    letterSpacing: 4,
  );

  String detailTitle1 = "";
  String? investime;
  if (state.cardDetail?.investment != null) {
    var inv = state.cardDetail!.investment!;
    switch (inv.intervalType) {
      case 'MINUTES':
        if (state.selectInfo1 != null) {
          investime = state.selectInfo1!.displayValue;
        } else {
          investime = "${inv.intervalExtend1Name}";
        }
        detailTitle1 = "\$${inv.assetFromAmount}";
        break;
      case 'HOURS':
        if (state.selectInfo1 != null) {
          investime = state.selectInfo1!.displayValue;
        } else {
          investime = "${inv.intervalExtend1Name}";
        }
        detailTitle1 = "\$${inv.assetFromAmount}";
        break;
      case 'DAYS':
        if (state.selectInfo1 != null) {
          investime = state.selectInfo1!.displayValue;
        } else {
          investime = "${inv.intervalExtend1Name}";
        }
        detailTitle1 = "\$${inv.assetFromAmount}";
        break;
      case 'WEEKS':
        if (state.selectInfo1 != null) {
          investime =
              "${state.selectInfo1!.displayValue} ${state.selectInfo2!.displayValue}";
        } else {
          investime = " ${inv.intervalExtend1Name}  ${inv.intervalExtend2Name}";
        }
        detailTitle1 = "\$${inv.assetFromAmount}";
        break;
      case 'MONTH':
        if (state.selectInfo1 != null) {
          investime =
              "${state.selectInfo1!.displayValue} ${state.selectInfo2!.displayValue}";
        } else {
          investime = " ${inv.intervalExtend1Name}  ${inv.intervalExtend2Name}";
        }
        detailTitle1 = "\$${inv.assetFromAmount}";
        break;
      case 'YEAR':
        if (state.selectInfo1 != null) {
          investime =
              "${state.selectInfo1!.displayValue} ${state.selectInfo2!.displayValue} ${state.selectInfo3!.displayValue}";
        } else {
          investime =
              " ${inv.intervalExtend1Name}  ${inv.intervalExtend2Name} ${inv.intervalExtend3Name}";
        }
        detailTitle1 = "\$${inv.assetFromAmount}";
        break;
      default:
        detailTitle1 = "";
    }
  }

  return Transform.translate(
    offset: const Offset(0, -20), // 上移 20 像素(
    // padding: EdgeInsets.only(right: 0.0, left: 0.0, top: 0, bottom: 0.0),
    child: Column(
      children: [
        // 可滚动内容区域
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 背景图部分
                Container(
                  //  height: 500,
                  margin: const EdgeInsets.all(0.0),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 225, 240, 255), // 设置背景透明

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))
                      // left: Radius.circular(20.0), // 左侧圆角
                      // right: Radius.circular(20.0), // 右侧圆角
                      ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 内部内容区域
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            if (state.pageConfig.isShowKLine == true)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 15),
                                  Text(
                                    "Previous ${state.cardDetail!.investmentForecast!.name ?? "BTC"} Price:",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(
                                            255, 51, 51, 51)), // 白色文字
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedNumber(
                                    key: ValueKey(state.valueArr[1]),
                                    prefixText: "\$",
                                    startValue: state.valueArr[0],
                                    endValue: state.valueArr[1],
                                    duration: const Duration(milliseconds: 300),
                                    isFloatingPoint: true,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 13, 122, 255),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            else
                              const SizedBox(width: 0),

                            // 折叠内容区域
                            if (state.pageConfig.isShowKLine == true)
                              SizedBox(
                                  height: state.isExpanded ? 140 : 0,
                                  width: screenSize.width,
                                  child: Stack(
                                      // padding: EdgeInsets.only(
                                      //     top: 0, left: 0, right: 0),
                                      children: [
                                        LineChart(
                                          LineChartData(
                                            lineTouchData: LineTouchData(
                                              getTouchedSpotIndicator:
                                                  (barData, spotIndexes) {
                                                return spotIndexes.map((index) {
                                                  return const TouchedSpotIndicatorData(
                                                    FlLine(
                                                      color: Color.fromARGB(
                                                          255, 44, 121, 255),
                                                      strokeWidth: 1,
                                                      dashArray: [4, 4],
                                                    ),
                                                    FlDotData(show: true),
                                                  );
                                                }).toList();
                                              },
                                              handleBuiltInTouches: true,
                                              touchTooltipData:
                                                  LineTouchTooltipData(
                                                tooltipRoundedRadius: 4,
                                                fitInsideHorizontally: true,
                                                fitInsideVertically: true,
                                                tooltipMargin: 10,
                                                tooltipPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2),
                                                // tooltipBgColor: Colors
                                                //     .transparent, // 隐藏默认 Tooltip
                                                showOnTopOfTheChartBoxArea:
                                                    true, // Tooltip 固定在顶部
                                                getTooltipItems:
                                                    (List<LineBarSpot>
                                                        touchedSpots) {
                                                  return touchedSpots.map(
                                                      (LineBarSpot
                                                          touchedSpot) {
                                                    int index =
                                                        touchedSpot.x.toInt();
                                                    // 判断是否为第一个或最后一个数据点
                                                    TextAlign alignment =
                                                        TextAlign.center;
                                                    int time = state
                                                        .cardDetail!
                                                        .investmentForecast!
                                                        .investments![index]
                                                        .investmentTimestamp!;
                                                    DateTime date = DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            time);

                                                    String text =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(date);

                                                    if (index == 0) {
                                                      alignment = TextAlign
                                                          .left; // 第一个点，提示语在右侧
                                                      print("左边");
                                                      text = "   $text";
                                                    } else if (index ==
                                                        state.spotList.length -
                                                            1) {
                                                      alignment = TextAlign
                                                          .right; // 最后一个点，提示语在左侧
                                                      print("you边");
                                                      text = "$text   ";
                                                    }

                                                    return LineTooltipItem(
                                                      text,
                                                      const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      textAlign: alignment,
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                              enabled: true,
                                              touchCallback: (FlTouchEvent
                                                      event,
                                                  LineTouchResponse? response) {
                                                print(
                                                    'LineTouchResponse:event:$event');
                                                if ((event is FlPanUpdateEvent ||
                                                        event
                                                            is FlLongPressMoveUpdate) &&
                                                    response != null &&
                                                    response.lineBarSpots !=
                                                        null &&
                                                    response.lineBarSpots!
                                                        .isNotEmpty) {
                                                  state.touchXPosition =
                                                      response.lineBarSpots!
                                                          .first.x;

                                                  dispatch(MyCardActionCreator
                                                      .onUpdatechangeVerticalLines());
                                                }

                                                // 松手或手势结束时取消
                                                if (event is FlTapUpEvent ||
                                                    // event is FlLongPressEnd ||
                                                    // event is FlPanEndEvent ||
                                                    event
                                                        is FlPointerExitEvent) {
                                                } else {
                                                  if (response == null ||
                                                      response.lineBarSpots ==
                                                          null) {
                                                    return;
                                                  }
                                                  final spot1 = response
                                                      .lineBarSpots!.first;
                                                  state.lastTouchedSpot = spot1;
                                                }
                                                if (response == null ||
                                                    response.lineBarSpots ==
                                                        null) {
                                                  return;
                                                }

                                                final spot = response
                                                    .lineBarSpots!.first;
                                                final y = spot.y;

                                                if (state.valueArr[1] == y) {
                                                  return;
                                                }
                                                print(
                                                    "response.lineBarSpot:$y");
                                                // 在此处理触摸点的数据，例如更新状态或显示自定义信息
                                                dispatch(MyCardActionCreator
                                                    .onUpdateCurNum(y));
                                              },
                                            ),
                                            extraLinesData: ExtraLinesData(
                                              horizontalLines: [
                                                HorizontalLine(
                                                  y: double.parse(state
                                                      .cardDetail!
                                                      .investmentForecast!
                                                      .averagePrice!), // 标准线的 Y 轴位置
                                                  color: const Color.fromARGB(
                                                      255,
                                                      44,
                                                      121,
                                                      255), // 标准线颜色
                                                  strokeWidth: 1, // 标准线宽度
                                                  dashArray: [5, 5], // 虚线样式，可选
                                                  label: HorizontalLineLabel(
                                                    show: true,
                                                    labelResolver: (line) =>
                                                        'Avg ${state.cardDetail!.investmentForecast!.name ?? "BTC"} Price: \$${double.parse(state.cardDetail!.investmentForecast!.averagePrice!).toInt()}',
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 44, 121, 255),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            lineBarsData: [
                                              LineChartBarData(
                                                  spots: state.spotList,
                                                  isCurved: true,
                                                  barWidth: 2,
                                                  color: mainLineColor,
                                                  dotData: FlDotData(
                                                    show: true,
                                                    getDotPainter: (spot,
                                                        percent,
                                                        barData,
                                                        index) {
                                                      return FlDotCirclePainter(
                                                        radius: 4,
                                                        color: Colors.white,
                                                        strokeWidth: 1,
                                                        strokeColor: const Color
                                                            .fromARGB(
                                                            255, 255, 94, 13),
                                                      );
                                                    },
                                                  ),
                                                  belowBarData: BarAreaData(
                                                    show: true,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        const Color.fromARGB(
                                                            255, 255, 94, 13),
                                                        const Color.fromARGB(
                                                            255, 225, 240, 255)
                                                      ]
                                                          .map((color) => color
                                                              .withOpacity(0.5))
                                                          .toList(),
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  )),
                                            ],
                                            minY: state.minY,
                                            maxY: state.maxY,
                                            maxX: state.spotList.isNotEmpty
                                                ? state.spotList.last.x
                                                : 0,
                                            minX: state.spotList.isNotEmpty
                                                ? state.spotList.first.x
                                                : 0,
                                            titlesData: FlTitlesData(
                                              show: true,
                                              topTitles: const AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              leftTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              rightTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                showTitles: false,
                                              )),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  // reservedSize: ,
                                                  interval: 1,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    int index = value.toInt();
                                                    if (state
                                                        .cardDetail!
                                                        .investmentForecast!
                                                        .investments!
                                                        .isEmpty) {
                                                      var mainLineColor =
                                                          Colors.black;

                                                      return SideTitleWidget(
                                                        space: 1,
                                                        axisSide: AxisSide.left,
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(
                                                            fontSize: 7,
                                                            color:
                                                                mainLineColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    int time = state
                                                        .cardDetail!
                                                        .investmentForecast!
                                                        .investments![index]
                                                        .investmentTimestamp!;
                                                    DateTime date = DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            time);

                                                    String text = DateFormat(
                                                            'MM-dd')
                                                        .format(date); // 格式化日期
                                                    print(
                                                        'bottomTitleWidgets-value:$value,text:$text');
                                                    var mainLineColor =
                                                        Colors.black;

                                                    return SideTitleWidget(
                                                      space: 1,
                                                      axisSide: AxisSide.left,
                                                      child: Text(
                                                        text,
                                                        style: TextStyle(
                                                          fontSize: 7,
                                                          color: mainLineColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                            gridData: const FlGridData(
                                              drawHorizontalLine:
                                                  false, // 隐藏水平网格线
                                              drawVerticalLine:
                                                  false, // 隐藏垂直网格线
                                            ),
                                          ),
                                        ),
                                      ]))
                            else
                              const SizedBox(height: 0),
                            if (state.pageConfig.isShowKLine == true)
                              const SizedBox(height: 10)
                            else
                              const SizedBox(height: 0),

                            // 点击
                            GestureDetector(
                                onTap: () {
                                  if (state.cardDetail!.category !=
                                      "INVESTMENT") {
                                    dispatch(
                                        MyCardActionCreator.onPushWalletPage(
                                            state.cardDetail?.uid ?? ''));
                                  } else {
                                    if (state.cardDetail?.investment?.status ==
                                        'INACTIVE') {
                                      dispatch(
                                          MyCardActionCreator.onPushWalletPage(
                                              state.cardDetail?.uid ?? ''));
                                    }
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 14, right: 14, top: 1, bottom: 0),
                                  // padding:
                                  //     EdgeInsets.only(top: 0, left: 15, right: 15),
                                  decoration: const BoxDecoration(
                                      color: Colors.white, // 设置背景

                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 14,
                                              top: 14,
                                              bottom: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // 加这一行！
                                                children: [
                                                  if (state.pageConfig
                                                          .isShowCardNo ==
                                                      true)
                                                    Row(children: [
                                                      const Text(
                                                        "Card number:",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    51,
                                                                    51,
                                                                    51)),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          state.cardDetail
                                                                      ?.cardNo !=
                                                                  null
                                                              ? state
                                                                  .cardDetail!
                                                                  .cardNo!
                                                              : "",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: textStyle),
                                                    ])
                                                  else
                                                    const SizedBox(
                                                      height: 0,
                                                    ),
                                                  if (state.pageConfig
                                                          .isShowCardNo ==
                                                      true)
                                                    const SizedBox(
                                                      height: 5,
                                                    )
                                                  else
                                                    const SizedBox(
                                                      height: 0,
                                                    ),
                                                  if (state.pageConfig
                                                          .isShowCardplan ==
                                                      true)
                                                    Text(
                                                      "Plan:${state.cardDetail?.investment != null ? state.cardDetail!.investment!.name! : ""}",
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              166,
                                                              166,
                                                              166)),
                                                    )
                                                  else
                                                    const SizedBox(),
                                                  // ])
                                                ],
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 1),

                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (state.pageConfig
                                                    .isShowCardbalance ==
                                                true)
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Text(
                                                    "\$${state.cardDetail != null ? state.cardDetail!.usdtBalance : ""}",
                                                    maxLines: 4,
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 94, 13),
                                                        fontSize: 24),
                                                  ),
                                                  const Text(
                                                    "Card balance",
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 148, 148, 148),
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )),
                                            if (state.pageConfig
                                                    .isShowCardMount ==
                                                true)
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Text(
                                                    detailTitle1,
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 51, 51, 51),
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  const Text(
                                                    "Amount",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 148, 148, 148),
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )),
                                            if (state.pageConfig
                                                    .isShowCardMaxPeriods ==
                                                true)
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Text(
                                                    "${state.cardDetail?.investmentForecast != null ? state.cardDetail!.investmentForecast!.investmentCount : ""}",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 51, 51, 51),
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  const Text(
                                                    "Maximum periods",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 148, 148, 148),
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ))
                                          ]),

                                      if (state.pageConfig.isShowCardbalance ==
                                              true ||
                                          state.pageConfig.isShowCardMount ==
                                              true ||
                                          state.pageConfig
                                                  .isShowCardMaxPeriods ==
                                              true)
                                        const SizedBox(height: 15)
                                      else
                                        const SizedBox(),
                                      if (state.pageConfig.isShowCardCycle ==
                                          true)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 0,
                                              bottom: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Cycle: ${state.cardDetail?.investment != null ? state.cardDetail!.investment!.intervalTypeName : ""}",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 171, 171, 171),
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),

                                                // 点击调起时间选择器

                                                // <-- 让按钮填满剩余空间
                                                GestureDetector(
                                                  onTap: () {
                                                    _showTimePicker(
                                                        dispatch,
                                                        state,
                                                        viewService.context);
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 49, 165, 255),
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                        left:
                                                            Radius.circular(20),
                                                        right:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    // width: 180,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            " Execute Time:",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white)),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          4),
                                                              child: Text(
                                                                investime ??
                                                                    "00:00",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        )
                                      else
                                        const SizedBox(),

                                      if (state.pageConfig.isShowCardCycle ==
                                          true)
                                        const SizedBox(height: 15)
                                      else
                                        const SizedBox(height: 0),
                                      if (state.pageConfig
                                                  .isShowPostCardActivation ==
                                              true &&
                                          (state.cardDetail?.investment == null ||
                                              state.cardDetail?.investment
                                                      ?.status ==
                                                  'INACTIVE' ||
                                              state.cardDetail?.investment
                                                      ?.status ==
                                                  'PROCESSING'))
                                        SlideToActButton(
                                          key: state.slideKey,
                                          width: 300,
                                          height: 30,
                                          sliderIconWidget: Image.asset(
                                              'assets/images/active_jiantou.png',
                                              width: 30),
                                          onCompleted: () {
                                            dispatch(MyCardActionCreator
                                                .onPushInvestmentActviteClick(
                                                    state.cardDetail!.uid!));
                                            // 这里可以执行你的业务逻辑
                                          },
                                        )
                                      else
                                        const SizedBox(height: 0),

                                      const SizedBox(height: 1),

                                      // 其他固定内容，比如底部的按钮
                                      // Row(
                                      //   mainAxisAlignment: (state.pageConfig
                                      //               .isShowCardAddCollection ==
                                      //           true)
                                      //       ? MainAxisAlignment.spaceAround
                                      //       : MainAxisAlignment.center,
                                      //   children: [
                                      //     if (state.pageConfig
                                      //             .isShowCardAddCollection ==
                                      //         true)
                                      //       Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment
                                      //                 .center, // 左右分布
                                      //         children: [
                                      //           Text(
                                      //             'Add to collection',
                                      //             style: TextStyle(
                                      //                 fontSize: 12,
                                      //                 color: Color.fromARGB(
                                      //                     255, 51, 51, 51)),
                                      //           ),
                                      //           Switch(
                                      //             activeColor: Color.fromARGB(
                                      //                 255, 49, 165, 255),
                                      //             value: state.isSwitched,
                                      //             onChanged: (value) {
                                      //               dispatch(MyCardActionCreator
                                      //                   .onExchangeCardSwitch(
                                      //                       value));
                                      //             },
                                      //           ),
                                      //         ],
                                      //       )
                                      //     else
                                      //       SizedBox(
                                      //         width: 0,
                                      //       ),
                                      //     if (state.pageConfig
                                      //             .isShowCardAddCollection ==
                                      //         true)
                                      //       SizedBox(
                                      //         width: 20,
                                      //       )
                                      //     else
                                      //       SizedBox(
                                      //         width: 0,
                                      //       ),
                                      //     if (state.pageConfig
                                      //             .isShowPostCardReTap ==
                                      //         true)
                                      //       ElevatedButton(
                                      //         onPressed: () => dispatch(
                                      //             MyCardActionCreator
                                      //                 .onScanCardClick()),
                                      //         style: ElevatedButton.styleFrom(
                                      //           padding:
                                      //               EdgeInsets.zero, // 去除默认内边距
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.horizontal(
                                      //               left: Radius.circular(30),
                                      //               right: Radius.circular(30),
                                      //             ),
                                      //           ),
                                      //           elevation: 0,
                                      //           backgroundColor: Colors
                                      //               .transparent, // 必须设为透明
                                      //           shadowColor: Colors.transparent,
                                      //         ),
                                      //         child: Ink(
                                      //           decoration: BoxDecoration(
                                      //             gradient:
                                      //                 const LinearGradient(
                                      //               colors: [
                                      //                 Color.fromARGB(255, 49,
                                      //                     165, 255), // 左边颜色
                                      //                 Color.fromARGB(255, 9,
                                      //                     116, 255), // 右边颜色
                                      //               ],
                                      //             ),
                                      //             borderRadius:
                                      //                 const BorderRadius
                                      //                     .horizontal(
                                      //               left: Radius.circular(30),
                                      //               right: Radius.circular(30),
                                      //             ),
                                      //           ),
                                      //           child: Container(
                                      //             alignment: Alignment.center,
                                      //             padding: const EdgeInsets
                                      //                 .symmetric(
                                      //                 horizontal: 20,
                                      //                 vertical: 6),
                                      //             child: const Text(
                                      //               'Re-Tap',
                                      //               style: TextStyle(
                                      //                   color: Colors.white),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       )
                                      //     else
                                      //       SizedBox(
                                      //         width: 0,
                                      //       ),
                                      //   ],
                                      // ),
                                      getBottomButon(
                                          dispatch, state, viewService),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
      ],
    ),
  );
}

Widget buildNewInActiveView(
    MyCardState state, Dispatch dispatch, ViewService viewService) {
  print("ssss333333build333");
  var screenSize = MediaQuery.of(viewService.context).size;
  var mainLineColor = const Color.fromARGB(255, 255, 94, 13);

  String detailTitle1 = "";
  String investime = "00:00";
  if (state.cardDetail?.investment != null) {
    var inv = state.cardDetail!.investment!;
    switch (inv.intervalType) {
      case 'MINUTES':
      case 'HOURS':
      case 'DAYS':
        investime =
            state.selectInfo1?.displayValue ?? inv.intervalExtend1Name ?? "";
        detailTitle1 = "\$${inv.assetFromAmount ?? ""}";
        break;
      case 'WEEKS':
      case 'MONTH':
        String val1 =
            state.selectInfo1?.displayValue ?? inv.intervalExtend1Name ?? "";
        String val2 =
            state.selectInfo2?.displayValue ?? inv.intervalExtend2Name ?? "";
        investime = "$val1 $val2".trim();
        detailTitle1 = "\$${inv.assetFromAmount ?? ""}";
        break;
      case 'YEAR':
        String val1 =
            state.selectInfo1?.displayValue ?? inv.intervalExtend1Name ?? "";
        String val2 =
            state.selectInfo2?.displayValue ?? inv.intervalExtend2Name ?? "";
        String val3 =
            state.selectInfo3?.displayValue ?? inv.intervalExtend3Name ?? "";
        investime = "$val1 $val2 $val3".trim();
        detailTitle1 = "\$${inv.assetFromAmount ?? ""}";
        break;
      default:
        detailTitle1 = "";
        investime = "00:00";
    }
  }

  // 核心布局：Column，Expanded 可滚动内容 + 固定底部按钮（滚动边界自然止于按钮上方）
  const kWalletPageBg = Color.fromARGB(255, 225, 240, 255);
  return ColoredBox(
    color: kWalletPageBg,
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 10),
            children: [
              Container(
                margin: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 225, 240, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 10),

                          // K线标题行
                          if (state.pageConfig.isShowLineChart == true &&
                              state.cardDetail?.investmentForecast != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 15),
                                const Text(
                                  "Previous Price:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 51, 51, 51),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedNumber(
                                  key: ValueKey(state.valueArr[1]),
                                  prefixText: "\$",
                                  startValue: state.valueArr[0],
                                  endValue: state.valueArr[1],
                                  duration: const Duration(milliseconds: 300),
                                  isFloatingPoint: true,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 13, 122, 255),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          else
                            const SizedBox(width: 0),

                          // LineChart 固定 140 高度
                          if (state.pageConfig.isShowLineChart == true &&
                              state.cardDetail?.investmentForecast != null)
                            SizedBox(
                              height: 140,
                              width: screenSize.width,
                              child: Stack(
                                children: [
                                  LineChart(
                                    LineChartData(
                                      lineTouchData: LineTouchData(
                                        getTouchedSpotIndicator:
                                            (barData, spotIndexes) {
                                          return spotIndexes.map((index) {
                                            return const TouchedSpotIndicatorData(
                                              FlLine(
                                                color: Color.fromARGB(
                                                    255, 44, 121, 255),
                                                strokeWidth: 1,
                                                dashArray: [4, 4],
                                              ),
                                              FlDotData(show: true),
                                            );
                                          }).toList();
                                        },
                                        handleBuiltInTouches: true,
                                        touchTooltipData: LineTouchTooltipData(
                                          tooltipRoundedRadius: 4,
                                          fitInsideHorizontally: true,
                                          fitInsideVertically: true,
                                          tooltipMargin: 10,
                                          tooltipPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 2),
                                          showOnTopOfTheChartBoxArea: true,
                                          getTooltipItems:
                                              (List<LineBarSpot> touchedSpots) {
                                            return touchedSpots
                                                .map((LineBarSpot touchedSpot) {
                                              int index = touchedSpot.x.toInt();
                                              TextAlign alignment =
                                                  TextAlign.center;
                                              String text = "";

                                              if (state
                                                          .cardDetail
                                                          ?.investmentForecast
                                                          ?.investments !=
                                                      null &&
                                                  index >= 0 &&
                                                  index <
                                                      state
                                                          .cardDetail!
                                                          .investmentForecast!
                                                          .investments!
                                                          .length) {
                                                int? time = state
                                                    .cardDetail!
                                                    .investmentForecast!
                                                    .investments![index]
                                                    .investmentTimestamp;
                                                if (time != null) {
                                                  DateTime date = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          time);
                                                  text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(date);
                                                  if (index == 0) {
                                                    alignment = TextAlign.left;
                                                    text = "   $text";
                                                  } else if (index ==
                                                      state.spotList.length -
                                                          1) {
                                                    alignment = TextAlign.right;
                                                    text = "$text   ";
                                                  }
                                                }
                                              }

                                              return LineTooltipItem(
                                                text,
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                textAlign: alignment,
                                              );
                                            }).toList();
                                          },
                                        ),
                                        enabled: true,
                                        touchCallback: (FlTouchEvent event,
                                            LineTouchResponse? response) {
                                          if ((event is FlPanUpdateEvent ||
                                                  event
                                                      is FlLongPressMoveUpdate) &&
                                              response != null &&
                                              response.lineBarSpots != null &&
                                              response
                                                  .lineBarSpots!.isNotEmpty) {
                                            state.touchXPosition =
                                                response.lineBarSpots!.first.x;
                                            dispatch(MyCardActionCreator
                                                .onUpdatechangeVerticalLines());
                                          }

                                          if (event is FlTapUpEvent ||
                                              event is FlPointerExitEvent) {
                                          } else {
                                            if (response == null ||
                                                response.lineBarSpots == null) {
                                              return;
                                            }
                                            final spot1 =
                                                response.lineBarSpots!.first;
                                            state.lastTouchedSpot = spot1;
                                          }
                                          if (response == null ||
                                              response.lineBarSpots == null) {
                                            return;
                                          }

                                          final spot =
                                              response.lineBarSpots!.first;
                                          final y = spot.y;

                                          if (state.valueArr[1] == y) return;
                                          print("response.lineBarSpot:$y");
                                          dispatch(MyCardActionCreator
                                              .onUpdateCurNum(y));
                                        },
                                      ),
                                      extraLinesData: ExtraLinesData(
                                        horizontalLines: [
                                          if (state
                                                  .cardDetail
                                                  ?.investmentForecast
                                                  ?.averagePrice !=
                                              null)
                                            HorizontalLine(
                                              y: double.tryParse(state
                                                      .cardDetail!
                                                      .investmentForecast!
                                                      .averagePrice!) ??
                                                  0,
                                              color: const Color.fromARGB(
                                                  255, 44, 121, 255),
                                              strokeWidth: 1,
                                              dashArray: const [5, 5],
                                              label: HorizontalLineLabel(
                                                show: true,
                                                labelResolver: (line) {
                                                  double avgPrice =
                                                      double.tryParse(state
                                                              .cardDetail!
                                                              .investmentForecast!
                                                              .averagePrice!) ??
                                                          0;
                                                  String assetName = state
                                                          .cardDetail
                                                          ?.investmentForecast
                                                          ?.name ??
                                                      "BTC";
                                                  return 'Avg $assetName Price: \$${avgPrice.toInt()}';
                                                },
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 44, 121, 255),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: state.spotList,
                                          isCurved: true,
                                          barWidth: 2,
                                          color: mainLineColor,
                                          dotData: FlDotData(
                                            show: true,
                                            getDotPainter: (spot, percent,
                                                barData, index) {
                                              return FlDotCirclePainter(
                                                radius: 4,
                                                color: Colors.white,
                                                strokeWidth: 1,
                                                strokeColor: mainLineColor,
                                              );
                                            },
                                          ),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              colors: [
                                                mainLineColor,
                                                const Color.fromARGB(
                                                    255, 225, 240, 255)
                                              ]
                                                  .map((color) =>
                                                      color.withOpacity(0.5))
                                                  .toList(),
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                        ),
                                      ],
                                      minY: state.minY,
                                      maxY: state.maxY,
                                      maxX: state.spotList.isNotEmpty
                                          ? state.spotList.last.x
                                          : 0,
                                      minX: state.spotList.isNotEmpty
                                          ? state.spotList.first.x
                                          : 0,
                                      titlesData: FlTitlesData(
                                        show: true,
                                        topTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        leftTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            // 根据数据点数量动态计算间隔，防止日期标签重叠
                                            interval: () {
                                              final count = state
                                                      .cardDetail
                                                      ?.investmentForecast
                                                      ?.investments
                                                      ?.length ??
                                                  0;
                                              return count <= 6
                                                  ? 1.0
                                                  : (count / 6).ceilToDouble();
                                            }(),
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              String text = "";
                                              if (state
                                                          .cardDetail
                                                          ?.investmentForecast
                                                          ?.investments !=
                                                      null &&
                                                  index >= 0 &&
                                                  index <
                                                      state
                                                          .cardDetail!
                                                          .investmentForecast!
                                                          .investments!
                                                          .length) {
                                                int? time = state
                                                    .cardDetail!
                                                    .investmentForecast!
                                                    .investments![index]
                                                    .investmentTimestamp;
                                                if (time != null) {
                                                  DateTime date = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          time);
                                                  text = DateFormat('MM-dd')
                                                      .format(date);
                                                }
                                              }
                                              print(
                                                  'bottomTitleWidgets-value:$value,text:$text');
                                              return SideTitleWidget(
                                                space: 1,
                                                axisSide: AxisSide.left,
                                                child: Text(
                                                  text,
                                                  style: const TextStyle(
                                                    fontSize: 7,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                      gridData: const FlGridData(
                                        drawHorizontalLine: false,
                                        drawVerticalLine: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox(height: 0),

                          // 间距
                          if (state.pageConfig.isShowLineChart == true &&
                              state.cardDetail?.investmentForecast != null)
                            const SizedBox(height: 10)
                          else
                            const SizedBox(height: 0),

                          // 名片信息区域（总是显示在第一位）
                          if (state.cardDetail != null && isShowVCCard(state))
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 20, bottom: 0),
                                child: NonInvestmentCardSection(
                                  card: state.cardDetail!,
                                  pageConfig: state.pageConfig,
                                  onTapQR: () {},
                                  totalBalance: state.sumBalanceInfo?.usd,
                                  showTotalBalance:
                                      state.pageConfig.isShowCardTotalBalance ==
                                          true,
                                ))
                          else
                            const SizedBox(),
                          const SizedBox(height: 10),
                          // ---------- 余额区 ----------
                          state.cardDetail != null &&
                                  state.pageConfig.isShowCardTotalBalance ==
                                      true
                              ? _showTotalInfoView(state, dispatch, viewService)
                              : const SizedBox.shrink(),

                          // 激活视图（内含与未激活合并后的投资摘要卡，仅一份）
                          buildNewActiveView(state, dispatch, viewService,
                              detailTitle1: detailTitle1, investime: investime),

                          const SizedBox(height: 10),

                          state.pageConfig.isShowKLine == true
                              ? SizedBox(
                                  height: 280,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        child: _makeuplinechart(
                                            state, dispatch, viewService),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),

                          state.pageConfig.isShowKLine == true
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          // DApp列表
                          if (state.pageConfig.isShowDapplist == true &&
                              state.dapplist.isNotEmpty == true)
                            buildDappList(dispatch, state, viewService),

                          // // 移除原底部按钮，移到Stack的Positioned中
                          // const SizedBox(height: 10),

                          // 激活按钮
                          if (state.pageConfig.isShowPostCardActivation ==
                                  true &&
                              (state.cardDetail?.investment == null ||
                                  state.cardDetail?.investment?.status ==
                                      'INACTIVE' ||
                                  state.cardDetail?.investment?.status ==
                                      'PROCESSING'))
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 14, right: 14, top: 0, bottom: 0),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   // borderRadius: BorderRadius.circular(20),
                                // ),
                                child: SlideToActButton(
                                  key: state.slideKey,
                                  width: 300,
                                  height: 30,
                                  sliderIconWidget: Image.asset(
                                    'assets/images/active_jiantou.png',
                                    width: 30,
                                  ),
                                  onCompleted: () {
                                    if (state.cardDetail?.uid != null) {
                                      dispatch(MyCardActionCreator
                                          .onPushInvestmentActviteClick(
                                              state.cardDetail!.uid!));
                                    }
                                  },
                                ))
                          else
                            const SizedBox(height: 0),

                          // 移除原底部按钮，移到Stack的Positioned中
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        CardBottomActionBar(
          state: state,
          dispatch: dispatch,
        ),
      ],
    ),
  );
}

bool isShowVCCard(MyCardState state) {
  /// 1️⃣ Card Logo
  bool cardLogoVisible = state.pageConfig.isShowCardLogo == true;

  bool result = cardLogoVisible ||
      state.pageConfig.isShowCardBrandImage == true ||
      state.pageConfig.isShowCardBrand == true ||
      state.pageConfig.isShowCardMerchantLogo == true ||
      state.pageConfig.isShowCardMerchantName == true ||
      state.pageConfig.isShowCardShapeImage == true ||
      state.pageConfig.isShowCardShape == true ||
      (state.pageConfig.isShowCardNo == true &&
          state.cardDetail?.cardNo?.isNotEmpty == true) ||
      (state.pageConfig.isShowPostCardName == true &&
          state.cardDetail?.contact?.isNotEmpty == true) ||
      (state.pageConfig.isShowCardMerchantTitle == true &&
          state.cardDetail?.merchant?.title?.isNotEmpty == true) ||
      (state.pageConfig.isShowPostCardMobile == true &&
          state.cardDetail?.mobile?.isNotEmpty == true) ||
      (state.pageConfig.isShowPostCardEmail == true &&
          state.cardDetail?.email?.isNotEmpty == true) ||
      (state.pageConfig.isShowPostCardAddress == true &&
          state.cardDetail?.address?.isNotEmpty == true) ||
      (state.pageConfig.isShowCardDescription == true &&
          state.cardDetail?.description?.isNotEmpty == true) ||
      (state.pageConfig.isShowCardTotalBalance == true &&
          state.sumBalanceInfo?.usd != null);
  return result;
}

Widget getBottomButon(
    Dispatch dispatch, MyCardState state, ViewService viewService) {
  return Row(
    mainAxisAlignment: (state.pageConfig.isShowCardAddCollection == true)
        ? MainAxisAlignment.spaceAround
        : MainAxisAlignment.center,
    children: [
      if (state.pageConfig.isShowCardAddCollection == true)
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // 左右分布
          children: [
            const Text(
              'Add to collection',
              style: TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 51, 51, 51)),
            ),
            Switch(
              activeThumbColor: const Color.fromARGB(255, 49, 165, 255),
              value: state.isSwitched,
              onChanged: (value) {
                dispatch(MyCardActionCreator.onExchangeCardSwitch(value));
              },
            ),
          ],
        )
      else
        const SizedBox(
          width: 0,
        ),
      if (state.pageConfig.isShowCardAddCollection == true)
        const SizedBox(
          width: 20,
        )
      else
        const SizedBox(
          width: 0,
        ),
      if (state.pageConfig.isShowPostCardReTap == true)
        ElevatedButton(
          onPressed: () => dispatch(MyCardActionCreator.onScanCardClick()),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // 去除默认内边距
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent, // 必须设为透明
            shadowColor: Colors.transparent,
          ),
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 49, 165, 255), // 左边颜色
                  Color.fromARGB(255, 9, 116, 255), // 右边颜色
                ],
              ),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: const Text(
                'Re-Tap',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      else
        const SizedBox(
          width: 0,
        ),
    ],
  );
}

void _showTimePicker(Dispatch dispatch, MyCardState state, BuildContext ctx) {
  if (state.cardDetail?.investmentInterval?.intervalTime == null ||
      state.cardDetail!.investmentInterval!.intervalTime!.isEmpty) {
    print("intervalTime 为空，无法显示 Picker");
    return;
  }

  state.pickerData = getColumData(state, ctx);
  _showMultiColumnPicker(dispatch, state, ctx, state.pickerData);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());

  String text = DateFormat('MM-dd').format(date); // 格式化日期
  print('bottomTitleWidgets-value:$value,text:$text');
  var mainLineColor = Colors.yellow;

  return SideTitleWidget(
    space: 1,
    axisSide: AxisSide.left,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 9,
        color: mainLineColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontSize: 10,
  );
  return SideTitleWidget(
    axisSide: AxisSide.left,
    child: Text('$value', style: style),
  );
}

bool _investmentIsInactive(MyCardState state) {
  final s = state.cardDetail?.investment?.status;
  return s == 'INACTIVE' ||
      s == 'PROCESSING' ||
      state.cardDetail?.investment == null;
}

/// 投资摘要卡是否展示（原 isShowInActiveCard / isShowActiveCard 合并，避免重复区块）
bool _shouldShowInvestmentSummaryCard(MyCardState state, String detailTitle1) {
  final p = state.pageConfig;
  if (state.cardDetail == null) return false;
  final inv = state.cardDetail!.investment;
  final fc = state.cardDetail!.investmentForecast;
  final inactive = _investmentIsInactive(state);

  if (inactive) {
    return (p.isShowCardplan == true && inv?.name != null) ||
        (p.isShowCardbalance == true &&
            state.cardDetail!.usdtBalance != null) ||
        (p.isShowCardMaxPeriods == true && fc?.investmentCount != null) ||
        (p.isShowCardCycle == true && inv?.intervalTypeName != null) ||
        (p.isShowCardMount == true && detailTitle1.isNotEmpty);
  }
  return (p.isShowPStatus == true && inv != null) ||
      (p.isShowCardplan == true && inv?.name != null) ||
      (p.isShowCardbalance == true && state.cardDetail!.usdtBalance != null) ||
      (p.isShowCardMount == true && detailTitle1.isNotEmpty) ||
      (p.isShowCardExecutedCount == true && inv?.executedCount != null) ||
      p.isShowCardCycle == true;
}

/// 与 [buildNewActiveView] 内顶部投资卡实际展示的 Text 条件一致；无可见行时视为「无元素」
bool _activeTopCardHasVisibleContent(MyCardState state) {
  final p = state.pageConfig;
  final f = state.cardDetail?.investmentForecast;
  if (f == null) return false;

  if (p.isShowTotalInvestment == true && f.totalInvestment != null) {
    return true;
  }
  if (p.isShowCurValue == true && f.totalValue != null) {
    return true;
  }
  if (p.isShowCurPirce == true && f.price != null) {
    return true;
  }
  if (p.isShowProfit == true && f.totalRevenue != null) {
    return true;
  }
  if (p.isShowRoi == true && f.earningRate != null) {
    return true;
  }
  return false;
}

bool _activeTopCardRow1Visible(MyCardState state) {
  final f = state.cardDetail?.investmentForecast;
  final p = state.pageConfig;
  return p.isShowTotalInvestment == true &&
      f != null &&
      f.totalInvestment != null;
}

bool _activeTopCardRow2Visible(MyCardState state) {
  final f = state.cardDetail?.investmentForecast;
  if (f == null) return false;
  final p = state.pageConfig;
  return (p.isShowCurValue == true && f.totalValue != null) ||
      (p.isShowCurPirce == true && f.price != null);
}

bool _activeTopCardRow3Visible(MyCardState state) {
  final f = state.cardDetail?.investmentForecast;
  if (f == null) return false;
  final p = state.pageConfig;
  return (p.isShowProfit == true && f.totalRevenue != null) ||
      (p.isShowRoi == true && f.earningRate != null);
}

/// 原未激活 / 已激活两套卡片 UI 合并：每种字段（如 Amount）只出现一次，按 [_investmentIsInactive] 区分第三列与周期行
Widget _buildMergedInvestmentSummaryCard(
  MyCardState state,
  Dispatch dispatch,
  ViewService viewService,
  String detailTitle1,
  String investime,
) {
  final p = state.pageConfig;
  final inactive = _investmentIsInactive(state);
  final inv = state.cardDetail?.investment;
  final fc = state.cardDetail?.investmentForecast;

  void onCardTap() {
    if (state.cardDetail?.category != "INVESTMENT") {
      dispatch(
          MyCardActionCreator.onPushWalletPage(state.cardDetail?.uid ?? ''));
      return;
    }
    if (inactive) {
      dispatch(
          MyCardActionCreator.onPushWalletPage(state.cardDetail?.uid ?? ''));
      return;
    }
    dispatch(MyCardActionCreator.onInvestmentPage(state.cardDetail?.uid ?? ''));
  }

  return Container(
    margin: const EdgeInsets.only(left: 14, right: 14, top: 1, bottom: 0),
    child: Material(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color.fromARGB(255, 160, 195, 235),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (inactive)
                if (p.isShowCardplan == true && inv?.name != null)
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 14, top: 14, bottom: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Plan:${inv!.name}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 166, 166, 166),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink()
              else if (p.isShowPStatus == true && inv != null)
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 14, top: 14, bottom: 0),
                  child: Row(
                    children: [
                      if (p.isShowCardplan == true && inv.name != null)
                        Text(
                          'Plan:${inv.name}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 166, 166, 166),
                          ),
                        ),
                      if (p.isShowCardplan == true && inv.name != null)
                        const SizedBox(width: 30),
                      Text(
                        'Status: ${inv.statusName ?? ""}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 166, 166, 166),
                        ),
                      ),
                    ],
                  ),
                )
              else if (p.isShowCardplan == true && inv?.name != null)
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 14, top: 14, bottom: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Plan:${inv!.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 166, 166, 166),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              SizedBox(height: inactive ? 0 : 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.isShowCardbalance == true &&
                      state.cardDetail?.usdtBalance != null)
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '\$${state.cardDetail?.usdtBalance ?? ""}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 94, 13),
                              fontSize: 24,
                            ),
                          ),
                          const Text(
                            'Card balance',
                            style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (p.isShowCardMount == true && detailTitle1.isNotEmpty)
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            detailTitle1,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 51, 51, 51),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Amount',
                            style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (inactive &&
                      p.isShowCardMaxPeriods == true &&
                      fc?.investmentCount != null)
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            '${fc!.investmentCount}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 51, 51, 51),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Maximum periods',
                            style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!inactive &&
                      p.isShowCardExecutedCount == true &&
                      inv?.executedCount != null)
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            '${inv!.executedCount}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 51, 51, 51),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Executed Count',
                            style: TextStyle(
                              color: Color.fromARGB(255, 148, 148, 148),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (p.isShowCardbalance == true ||
                  p.isShowCardMount == true ||
                  (inactive &&
                      p.isShowCardMaxPeriods == true &&
                      fc?.investmentCount != null) ||
                  (!inactive &&
                      p.isShowCardExecutedCount == true &&
                      inv?.executedCount != null))
                const SizedBox(height: 8)
              else
                const SizedBox.shrink(),
              if (inactive &&
                  p.isShowCardCycle == true &&
                  inv?.intervalTypeName != null)
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Cycle: ${inv!.intervalTypeName}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 171, 171, 171),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          _showTimePicker(dispatch, state, viewService.context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 49, 165, 255),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                ' Execute Time:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  investime,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (!inactive && p.isShowCardCycle == true)
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cycle: ${inv?.intervalDescription ?? ""}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 171, 171, 171),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildNewActiveView(
    MyCardState state, Dispatch dispatch, ViewService viewService,
    {required String detailTitle1, required String investime}) {
  print("ssss333333build333");

  final activeTopRow1 = _activeTopCardRow1Visible(state);
  final activeTopRow2 = _activeTopCardRow2Visible(state);
  final activeTopRow3 = _activeTopCardRow3Visible(state);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.pageConfig.isShowPreformace == true)
          const SizedBox(
            height: 30,
          )
        else
          const SizedBox(
            height: 0,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            if (state.pageConfig.isShowPreformace == true)
              const Text(
                "Performance 1 year ago",
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 51, 51, 51)), // 白色文字
              )
            else
              const SizedBox(width: 0),
            const SizedBox(width: 8),
          ],
        ),
        //   ),
        // ),
        if (state.pageConfig.isShowPreformace == true)
          const SizedBox(
            height: 10,
          )
        else
          const SizedBox(
            height: 0,
          ),
        if (_activeTopCardHasVisibleContent(state))
          Container(
              margin:
                  const EdgeInsets.only(left: 14, right: 14, top: 1, bottom: 0),
              // padding:
              //     EdgeInsets.only(top: 0, left: 15, right: 15),
              decoration: BoxDecoration(
                  color: _activeTopCardHasVisibleContent(state)
                      ? Colors.white
                      : const Color.fromARGB(255, 225, 240, 255),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (activeTopRow1)
                    Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 14,
                          top: 14,
                          bottom: (activeTopRow2 || activeTopRow3) ? 0 : 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                'Total Investment: \$ ${state.cardDetail!.investmentForecast!.totalInvestment}',
                                style: const TextStyle(fontSize: 12)),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 3, right: 3, top: 0, bottom: 0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await state.controller1.showTooltip();
                                  },
                                  child: SuperTooltip(
                                    barrierConfig:
                                        const BarrierConfiguration(show: true),
                                    controller: state.controller1,
                                    content: const Text(
                                      "Total Investment = Maximum periods * Amount",
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: const SizedBox(
                                      width: 15.0,
                                      height: 15.0,
                                      child: Icon(
                                        size: 15,
                                        Icons.info,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )),
                  if (activeTopRow2)
                    Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 14,
                          top: 14,
                          bottom: activeTopRow3 ? 0 : 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (state.pageConfig.isShowCurValue == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast!
                                        .totalValue !=
                                    null)
                              Text(
                                  'Current Value: \$ ${state.cardDetail!.investmentForecast!.totalValue}',
                                  style: const TextStyle(fontSize: 12))
                            else
                              const SizedBox(),
                            if (state.pageConfig.isShowCurValue == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast!
                                        .totalValue !=
                                    null)
                              const SizedBox(
                                width: 10,
                              )
                            else
                              const SizedBox(),
                            if (state.pageConfig.isShowCurPirce == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail?.investmentForecast?.price !=
                                    null)
                              Text(
                                  '${state.cardDetail!.investmentForecast!.name ?? "BTC"} Price: \$ ${state.cardDetail!.investmentForecast!.price}',
                                  style: const TextStyle(fontSize: 12))
                            else
                              const SizedBox(),
                          ],
                        )),
                  if (activeTopRow3)
                    Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 14, top: 14, bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (state.pageConfig.isShowProfit == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast
                                        ?.totalRevenue !=
                                    null)
                              Text(
                                  'Profit:\$ ${state.cardDetail!.investmentForecast!.totalRevenue} ',
                                  style: const TextStyle(fontSize: 12))
                            else
                              const SizedBox(),
                            if (state.pageConfig.isShowProfit == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast
                                        ?.totalRevenue !=
                                    null)
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 3, right: 3, top: 0, bottom: 0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await state.controller2.showTooltip();
                                    },
                                    child: SuperTooltip(
                                      barrierConfig: const BarrierConfiguration(
                                          show: true),
                                      controller: state.controller2,
                                      content: const Text(
                                        "Profit = Current Value - Total Investment",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: const SizedBox(
                                        width: 15.0,
                                        height: 15.0,
                                        child: Icon(
                                          size: 15,
                                          Icons.info,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ))
                            else
                              const SizedBox(),
                            if (state.pageConfig.isShowProfit == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast
                                        ?.totalRevenue !=
                                    null)
                              const SizedBox(
                                width: 10,
                              )
                            else
                              const SizedBox(),
                            if (state.pageConfig.isShowRoi == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast
                                        ?.earningRate !=
                                    null)
                              Text(
                                  'ROI: ${state.cardDetail!.investmentForecast!.earningRate}%',
                                  style: const TextStyle(fontSize: 12))
                            else
                              const SizedBox(),
                            if (state.pageConfig.isShowRoi == true &&
                                state.cardDetail!.investmentForecast != null &&
                                state.cardDetail!.investmentForecast
                                        ?.earningRate !=
                                    null)
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 3, right: 3, top: 0, bottom: 0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await state.controller3.showTooltip();
                                    },
                                    child: SuperTooltip(
                                      barrierConfig: const BarrierConfiguration(
                                          show: true),
                                      controller: state.controller3,
                                      content: const Text(
                                        "ROI = Profit / Total Investment * 100%",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: const SizedBox(
                                        width: 15.0,
                                        height: 15.0,
                                        child: Icon(
                                          size: 15,
                                          Icons.info,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ))
                            else
                              const SizedBox(),
                          ],
                        )),
                ],
              ))
        else
          const SizedBox(),

        if (_shouldShowInvestmentSummaryCard(state, detailTitle1))
          const SizedBox(height: 12),

        if (_shouldShowInvestmentSummaryCard(state, detailTitle1))
          _buildMergedInvestmentSummaryCard(
              state, dispatch, viewService, detailTitle1, investime),
      ],
    ),
  );
}

List<List<InvestmentSelectInfo>> getColumData(
    MyCardState state, BuildContext ctx) {
  List<List<InvestmentSelectInfo>> pickerData = [];
  String intervalType = state.cardDetail!.investment!.intervalType!;
  if (intervalType.toUpperCase().contains("年") ||
      intervalType.toUpperCase().contains("YEAR")) {
    pickerData = [
      state.cardDetail!.investmentInterval!.intervalMonth!,
      state.cardDetail!.investmentInterval!.intervalDay!,
      state.cardDetail!.investmentInterval!.intervalTime!
    ];
  } else if (intervalType.toUpperCase().contains("月") ||
      intervalType.toUpperCase().contains("MONTH")) {
    pickerData = [
      state.cardDetail!.investmentInterval!.intervalDay!,
      state.cardDetail!.investmentInterval!.intervalTime!
    ];
  } else if (intervalType.toUpperCase().contains("周") ||
      intervalType.toUpperCase().contains("WEEK")) {
    pickerData = [
      state.cardDetail!.investmentInterval!.intervalWeek!,
      state.cardDetail!.investmentInterval!.intervalTime!
    ];
  } else if (intervalType.toUpperCase().contains("日") ||
      intervalType.toUpperCase().contains("DAY")) {
    pickerData = [state.cardDetail!.investmentInterval!.intervalTime!];
  } else if (intervalType.toUpperCase().contains("小时") ||
      intervalType.toUpperCase().contains("HOUR")) {
    pickerData = [state.cardDetail!.investmentInterval!.intervalHour!];
  } else if (intervalType.toUpperCase().contains("分钟") ||
      intervalType.toUpperCase().contains("MINUTE")) {
    pickerData = [state.cardDetail!.investmentInterval!.intervalMinute!];
  }
  return pickerData;
}

void _showMultiColumnPicker(Dispatch dispatch, MyCardState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  if (column.length >= 3) {
    _showThreeColumnPicker(dispatch, state, ctx, column);
  } else if (column.length >= 2) {
    _showTwoColumnPicker(dispatch, state, ctx, column);
  } else if (column.isNotEmpty) {
    _showOneColumnPicker(dispatch, state, ctx, column);
  }
}

void _showThreeColumnPicker(Dispatch dispatch, MyCardState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  List<List<String>> list = [];
  List<int> select = [0, 0, 0];
  for (var i = 0; i < column.length; i++) {
    List<InvestmentSelectInfo> element = column[i];
    List<String> lisss = [];
    for (var j = 0; j < element.length; j++) {
      InvestmentSelectInfo info = element[j];
      lisss.add(info.displayValue);
      if (i == 0) {
        if (state.selectInfo1 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo1!.displayValue.toUpperCase()) {
          select[0] = j;
        } else if (state.cardDetail!.investment!.intervalExtend1Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend1Name!
                    .toUpperCase()) {
          select[0] = j;
        }
      }
      if (i == 1) {
        if (state.selectInfo2 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo2!.displayValue.toUpperCase()) {
          select[1] = j;
        } else if (state.cardDetail!.investment!.intervalExtend2Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend2Name!
                    .toUpperCase()) {
          select[1] = j;
        }
      }
      if (i == 2) {
        if (state.selectInfo3 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo3!.displayValue.toUpperCase()) {
          select[2] = j;
        } else if (state.cardDetail!.investment!.intervalExtend3Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend3Name!
                    .toUpperCase()) {
          select[2] = j;
        }
      }
    }
    list.add(lisss);
  }
  print("_showThreeColumnPicker:${select.toString()}");
  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: list,
        isArray: true,
      ),
      hideHeader: true,
      selecteds: select,
      title: const Text("Please Select"),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onCancel: () {
        // Navigator.pop(ctx);
      },
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        state.intervalExtend1 = value[0];
        state.intervalExtend2 = value[1];
        state.intervalExtend3 = value[2];
        state.selectInfo1 = column[0][state.intervalExtend1];
        state.selectInfo2 = column[1][state.intervalExtend2];
        state.selectInfo3 = column[2][state.intervalExtend3];
        print(picker.getSelectedValues());
        dispatch(
            MyCardActionCreator.onLoadSuccess(cardDetail: state.cardDetail!));
      }).showDialog(ctx);
}

void _showTwoColumnPicker(Dispatch dispatch, MyCardState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  List<List<String>> list = [];
  List<int> select = [0, 0];
  for (var i = 0; i < column.length; i++) {
    List<InvestmentSelectInfo> element = column[i];
    List<String> lisss = [];
    for (var j = 0; j < element.length; j++) {
      InvestmentSelectInfo info = element[j];
      lisss.add(info.displayValue);

      if (i == 0) {
        if (state.selectInfo1 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo1!.displayValue.toUpperCase() &&
            !select.contains(j)) {
          select[0] = j;
        } else if (state.cardDetail!.investment!.intervalExtend1Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend1Name!
                    .toUpperCase()) {
          select[0] = j;
        }
      }
      if (i == 1) {
        if (state.selectInfo2 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo2!.displayValue.toUpperCase()) {
          select[1] = j;
        } else if (state.cardDetail!.investment!.intervalExtend2Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend2Name!
                    .toUpperCase()) {
          select[1] = j;
        }
      }
      if (i == 2) {
        if (state.selectInfo3 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo3!.displayValue.toUpperCase()) {
          select[2] = j;
        } else if (state.cardDetail!.investment!.intervalExtend3Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend3Name!
                    .toUpperCase()) {
          select[2] = j;
        }
      }
    }
    list.add(lisss);
  }

  print("_showTwoColumnPicker:${select.toString()}");

  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: list,
        isArray: true,
      ),
      hideHeader: true,
      selecteds: select,
      title: const Text("Please Select"),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onCancel: () {
        // Navigator.pop(ctx);
      },
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        state.intervalExtend1 = value[0];
        state.intervalExtend2 = value[1];
        state.selectInfo1 = column[0][state.intervalExtend1];
        state.selectInfo2 = column[1][state.intervalExtend2];
        state.selectInfo3 = null;
        print(picker.getSelectedValues());
        dispatch(
            MyCardActionCreator.onLoadSuccess(cardDetail: state.cardDetail!));
      }).showDialog(ctx);
}

void upsertInt(List<int> list, int index, int newValue) {
  if (index != -1) {
    // 替换
    list[index] = newValue;
  } else {
    // 添加
    list.add(newValue);
  }
}

void _showOneColumnPicker(Dispatch dispatch, MyCardState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  List<List<String>> list = [];
  List<int> select = [0];
  for (var i = 0; i < column.length; i++) {
    List<InvestmentSelectInfo> element = column[i];
    List<String> lisss = [];
    for (var j = 0; j < element.length; j++) {
      InvestmentSelectInfo info = element[j];
      lisss.add(info.displayValue);
      if (i == 0) {
        if (state.selectInfo1 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo1!.displayValue.toUpperCase()) {
          select[0] = j;
        } else if (state.cardDetail!.investment!.intervalExtend1Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend1Name!
                    .toUpperCase()) {
          select[0] = j;
        }
      }
      if (i == 1) {
        if (state.selectInfo2 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo2!.displayValue.toUpperCase()) {
          select[1] = j;
        } else if (state.cardDetail!.investment!.intervalExtend2Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend2Name!
                    .toUpperCase()) {
          select[1] = j;
        }
      }
      if (i == 2) {
        if (state.selectInfo3 != null &&
            info.displayValue.toUpperCase() ==
                state.selectInfo3!.displayValue.toUpperCase()) {
          select[2] = j;
        } else if (state.cardDetail!.investment!.intervalExtend3Name != null &&
            info.displayValue.toUpperCase() ==
                state.cardDetail!.investment!.intervalExtend3Name!
                    .toUpperCase()) {
          select[2] = j;
        }
      }
    }
    list.add(lisss);
  }

  print("_showOneColumnPicker:${select.toString()}");
  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: list,
        isArray: true,
      ),
      hideHeader: true,
      selecteds: select,
      title: const Text("Please Select"),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onCancel: () {
        // Navigator.pop(ctx);
      },
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        state.intervalExtend1 = value[0];

        state.selectInfo1 = column[0][state.intervalExtend1];
        state.selectInfo2 = null;
        state.selectInfo3 = null;
        print(picker.getSelectedValues());
        dispatch(
            MyCardActionCreator.onLoadSuccess(cardDetail: state.cardDetail!));
      }).showDialog(ctx);
}

Widget buildDappList(
    Dispatch dispatch, MyCardState state, ViewService viewService) {
  return Card(
    margin: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended Apps",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// 与外层 SingleChildScrollView 合并为同一滚动轴，避免嵌套 ListView 抢手势导致无法上下滑动
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.dapplist.length,
            itemBuilder: (context, index) {
              final app = state.dapplist[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  ),
                ),
                child: ListTile(
                  leading: LoadImage(
                    app.imageUrl!,
                    width: 36,
                    height: 36,
                    holderImg: const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  title: Text(
                    app.name!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    app.brief!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                  onTap: () {
                    dispatch(MyCardActionCreator.onDappDetail(app));
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _makeuplinechart(
    MyCardState state, Dispatch dispatch, ViewService viewService) {
  String? code = state.KlineCode;
  // enablePinching + 默认 zoomMode.xy 会使图表注册纵向 Drag，拦截外层滚动；改为仅 X 轴缩放模式
  return SfCartesianChart(
    primaryXAxis: const CategoryAxis(),
    // primaryYAxis: NumericAxis(),
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      enablePanning: false,
      zoomMode: ZoomMode.x,
    ),
    selectionType: SelectionType.point,
    // Chart title
    title: ChartTitle(text: '$code ${state.KlineTitle}'),
    // Enable legend
    legend: Legend(
        isVisible: true,
        title: LegendTitle(text: (state.KlineTitle)),
        position: LegendPosition.top,
        alignment: ChartAlignment.near),

    // Enable tooltip

    tooltipBehavior: TooltipBehavior(
      enable: true,
      header: 'Data Point',
      format: 'point.x : point.y', // 设置格式化显示
      canShowMarker: true,
    ),
    series: <CartesianSeries<SalesData, String>>[
      LineSeries<SalesData, String>(
        dataSource: state.lineDatas,
        xValueMapper: (SalesData data, _) {
          // print('Mapped x: ${data.year}');
          return data.year;
        },

        yValueMapper: (SalesData data, _) {
          // print('Mapped Y: ${data.sales}');
          return data.sales;
        },

        onPointTap: (ChartPointDetails details) {
          if (details.pointIndex == null) {
            return;
          }
          // 使用 pointIndex 回查原始数据，避免依赖图表内部点模型字段变更。
          final tappedX = details.pointIndex;
          if (tappedX == null ||
              tappedX < 0 ||
              tappedX >= state.lineDatas.length) {
            return;
          }
          final tappedPoint = state.lineDatas[tappedX];
          final tappedY = tappedPoint.sales;
          EasyLoading.showToast("${tappedPoint.year}:  USD $tappedY");
          print('Tapped point: tappedXv=${tappedPoint.year}, y=$tappedY');
        },
        name: code,
        animationDelay: 0,
        enableTooltip: false,
        markerSettings: const MarkerSettings(
          isVisible: true,
          width: 4,
          height: 4,
        ),
        dataLabelMapper: (SalesData data, _) {
          // 显示最高点和最低点的数据标签
          if (data.isHighlight) {
            return 'MAX: ${data.sales}';
          } else if (data.isLowlight) {
            return 'LOW: ${data.sales}';
          }
          return "";
        },

        //Enable data label
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.auto),
      )
    ],
  );
}

Widget _showTotalInfoView(
    MyCardState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                  dispatch(MyCardActionCreator.onUpdateCurrency());
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
          subtitle: state.cryptoTotalPrice.contains('.')
              ? RichText(
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
                  // textDirection: TextDirection.ltr,
                )
              : RichText(
                  text: TextSpan(
                    // ignore: prefer_interpolation_to_compose_strings
                    text:
                        "${state.currentFiat.symbol} ${state.cryptoTotalPrice}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  //   textDirection: TextDirection.ltr,
                ),
          enabled: true,
          onTap: () {
            // dispatch(HdWalletActionCreator.onShowNickNameAlert());
          },
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, bottom: 10, top: 1, right: 1),
          child: Row(
            children: [
              _showSecodeUpateView(state, dispatch, viewService),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(viewService.context).pushNamed(
                      'lightningNetDetailPage',
                      arguments: {'uid': state.cardDetail!.uid});
                },
                child: const Text('Detail',
                    style: TextStyle(
                        color: Colors.blue, fontSize: 12, height: 1.2)),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _showSecodeUpateView(
    MyCardState state, Dispatch dispatch, ViewService viewService) {
  return TimeUpdateView(
      (state.sumBalanceInfo != null && state.sumBalanceInfo!.usd != null
          ? state.sumBalanceInfo!.usd
          : "0.0"), () {
    dispatch(MyCardActionCreator.onLoadCurrencyInfo());
    // _loadCurrencyInfo(currentIndex);
    // // if (sourceNDEF == false) {
    // _loadKLineInfo();
    // 60秒刷新
  });
}
