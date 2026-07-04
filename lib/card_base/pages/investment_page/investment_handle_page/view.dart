import 'package:card_coin/card_base/bean/Investment_forecast_info.dart';
import 'package:card_coin/card_base/bean/Investment_select_info.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InvestmentHandleState state, Dispatch dispatch, ViewService viewService) {
  bool isShowHostory = state.investDetail != null;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text("Fixed Investment"),
      actions: [
        isShowHostory == true
            ? IconButton(
                onPressed: () {
                  dispatch(InvestmentHandleActionCreator.onHistoryAction());
                },
                icon: const Icon(Icons.history))
            : const SizedBox()
      ],
    ),
    body: BasePageLoadingView(
        onReload: () {},
        buildBody: (isLoadSuccess) {
          if (isLoadSuccess) {
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // **名称输入**
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: state.nameController,
                              enabled: state.investmentConfig == null,
                              style: const TextStyle(fontSize: 15),
                              focusNode: state.focusNode,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                state.investmentName = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // **币种选择 + 金额输入 + 定投周期选择 (整体卡片)**
                          _buildInvestmentCard(state, dispatch, viewService),

                          const SizedBox(height: 20),

                          if (state.investDetail != null &&
                              state.investDetail!.investmentConfig != null &&
                              (state.investDetail!.investmentConfig!
                                          .investmentAssetDestination ==
                                      'WITHDRAW' ||
                                  state.investDetail!.investmentConfig!
                                          .investmentAssetDestination ==
                                      'CENTRALIZED'))
                            // **可用余额**
                            _buildBalanceCard(state),

                          if (state.investDetail != null &&
                              state.investDetail?.contractBalance != null)
                            const SizedBox(height: 20),

                          if (state.investDetail != null &&
                              state.investDetail?.contractBalance != null)
                            _buildAddressCard(state),

                          const SizedBox(height: 30),

                          // **操作按钮**
                          _buildActionButtons(state, dispatch),

                          SizedBox(height: state.isShowForecast ? 20 : 0),

                          state.isShowForecast
                              ? _buildForecast(state)
                              : const SizedBox(),

                          state.isShowForecast
                              ? const Divider()
                              : const SizedBox(),
                          state.isShowForecast
                              ? const Center(
                                  child: Text("Detail"),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: state.isShowForecast &&
                      state.investmentForecast != null &&
                      state.investmentForecast!.investments != null &&
                      state.investmentForecast!.investments!.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero, // 确保内容紧贴 NestedScrollView
                      itemCount: state.investmentForecast!.investments!
                          .length, // 这里可以是你的数据列表
                      itemBuilder: (context, index) {
                        InvestmentForecastInfo info =
                            state.investmentForecast!.investments![index];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Amount and BTC amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      LoadImage(
                                        (info.acquisitionImageUrl ?? ""),
                                        height: 23.0,
                                        width: 23.0,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        '${info.acquisitionUnit}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${info.acquisitionAmount}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Date and status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    info.investmentTime ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Buy:USDT ${info.investmentAmount}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Date and status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Investment Number:${info.investmentNumber}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Price:${info.price}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
            );
          } else {
            return const EmptyListView();
          }
        },
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg),
  );
}

