import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import '../../bottom_sheet/i_bottom_sheet_service.dart';
import '../../utils/constants.dart';
import '../../utils/string_constants.dart';
import '../custom_button.dart';
import '../wc_connection_request/wc_connection_request_widget.dart';

class WCRequestWidget extends StatelessWidget {
  const WCRequestWidget({
    super.key,
    required this.child,
    this.verifyContext,
    this.proposalData,
    this.onAccept,
    this.onReject,
  });

  final Widget child;
  final VerifyContext? verifyContext;
  final ProposalData? proposalData;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VerifyContextWidget(
          verifyContext: verifyContext,
          iconUrl: proposalData?.proposer.metadata.icons.first,
        ),
        const SizedBox(height: StyleConstants.linear8),
        Flexible(
          child: SingleChildScrollView(
            child: child,
          ),
        ),
        const SizedBox(height: StyleConstants.linear16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              onTap: onReject ??
                      () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(WCBottomSheetResult.reject);
                    }
                  },
              type: CustomButtonType.invalid,
              child: const Text(
                StringConstants.reject,
                style: StyleConstants.buttonText,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              width: StyleConstants.linear16,
            ),
            CustomButton(
              onTap: onAccept ??
                      () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(WCBottomSheetResult.one);
                    }
                  },
              type: CustomButtonType.valid,
              child: const Text(
                StringConstants.approve,
                style: StyleConstants.buttonText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
