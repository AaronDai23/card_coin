import 'package:animated_number/animated_number.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/investment_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InactiveSectionWeb extends StatelessWidget {
  final InvestmentViewModel model;
  final SmartCardDetail cardDetail;
  final VoidCallback onTapSelectTime;
  final Function(double y)? onTap;

  const InactiveSectionWeb({
    super.key,
    required this.model,
    required this.cardDetail,
    required this.onTapSelectTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAnyContent = _showTopPriceSection ||
        _showKLineSection ||
        _showInfoCardSection ||
        _showCycleSection;
    print(
        "InactiveSectionWeb build: showTopPriceSection:$_showTopPriceSection, showKLineSection:$_showKLineSection, showInfoCardSection:$_showInfoCardSection, showCycleSection:$_showCycleSection");

    // 👉 关键逻辑：全部不满足 = 完全不展示
    if (!hasAnyContent) {
      print("InactiveSectionWeb no show");
      return const SizedBox.shrink();
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 顶部价格 =====
              if (_showTopPriceSection) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    Text(
                      "Previous ${model.cardDetail!.investmentForecast!.name ?? "BTC"} Price:",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 51, 51, 51)), // 白色文字
                    ),
                    const SizedBox(width: 8),
                    AnimatedNumber(
                      key: ValueKey(model.valueArr[1]),
                      prefixText: "\$",
                      startValue: model.valueArr[0],
                      endValue: model.valueArr[1],
                      duration: const Duration(milliseconds: 300),
                      isFloatingPoint: true,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 13, 122, 255),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 12),
              ],
              // ===== K线图 =====
              if (_showKLineSection) ...[
                SizedBox(
                  height: 140,
                  child:
                      LineChart(_buildLineChartData(model, model.cardDetail!)),
                ),
                const SizedBox(height: 16),
              ],

              // ===== 信息卡片 =====
              if (_showInfoCardSection) ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.cardNo != null &&
                            model.showCardNo &&
                            cardDetail.category != null &&
                            cardDetail.category == "INVESTMENT")
                          Text(
                            "Card Name: ${model.cardNo}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        const SizedBox(height: 0),
                        Row(
                          children: [
                            if (model.cardBalance != null && model.showBalance)
                              Expanded(
                                child: _infoTile(
                                  "Card balance",
                                  "\$${model.cardBalance}",
                                  const Color(0xFFFF5E0D),
                                ),
                              ),
                            if (model.amount != null && model.showAmount)
                              Expanded(
                                child: _infoTile(
                                  "Amount",
                                  "\$${model.amount}",
                                ),
                              ),
                            if (model.maxPeriods != null &&
                                model.showMaxPeriods)
                              Expanded(
                                child: _infoTile(
                                  "Maximum periods",
                                  model.maxPeriods ?? "-",
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 0),
                        if (model.cycleName != null && model.showCycle)
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cycle: ${model.cycleName}}",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 171, 171, 171),
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),

                                  // 点击调起时间选择器

                                  // <-- 让按钮填满剩余空间
                                  GestureDetector(
                                    onTap: () {
                                      onTapSelectTime();
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color(0xFFF58A1F),
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(20),
                                          right: Radius.circular(20),
                                        ),
                                      ),
                                      // width: 180,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(" Execute Time: ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                child: Text(
                                                  model.executeTime,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
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
                        // Row(
                        //   children: [
                        //     if (model.cycleName != null && model.showCycle)
                        //       Text("Cycle: ${model.cycleName}"),
                        //     const SizedBox(width: 12),
                        //     if (model.showCycle)
                        //       Text(
                        //         "Execute Time: ${model.executeTime}",
                        //       ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]
            ],
          ),
        )
      ],
    );
  }

  LineChartData _buildLineChartData(
      InvestmentViewModel m, SmartCardDetail cardDetail) {
    print("_buildLineChartData:${m.spotList.length}");
    return LineChartData(
      minY: m.minY,
      maxY: m.maxY,
      maxX: m.spotList.isNotEmpty ? m.spotList.last.x : 0,
      minX: m.spotList.isNotEmpty ? m.spotList.first.x : 0,
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return const TouchedSpotIndicatorData(
              FlLine(
                color: Color.fromARGB(255, 44, 121, 255),
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
              const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          // tooltipBgColor: Colors
          //     .transparent, // 隐藏默认 Tooltip
          showOnTopOfTheChartBoxArea: true, // Tooltip 固定在顶部
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              int index = touchedSpot.x.toInt();
              // 判断是否为第一个或最后一个数据点
              TextAlign alignment = TextAlign.center;
              int time = m.cardDetail!.investmentForecast!.investments![index]
                  .investmentTimestamp!;
              DateTime date = DateTime.fromMillisecondsSinceEpoch(time);

              String text = DateFormat('yyyy-MM-dd').format(date);

              if (index == 0) {
                alignment = TextAlign.left; // 第一个点，提示语在右侧
                print("左边");
                text = "   $text";
              } else if (index == m.spotList.length - 1) {
                alignment = TextAlign.right; // 最后一个点，提示语在左侧
                print("you边");
                text = "$text   ";
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
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          print('LineTouchResponse:event:$event');
          if ((event is FlPanUpdateEvent || event is FlLongPressMoveUpdate) &&
              response != null &&
              response.lineBarSpots != null &&
              response.lineBarSpots!.isNotEmpty) {}

          // 松手或手势结束时取消
          if (event is FlTapUpEvent ||
              // event is FlLongPressEnd ||
              // event is FlPanEndEvent ||
              event is FlPointerExitEvent) {
          } else {
            if (response == null || response.lineBarSpots == null) return;
            //  state.lastTouchedSpot = spot1;
          }
          if (response == null || response.lineBarSpots == null) return;

          final spot = response.lineBarSpots!.first;
          final y = spot.y;

          if (m.valueArr[1] == y) {
            //   return;
            print("response.lineBarSpot:$y");
          }
          onTap?.call(y);
          // 在此处理触摸点的数据，例如更新状态或显示自定义信息
          // dispatch(MyCardActionCreator
          //     .onUpdateCurNum(y));
        },
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: double.parse(
                m.cardDetail!.investmentForecast!.averagePrice!), // 标准线的 Y 轴位置
            color: const Color.fromARGB(255, 44, 121, 255), // 标准线颜色
            strokeWidth: 1, // 标准线宽度
            dashArray: [5, 5], // 虚线样式，可选
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (line) =>
                  'Avg ${m.cardDetail!.investmentForecast!.name ?? "BTC"} Price: \$${double.parse(m.cardDetail!.investmentForecast!.averagePrice!).toInt()}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 44, 121, 255),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      lineBarsData: [
        LineChartBarData(
            spots: m.spotList,
            isCurved: true,
            barWidth: 2,
            color: const Color.fromARGB(255, 255, 94, 13),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 1,
                  strokeColor: const Color.fromARGB(255, 255, 94, 13),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 94, 13),
                  const Color.fromARGB(255, 225, 240, 255)
                ].map((color) => color.withOpacity(0.5)).toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )),
      ],
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // reservedSize: ,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (cardDetail.investmentForecast!.investments!.isEmpty) {
                var mainLineColor = Colors.black;

                return SideTitleWidget(
                  space: 1,
                  axisSide: AxisSide.left,
                  child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 7,
                      color: mainLineColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              int time = cardDetail
                  .investmentForecast!.investments![index].investmentTimestamp!;
              DateTime date = DateTime.fromMillisecondsSinceEpoch(time);

              String text = DateFormat('MM-dd').format(date); // 格式化日期
              print('bottomTitleWidgets-value:$value,text:$text');
              var mainLineColor = Colors.black;

              return SideTitleWidget(
                space: 1,
                axisSide: AxisSide.left,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 7,
                    color: mainLineColor,
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
        border: Border.all(color: Colors.black.withOpacity(0.5)),
      ),
      gridData: const FlGridData(
        drawHorizontalLine: false, // 隐藏水平网格线
        drawVerticalLine: false, // 隐藏垂直网格线
      ),
    );
  }

  Widget _infoTile(String title, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, color: color ?? Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF949494),
          ),
        ),
      ],
    );
  }

  bool get _showTopPriceSection {
    return model.valueArr.isNotEmpty &&
        model.valueArr.length >= 2 &&
        model.cardDetail?.investmentForecast?.name != null &&
        _showKLineSection;
  }

  bool get _showKLineSection {
    return model.showKLine;
  }

  bool get _showInfoCardSection {
    return (model.cardNo != null &&
            model.showCardNo &&
            cardDetail.category == "INVESTMENT") ||
        (model.cardBalance != null && model.showBalance) ||
        (model.amount != null && model.showAmount) ||
        (model.maxPeriods != null && model.showMaxPeriods);
  }

  bool get _showCycleSection {
    return model.showCycle && model.cycleName != null;
  }
}