Widget _buildInvestmentCard(
    InvestmentHandleState state, dispatch, ViewService viewService) {
  String period = "";
  period = [
    state.selectInfo1?.displayValue,
    state.selectInfo2?.displayValue,
    state.selectInfo3?.displayValue
  ].where((e) => e != null).join(", ");
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // **币种选择**
        GestureDetector(
          onTap: () {
            if (state.investmentConfig != null) {
              return;
            }
            dispatch(InvestmentHandleActionCreator.onSelectCoin());
          },
          child: Container(
              padding: const EdgeInsets.all(1), // 确保有内边距
              width: double.infinity, // 让整个区域都可点击
              color: Colors.transparent, // 透明背景，让空白区域可点击
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Buy Coin", style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Text(
                          (state.investDetail != null &&
                                  state.investDetail!.investmentConfig !=
                                      null &&
                                  (state.investDetail!.investmentConfig!
                                              .investmentAssetDestination ==
                                          'WITHDRAW' ||
                                      state.investDetail!.investmentConfig!
                                              .investmentAssetDestination ==
                                          'CENTRALIZED'))
                              ? (state.coinInfo != null
                                  ? (state.coinInfo!.displayName ?? '')
                                  : '')
                              : (state.investDetail!.assetToName ?? ''),
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              )),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Colors.grey),

        // **金额输入**
        TextField(
          controller: state.amountController,
          enabled: state.investmentConfig == null,
          style: const TextStyle(fontSize: 26),
          focusNode: state.focusNode2,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: state.investmentConfig != null
                ? state.investDetail!.assetFrom ?? ""
                : '≥ 0 USDT',
            border: InputBorder.none,
            errorText: state.errorText,
          ),
          onChanged: (value) {
            dispatch(InvestmentHandleActionCreator.onTextChang(value));
          },
        ),
        const Divider(height: 1, color: Colors.grey),
        const SizedBox(height: 16),

        // **定投周期**
        GestureDetector(
          onTap: () {
            if (state.investmentConfig != null) {
              return;
            }
            _showTimePicker(dispatch, state, viewService.context);
          },
          child: Container(
            padding: const EdgeInsets.all(1), // 确保有内边距
            width: double.infinity, // 让整个区域都可点击
            color: Colors.transparent, // 透明背景，让空白区域可点击
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Cycle", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Text(
                        "every ${state.investment.intervalUnit?.isNotEmpty == true ? '${state.investment.intervalUnit![state.selectedCycle].displayValue}: $period' : '请选择'} ",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButtons(InvestmentHandleState state, dispatch) {
  if (state.investDetail == null) {
    if ((state.investmentConfig != null &&
        state.investmentConfig!.investmentCreation == false)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton('Forecast', () {
            dispatch(InvestmentHandleActionCreator.onForecastAction());
          })
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton('Create Investment', () {
            dispatch(InvestmentHandleActionCreator.onAddAction());
          }),
          _buildActionButton('Forecast', () {
            dispatch(InvestmentHandleActionCreator.onForecastAction());
          })
        ],
      );
    }
  }

  if (state.investDetail!.status == "COMPLETED") {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (state.investDetail != null &&
            state.investDetail!.investmentConfig != null &&
            state.investDetail!.investmentConfig!.investmentAssetDestination ==
                'CONTRACTS')
          _buildActionButton('Flow History', () {
            dispatch(InvestmentHandleActionCreator.onFlowHistory());
          }),
      ],
    );
  }

  if (state.investDetail!.status == "EXECUTING") {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton('Pause', () {
          dispatch(InvestmentHandleActionCreator.onOprateAction(
              InvestmentActionType.puase));
        }),
        _buildActionButton('Stop', () {
          dispatch(InvestmentHandleActionCreator.onOprateAction(
              InvestmentActionType.stop));
        }),
        if (state.investDetail != null &&
            state.investDetail!.investmentConfig != null &&
            state.investDetail!.investmentConfig!.investmentAssetDestination ==
                'CONTRACTS')
          _buildActionButton('Flow History', () {
            dispatch(InvestmentHandleActionCreator.onFlowHistory());
          }),
      ],
    );
  }

  if (state.investDetail!.status != "TERMINATED") {
    if ((state.investmentConfig != null &&
        state.investmentConfig!.investmentCreation == false)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton('Forecast', () {
            dispatch(InvestmentHandleActionCreator.onForecastAction());
          }),
          _buildActionButton('Resume', () {
            dispatch(InvestmentHandleActionCreator.onOprateAction(
                InvestmentActionType.resume));
          }),
          if (state.investDetail != null &&
              state.investDetail!.investmentConfig != null &&
              state.investDetail!.investmentConfig!
                      .investmentAssetDestination ==
                  'CONTRACTS')
            _buildActionButton('Flow History', () {
              dispatch(InvestmentHandleActionCreator.onFlowHistory());
            }),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton('Update', () {
            dispatch(InvestmentHandleActionCreator.onEditAction());
          }),
          _buildActionButton('Forecast', () {
            dispatch(InvestmentHandleActionCreator.onForecastAction());
          }),
          _buildActionButton('Resume', () {
            dispatch(InvestmentHandleActionCreator.onOprateAction(
                InvestmentActionType.resume));
          }),
          if (state.investDetail != null &&
              state.investDetail!.investmentConfig != null &&
              state.investDetail!.investmentConfig!
                      .investmentAssetDestination ==
                  'CONTRACTS')
            _buildActionButton('Flow History', () {
              dispatch(InvestmentHandleActionCreator.onFlowHistory());
            }),
        ],
      );
    }
  }

  return const SizedBox();
}

