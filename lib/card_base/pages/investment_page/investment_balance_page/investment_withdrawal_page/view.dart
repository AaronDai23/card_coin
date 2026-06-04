import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(InvestmentWithdrawalState state, Dispatch dispatch,
    ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text('Invest Withdrawal'),
        actions: const [SizedBox()],
      ),
      body: BasePageLoadingView(
        buildBody: (isLoadSuccess) {
          if (isLoadSuccess) {
            return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              LoadImage(
                                state.detail!.imageUrl ?? '',
                                width: 23,
                                height: 23,
                              ),
                              Text(' ${state.detail!.symbol}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              dispatch(InvestmentWithdrawalActionCreator
                                  .onShowNetworks());
                            },
                            child: Row(
                              children: [
                                Text(
                                    "${state.detail!.code}-${state.investment!.netName}",
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                state.investmentList.length > 1
                                    ? const Icon(Icons.arrow_drop_down)
                                    : const SizedBox(
                                        height: 10.0,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Column(children: [
                        Text('${state.detail!.balance}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 10),
                        Text('${state.detail!.usdDisplayAmount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ))
                      ]),

                      const SizedBox(height: 20),
                      // **余额**
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: state.amountController,
                          style: const TextStyle(fontSize: 15),
                          focusNode: state.focusNode,
                          decoration: InputDecoration(
                            labelText: 'Withdrawal Amount',
                            border: InputBorder.none,
                            errorText: state.errorText,
                          ),
                          onChanged: (value) {
                            dispatch(
                                InvestmentWithdrawalActionCreator.onTextChang(
                                    value));
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildActionButton('Withdrawal', () {
                        dispatch(
                            InvestmentWithdrawalActionCreator.onWithdrawal());
                      }),
                    ]));
          } else {
            return const EmptyListView();
          }
        },
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
      ));
}

Widget _buildActionButton(String text, VoidCallback onPressed) {
  return Center(
    child: ElevatedButton(
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
    ),
  );
}
