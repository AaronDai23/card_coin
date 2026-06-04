import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(SendLightningInvoiceState state, Dispatch dispatch,
    ViewService viewService) {
  String primaryBalanceText;
  String invoiceAmountText;
  String expireTime;
  if (state.invoiceInfo != null) {
    primaryBalanceText =
        '${NumberUtils.formatNumber(num.tryParse(state.flashBalanceDetail.primaryBalance)!, 10)} ${state.flashBalanceDetail.primaryUnit}';
    invoiceAmountText =
        '${NumberUtils.formatNumber(state.invoiceInfo!.primaryBalance, 10)} ${state.invoiceInfo!.primaryUnit}';
    expireTime = DateUtil.formatDateMs(state.invoiceInfo!.expireTime);
  } else {
    primaryBalanceText = '--';
    invoiceAmountText = '--';
    expireTime = '--';
  }

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
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Invoice Address',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () => dispatch(
                        SendLightningInvoiceActionCreator.onScanQRCode()),
                    icon: const LoadAssetImage(
                      'scan',
                      width: 30,
                      height: 30,
                      color: Colors.black,
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: TextField(
                minLines: 4,
                maxLines: 10,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: state.invoiceController,
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    dispatch(
                        SendLightningInvoiceActionCreator.onValidateAddress(
                            text.trim()));
                  }
                },
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    dispatch(
                        SendLightningInvoiceActionCreator.onValidateAddress(
                            text.trim()));
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Enter invoice address or scan by QR code',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current balance:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(primaryBalanceText,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Invoice Amount:',
                          style: TextStyle(color: Colors.grey)),
                      Text(invoiceAmountText,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expire Time:',
                          style: TextStyle(color: Colors.grey)),
                      Text(expireTime,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: CCButton(
                        onPressed: state.invoiceInfo != null
                            ? () => dispatch(
                                SendLightningInvoiceActionCreator.onSendClick())
                            : null,
                        child: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text('Send'),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