Widget _buildBalanceCard(state) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Available', style: TextStyle(fontSize: 16)),
        Text('${state.totalCoin} USDT', style: const TextStyle(fontSize: 16)),
      ],
    ),
  );
}

Widget _buildAddressCard(state) {
  print("objectToJson(state.investDetail!.contractBalance)");
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'contract balance '
                "${state.investDetail.contractBalance.balance ?? 0.0}"
                " ${state.investDetail.contractBalance.symbol}",
                style: const TextStyle(fontSize: 16))
          ],
        ),
        // const Divider(
        //   height: 1,
        //   color: Colors.grey,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('Balance', style: TextStyle(fontSize: 16)),
        //     Text(state.investDetail.contractBalance.balance ?? "0.0",
        //         style: TextStyle(fontSize: 16)),
        //   ],
        // ),
      ],
    ),
  );
}

Widget _buildForecast(InvestmentHandleState state) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Center(
          child: Text("去年同期预估"),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('总投入:USDT ${state.investmentForecast!.totalInvestment}',
                style: const TextStyle(fontSize: 12)),
            Text(
                '总获得:${state.investmentForecast!.acquisitionUnit} ${state.investmentForecast!.totalAcquisition}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('总价值:USDT ${state.investmentForecast!.totalValue}',
                style: const TextStyle(fontSize: 12)),
            Text('总收益:USDT ${state.investmentForecast!.totalRevenue}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('收益率: ${state.investmentForecast!.earningRate}%',
                style: const TextStyle(fontSize: 12)),
            Text('行情价:USDT ${state.investmentForecast!.price}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}

void _showTimePicker(
    Dispatch dispatch, InvestmentHandleState state, BuildContext ctx) {
  List<List<InvestmentSelectInfo>> pickerData = getColumData(state, ctx);

  if (pickerData.isEmpty) {
    print("pickerData 为空，无法显示 Picker");
    return;
  }

  if (state.investment.intervalUnit == null ||
      state.investment.intervalUnit!.isEmpty) {
    print("intervalUnit 为空，无法显示 Picker");
    return;
  }

  List<String> list =
      (state.investment.intervalUnit ?? []).map((e) => e.displayValue).toList();
  print("intervalUnit-investment：${list.toString()}");
  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: [list], // 处理空值
        isArray: true,
      ),
      hideHeader: true,
      title: const Text("Select Cycle"),
      selectedTextStyle: const TextStyle(color: Colors.orange),
      onCancel: () {
        // Navigator.pop(ctx);
      },
      onConfirm: (Picker picker, List<int> value) {
        print(value.toString());
        print(picker.getSelectedValues());
        state.selectedCycle = value[0];
        state.cycleInfo = state.investment.intervalUnit![state.selectedCycle];
        // Navigator.of(ctx).pop();
        state.pickerData = getColumData(state, ctx);
        _showMultiColumnPicker(dispatch, state, ctx, state.pickerData);
      }).showDialog(ctx);
}

