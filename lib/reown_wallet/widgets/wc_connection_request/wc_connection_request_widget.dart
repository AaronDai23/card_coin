import 'package:card_coin/custom_widget/load_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import '../../i_walletkit_service.dart';
import '../../key_service/i_key_service.dart';
import '../../utils/constants.dart';
import '../../utils/namespace_model_builder.dart';
import '../../utils/string_constants.dart';
import '../wc_connection_widget/wc_connection_model.dart';
import '../wc_connection_widget/wc_connection_widget.dart';

class WCConnectionRequestWidget extends StatelessWidget {
  const WCConnectionRequestWidget({
    Key? key,
    // this.authPayloadParams,
    this.sessionAuthPayload,
    this.proposalData,
    this.requester,
    this.verifyContext,
  }) : super(key: key);

  // final AuthPayloadParams? authPayloadParams;
  final SessionAuthPayload? sessionAuthPayload;
  final ProposalData? proposalData;
  final ConnectionMetadata? requester;
  final VerifyContext? verifyContext;

  @override
  Widget build(BuildContext context) {
    if (requester == null) {
      return const Text('ERROR');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(StyleConstants.linear8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: StyleConstants.linear8),
          Text(
            'This site ${StringConstants.wouldLikeToConnect} ChipBase',
            style: StyleConstants.subtitleText.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: StyleConstants.linear8),
          (sessionAuthPayload != null)
              ? _buildSessionAuthRequestView()
              : _buildSessionProposalView(context),
        ],
      ),
    );
  }

  Widget _buildSessionAuthRequestView() {
    final walletKit = GetIt.I<IWalletKitService>().walletKit;
    //
    final cacaoPayload = CacaoRequestPayload.fromSessionAuthPayload(
      sessionAuthPayload!,
    );
    //
    final List<WCConnectionModel> messagesModels = [];
    for (var chain in sessionAuthPayload!.chains) {
      final chainKeys = GetIt.I<IKeyService>().getKeysForChain(chain);
      final iss = 'did:pkh:$chain:${chainKeys.first.address}';
      final message = walletKit.formatAuthMessage(
        iss: iss,
        cacaoPayload: cacaoPayload,
      );
      messagesModels.add(
        WCConnectionModel(
          title: 'Message ${messagesModels.length + 1}',
          elements: [
            message,
          ],
        ),
      );
    }
    //
    return WCConnectionWidget(
      title: '${messagesModels.length} Messages',
      info: messagesModels,
    );
  }

  Widget _buildSessionProposalView(BuildContext context) {
    return ConnectionWidgetBuilder.buildFromRequiredNamespaces2(
      context,
      proposalData!.generatedNamespaces!,
    );
  }
}

class VerifyContextWidget extends StatelessWidget {
  const VerifyContextWidget({
    super.key,
    required this.verifyContext,
    this.iconUrl,
  });

  final VerifyContext? verifyContext;
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    if (verifyContext == null) {
      return const SizedBox.shrink();
    }

    if (verifyContext!.validation.scam) {
      return VerifyBanner(
        color: StyleConstants.errorColor,
        origin: verifyContext!.origin,
        title: 'Security risk',
        text: 'This domain is flagged as unsafe by multiple security providers.'
            ' Leave immediately to protect your assets.',
      );
    }
    if (verifyContext!.validation.invalid) {
      return VerifyBanner(
        color: StyleConstants.errorColor,
        origin: verifyContext!.origin,
        title: 'Domain mismatch',
        text:
            'This website has a domain that does not match the sender of this request.'
            ' Approving may lead to loss of funds.',
      );
    }
    if (verifyContext!.validation.valid) {
      return VerifyHeader(
        iconUrl: iconUrl,
        title: verifyContext!.origin,
      );
    }
    return VerifyBanner(
      color: Colors.orange,
      origin: verifyContext!.origin,
      iconUrl: iconUrl,
      title: 'Cannot verify',
      text: 'This domain cannot be verified. '
          'Check the request carefully before approving.',
    );
  }
}

class VerifyHeader extends StatelessWidget {
  const VerifyHeader({
    super.key,
    this.iconUrl,
    required this.title,
  });

  final String? iconUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  iconUrl!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const LoadAssetImage('none');
                  },
                ),
              )
            : const Icon(
                Icons.shield_outlined,
                color: Colors.black,
              ),
        const SizedBox(width: StyleConstants.linear8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class VerifyBanner extends StatelessWidget {
  const VerifyBanner({
    super.key,
    required this.origin,
    required this.title,
    required this.text,
    required this.color,
    this.iconUrl,
  });

  final String origin, title, text;
  final Color color;
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  iconUrl!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
              ),
            const SizedBox(width: StyleConstants.linear8),
            Text(
              origin,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox.square(dimension: 8.0),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              VerifyHeader(
                title: title,
              ),
              const SizedBox(height: 4.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
