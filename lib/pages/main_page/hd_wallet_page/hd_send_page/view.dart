import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/custom_button.dart';
import '../../../../custom_widget/load_image.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    HdSendState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;

  return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          title: Text(
            languageResource.send,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(viewService.context).pop();
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(viewService.context).pushNamed(
                    'transactionDetailPage',
                    arguments: {'wallet': state.currencyInfo, 'type': 1}),
                child: Text(
                  languageResource.transactionRecord,
                  style: const TextStyle(color: Colors.white),
                ))
          ]),
      backgroundColor: Colors.white,
      body: PageDataLoadingView(
        onLoadSuccess: () {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "${state.currencyInfo.currencyData.id}-${state.currencyInfo.networkName}",
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        languageResource.sendAddress,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: state.isValidate ?? false
                                ? Colors.green
                                : null),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: languageResource.inputAddressTip,
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 14.0),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                controller: state.addressController,
                                onChanged: (text) => dispatch(
                                    HdSendActionCreator.onValidateAddress(
                                        text)),
                              ),
                            ),
                            IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () =>
                                    dispatch(HdSendActionCreator.onScanQR()),
                                icon: const LoadAssetImage(
                                  'scan',
                                  width: 30.0,
                                  height: 30.0,
                                ))
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !(state.isValidate ?? true),
                        child: Text(
                          languageResource.invalidAddress,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10.0,
                  color: Colors.grey[200],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          languageResource.sendQuantity,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${languageResource.availableAmount} ${state.currencyInfo.balance ?? "0.0"}',
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey[400]),
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: languageResource.inputQuantityTip,
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 14.0),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                controller: state.amountController,
                                onChanged: (text) {
                                  if (text.isEmpty) {
                                    dispatch(HdSendActionCreator.onAmountChange(
                                        text));
                                    return;
                                  }
                                  var value = double.tryParse(text);
                                  if (value == null) {
                                    return;
                                  }
                                  dispatch(
                                      HdSendActionCreator.onAmountChange(text));
                                },
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  final balance = num.tryParse(
                                          state.currencyInfo.balance ?? '0') ??
                                      0;
                                  final isNativeCoin = state
                                          .currencyInfo
                                          .currencyData
                                          .contractAddress
                                          ?.isEmpty ??
                                      true;
                                  final networkId = state
                                      .currencyInfo.currencyData.networkId
                                      .toLowerCase();
                                  final isTrx = networkId.contains('trx') ||
                                      networkId.contains('tron');
                                  num maxSendable = balance;
                                  // TRX fee 来自带宽，不扣余额；其他原生链才扣 fee
                                  if (isNativeCoin &&
                                      !isTrx &&
                                      (state.networkList?.isNotEmpty ??
                                          false)) {
                                    final fee = num.tryParse(state
                                            .networkList![state.networkIndex]
                                            .fee) ??
                                        0;
                                    maxSendable = (balance - fee)
                                        .clamp(0, double.infinity);
                                  }
                                  final amount = maxSendable.toString();
                                  state.amountController.text = amount;
                                  dispatch(HdSendActionCreator.onAmountChange(
                                      amount));
                                },
                                child: Text(
                                  languageResource.all,
                                  style: const TextStyle(fontSize: 16.0),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10.0,
                  color: Colors.grey[200],
                ),
                state.networkList?.isNotEmpty ?? false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  languageResource.transactionFee,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  () {
                                    final rawFee = state
                                        .networkList![state.networkIndex].fee;
                                    final isToken = !(state
                                            .currencyInfo
                                            .currencyData
                                            .contractAddress
                                            ?.isEmpty ??
                                        true);
                                    if (!isToken) return rawFee;
                                    // Token: show fee in main-chain unit
                                    final networkId = state
                                        .currencyInfo.currencyData.networkId
                                        .toUpperCase();
                                    String feeUnit = '';
                                    if (networkId.contains('ETH') ||
                                        networkId.contains('RTAP') ||
                                        networkId.contains('RTBP')) {
                                      feeUnit = 'ETH';
                                    } else if (networkId.contains('BSC') ||
                                        networkId.contains('BNB')) {
                                      feeUnit = 'BNB';
                                    } else if (networkId.contains('MATIC') ||
                                        networkId.contains('POLYGON')) {
                                      feeUnit = 'MATIC';
                                    } else if (networkId.contains('TRON') ||
                                        networkId.contains('TRX')) {
                                      feeUnit = 'TRX';
                                    }
                                    return feeUnit.isNotEmpty
                                        ? '$rawFee $feeUnit'
                                        : rawFee;
                                  }(),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: state.networkList!
                                  .asMap()
                                  .entries
                                  .map((e) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: OutlinedButton(
                                            onPressed: () => dispatch(
                                                HdSendActionCreator
                                                    .onUpdateNetworkIndex(
                                                        e.key)),
                                            style: ButtonStyle(
                                                side: WidgetStateProperty.all(
                                                    BorderSide(
                                                        color: e.key ==
                                                                state
                                                                    .networkIndex
                                                            ? const Color
                                                                .fromRGBO(
                                                                0, 0, 255, 0.5)
                                                            : const Color(
                                                                0xFFDEDEDE)))),
                                            child: Text(
                                              e.value.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 8.0,
                ),
                state.networkList?.isNotEmpty ?? false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languageResource.receivedQuantity,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    () {
                                      final amtText =
                                          state.amountController.text;
                                      if (amtText.isEmpty ||
                                          num.tryParse(amtText) == 0) {
                                        return '0.0';
                                      }
                                      final isToken = !(state
                                              .currencyInfo
                                              .currencyData
                                              .contractAddress
                                              ?.isEmpty ??
                                          true);
                                      // Token: fee is in main-chain gas coin, received = full input amount
                                      if (isToken) {
                                        return '$amtText ${state.currencyInfo.currencyData.symbol}';
                                      }
                                      // Native coin: received = amount - fee
                                      return NumberUtils
                                          .getFullCountBetweenTwoNumber(
                                        amtText,
                                        state.networkList![state.networkIndex]
                                            .fee
                                            .toString(),
                                        1,
                                      );
                                    }(),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            ]))
                    : const SizedBox(),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Builder(builder: (_) {
                    final amountText = state.amountController.text;
                    final amountValid = amountText.isNotEmpty &&
                        (double.tryParse(amountText) ?? 0) > 0;
                    final canSend = state.isValidate == true &&
                        amountValid &&
                        (state.networkList?.isNotEmpty ?? false);
                    return CCButton(
                      verticalPadding: 15,
                      onPressed: canSend
                          ? () => dispatch(HdSendActionCreator.onShowAlert())
                          : null,
                      child: Center(child: Text(languageResource.send)),
                    );
                  }),
                ),
              ],
            ),
          );
        },
        loadStatus: state.loadStatus,
      ));
}