List<List<InvestmentSelectInfo>> getColumData(
    InvestmentHandleState state, BuildContext ctx) {
  List<List<InvestmentSelectInfo>> pickerData = [];
  state.cycleInfo = state.investment.intervalUnit![state.selectedCycle];
  if (state.cycleInfo!.displayValue.contains("年") ||
      state.cycleInfo!.displayValue.contains("Year")) {
    pickerData = [
      state.investment.intervalMonth!,
      state.investment.intervalDay!,
      state.investment.intervalTime!
    ];
  } else if (state.cycleInfo!.displayValue.contains("月") ||
      state.cycleInfo!.displayValue.contains("Month")) {
    pickerData = [
      state.investment.intervalDay!,
      state.investment.intervalTime!
    ];
  } else if (state.cycleInfo!.displayValue.contains("周") ||
      state.cycleInfo!.displayValue.contains("Week")) {
    pickerData = [
      state.investment.intervalWeek!,
      state.investment.intervalTime!
    ];
  } else if (state.cycleInfo!.displayValue.contains("日") ||
      state.cycleInfo!.displayValue.contains("Day")) {
    pickerData = [state.investment.intervalTime!];
  } else if (state.cycleInfo!.displayValue.contains("小时") ||
      state.cycleInfo!.displayValue.contains("Hour")) {
    pickerData = [state.investment.intervalHour!];
  } else if (state.cycleInfo!.displayValue.contains("分钟") ||
      state.cycleInfo!.displayValue.contains("Minute")) {
    pickerData = [state.investment.intervalMinute!];
  }
  return pickerData;
}

void _showMultiColumnPicker(Dispatch dispatch, InvestmentHandleState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  if (column.length >= 3) {
    _showThreeColumnPicker(dispatch, state, ctx, column);
  } else if (column.length >= 2) {
    _showTwoColumnPicker(dispatch, state, ctx, column);
  } else if (column.isNotEmpty) {
    _showOneColumnPicker(dispatch, state, ctx, column);
  }
}

void _showThreeColumnPicker(Dispatch dispatch, InvestmentHandleState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  List<List<String>> list = [];

  for (var element in column) {
    List<String> lisss = [];
    for (var element1 in element) {
      lisss.add(element1.displayValue);
    }
    list.add(lisss);
  }
  print("_showThreeColumnPicker:${list.toString()}");
  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: list,
        isArray: true,
      ),
      hideHeader: true,
      // selecteds: [3, 0, 2],
      title: const Text("Please Select"),
      selectedTextStyle: const TextStyle(color: Colors.orange),
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
        dispatch(InvestmentHandleActionCreator.onProSuc());
      }).showDialog(ctx);
}

void _showTwoColumnPicker(Dispatch dispatch, InvestmentHandleState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  List<List<String>> list = [];

  for (var element in column) {
    List<String> lisss = [];
    for (var element1 in element) {
      lisss.add(element1.displayValue);
    }
    list.add(lisss);
  }
  print("_showTwoColumnPicker:${list.toString()}");

  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: list,
        isArray: true,
      ),
      hideHeader: true,
      // selecteds: [0, 0],
      title: const Text("Please Select"),
      selectedTextStyle: const TextStyle(color: Colors.orange),
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
        dispatch(InvestmentHandleActionCreator.onProSuc());
      }).showDialog(ctx);
}

void _showOneColumnPicker(Dispatch dispatch, InvestmentHandleState state,
    BuildContext ctx, List<List<InvestmentSelectInfo>> column) {
  List<List<String>> list = [];

  for (var element in column) {
    List<String> lisss = [];
    for (var element1 in element) {
      lisss.add(element1.displayValue);
    }
    list.add(lisss);
  }

  print("_showOneColumnPicker:${list.toString()}");
  Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: list,
        isArray: true,
      ),
      hideHeader: true,
      selecteds: [0],
      title: const Text("Please Select"),
      selectedTextStyle: const TextStyle(color: Colors.orange),
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
        dispatch(InvestmentHandleActionCreator.onProSuc());
      }).showDialog(ctx);
}

Widget _buildActionButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
