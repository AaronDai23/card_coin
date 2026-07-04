import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    WithdrawLightningState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
    ),
    body: PageDataLoadingView(
      onLoadSuccess: () {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.yellow),
                  child: const Text(
                    'Note:\nWithdrawal target address is always current wallet ВТС address.',
                    style: TextStyle(fontSize: 12),
                  )),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current balance:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                              '${NumberUtils.formatNumber(num.tryParse(state.flashBalanceDetail.primaryBalance)!, 10)} ${state.flashBalanceDetail.primaryUnit}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.white24,

                        ///文本输入框
                        child: TextField(
                          onChanged: (value) {
                            if (value.isEmpty) {
                              return;
                            }
                            dispatch(
                                WithdrawLightningActionCreator.onAmountChanged(
                                    value));
                          },
                          maxLines: null,
                          style: const TextStyle(color: Colors.orange),
                          keyboardType: TextInputType.number,

                          ///焦点获取
                          focusNode: state.focusNode,
                          decoration: InputDecoration(
                            hintText: "Amount to receive",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              textBaseline: TextBaseline.ideographic,
                            ),

                            labelText: "Enter amount",
                            labelStyle: const TextStyle(color: Colors.orange),
                            errorText: state.errorTip,
                            counterText: state.mount.isEmpty
                                ? ""
                                : "≈ \$ ${state.mount}",
                            counterStyle: const TextStyle(color: Colors.orange),

                            suffixIcon: DropdownButton<UnitInfo>(
                              value: state.selectedUnit,
                              icon: const Image(
                                  image: AssetImage(
                                      'assets/images/expand_more.png'),
                                  height: 15,
                                  width: 15),
                              onChanged: (newValue) {
                                dispatch(WithdrawLightningActionCreator
                                    .onUnitChanged(newValue));
                              },
                              items: state.unitInfoList!
                                  .map<DropdownMenuItem<UnitInfo>>(
                                      (UnitInfo value) {
                                return DropdownMenuItem<UnitInfo>(
                                  value: value,
                                  child: Text(
                                    value.symbol.toUpperCase(),
                                  ),
                                );
                              }).toList(),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),

                            //设置输入框可编辑时的边框样式
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black), // 错误时的边框颜色
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black), // 聚焦错误时的边框颜色
                            ),

                            // ///用来配置输入框获取焦点时的颜色
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CCButton(
                  child: const Text('Withdrawal'),
                  onPressed: () => dispatch(
                      WithdrawLightningActionCreator.onWithdrawClick()),
                ),
              )
            ],
          ),
        );
      },
      loadStatus: state.loadStatus,
    ),
  );
}
