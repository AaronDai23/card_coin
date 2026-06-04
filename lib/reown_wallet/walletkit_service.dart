import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:card_coin/reown_wallet/i_walletkit_service.dart';
import 'package:card_coin/reown_wallet/widgets/wc_request_widget/wc_session_auth_request_widget.dart';
import 'package:eth_sig_util/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import 'bottom_sheet/i_bottom_sheet_service.dart';
import 'chain_services/evm_service.dart';
import 'deep_link_handler.dart';
import 'key_service/chain_key.dart';
import 'key_service/i_key_service.dart';
import 'models/chain_data.dart';
import 'utils/eth_utils.dart';
import 'utils/methods_utils.dart';
import 'widgets/wc_connection_request/wc_connection_request_widget.dart';
import 'widgets/wc_request_widget/wc_request_widget.dart';

class WalletKitService extends IWalletKitService {
  final _bottomSheetHandler = GetIt.I<IBottomSheetService>();

  ReownWalletKit? _walletKit;

  String _universalLink() {
    Uri link = Uri.parse('https://chipbase.vip/wallet');
    return link.toString();
  }

  Redirect _constructRedirect() {
    return Redirect(
      native: 'wcwallet://',
      universal: _universalLink(),
      // enable linkMode on Wallet so Dapps can use relay-less connection
      // universal: value must be set on cloud config as well
      linkMode: true,
    );
  }

  @override
  Future<void> create() async {
    _walletKit = ReownWalletKit(
        core: ReownCore(
            projectId: dotenv.env["REOWN_CORE_PROJECT_ID"]!,
            logLevel: LogLevel.all),
        metadata: PairingMetadata(
            name: 'ChipBase Wallet',
            description: 'NFC wallet',
            url: _universalLink(),
            icons: [
              'https://github.com/yuyongyao/chipbase/blob/main/assets/chipbase_icon.png'
            ],
            redirect: _constructRedirect()));

    print('[ReownWallet] create');

    _walletKit!.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
    _walletKit!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
    _walletKit!.core.relayClient.onRelayClientError
        .subscribe(_onRelayClientError);
    _walletKit!.core.relayClient.onRelayClientMessage
        .subscribe(_onRelayClientMessage);
    _walletKit!.core.relayClient.onRelayClientConnect
        .subscribe(_onRelayClientConnect);
    _walletKit!.core.relayClient.onRelayClientDisconnect
        .subscribe(_onRelayClientDisconnect);

    _walletKit!.onSessionProposal.subscribe(_onSessionProposal);
    _walletKit!.onSessionProposalError.subscribe(_onSessionProposalError);
    _walletKit!.onSessionConnect.subscribe(_onSessionConnect);
    _walletKit!.onSessionAuthRequest.subscribe(_onSessionAuthRequest);

    // Setup our accounts
    List<ChainKey> chainKeys = GetIt.I<IKeyService>().loadCardKeys();

    for (final chainKey in chainKeys) {
      for (final chainId in chainKey.chains) {
        // if (chainId.startsWith('kadena')) {
        //   final account = '$chainId:k**${chainKey.address}';
        //   debugPrint('[SampleWallet] registerAccount $account');
        //   _walletKit!.registerAccount(
        //     chainId: chainId,
        //     accountAddress: 'k**${chainKey.address}',
        //   );
        // } else {
        final account = '$chainId:${chainKey.address}';
        print('[SampleWallet] registerAccount $account');
        _walletKit!.registerAccount(
          chainId: chainId,
          accountAddress: chainKey.address,
        );
        // }
      }
    }
  }

  @override
  Future<void> init() async {
    await _walletKit!.init();
    await _emitEvent();
  }

  Future<void> _emitEvent() async {
    final isOnline = _walletKit!.core.connectivity.isOnline.value;
    if (!isOnline) {
      await Future.delayed(const Duration(milliseconds: 500));
      _emitEvent();
      return;
    }

    final sessions = _walletKit!.sessions.getAll();
    for (var session in sessions) {
      try {
        final events = NamespaceUtils.getNamespacesEventsForChain(
          chainId: 'eip155:1',
          namespaces: session.namespaces,
        );
        if (events.contains('accountsChanged')) {
          final chainKeys = GetIt.I<IKeyService>().getKeysForChain('eip155');
          _walletKit!.emitSessionEvent(
            topic: session.topic,
            chainId: 'eip155:1',
            event: SessionEventParams(
              name: 'accountsChanged',
              data: [chainKeys.first.address],
            ),
          );
        }
      } catch (_) {}
    }
  }

  @override
  FutureOr onDispose() {
    _walletKit!.core.pairing.onPairingInvalid.unsubscribe(_onPairingInvalid);
    _walletKit!.core.pairing.onPairingCreate.unsubscribe(_onPairingCreate);
    _walletKit!.core.relayClient.onRelayClientError.unsubscribe(
      _onRelayClientError,
    );
    _walletKit!.core.relayClient.onRelayClientMessage.unsubscribe(
      _onRelayClientMessage,
    );
    _walletKit!.core.relayClient.onRelayClientConnect
        .unsubscribe(_onRelayClientConnect);
    _walletKit!.core.relayClient.onRelayClientDisconnect
        .unsubscribe(_onRelayClientDisconnect);

    _walletKit!.onSessionProposal.unsubscribe(_onSessionProposal);
    _walletKit!.onSessionProposalError.unsubscribe(_onSessionProposalError);
    _walletKit!.onSessionConnect.unsubscribe(_onSessionConnect);
    _walletKit!.onSessionAuthRequest.unsubscribe(_onSessionAuthRequest);
  }

  @override
  ReownWalletKit get walletKit => _walletKit!;

  void _onSessionProposal(SessionProposalEvent? args) async {
    print('[ChipBaseWallet] _onSessionProposal ${jsonEncode(args?.params)}');
    if (args != null) {
      final proposer = args.params.proposer;
      final result = (await _bottomSheetHandler.queueBottomSheet(
            widget: WCRequestWidget(
              proposalData: args.params,
              verifyContext: args.verifyContext,
              child: WCConnectionRequestWidget(
                proposalData: args.params,
                verifyContext: args.verifyContext,
                requester: proposer,
              ),
            ),
          )) ??
          WCBottomSheetResult.reject;

      if (result != WCBottomSheetResult.reject) {
        try {
          _walletKit!.approveSession(
            id: args.id,
            namespaces: NamespaceUtils.regenerateNamespacesWithChains(
              args.params.generatedNamespaces!,
            ),
            sessionProperties: args.params.sessionProperties,
          );
          // MethodsUtils.handleRedirect(
          //   session.topic,
          //   session.session!.peer.metadata.redirect,
          //   '',
          //   true,
          // );
        } on ReownSignError catch (error) {
          MethodsUtils.handleRedirect(
            '',
            proposer.metadata.redirect,
            error.message,
          );
        }
      } else {
        final error = Errors.getSdkError(Errors.USER_REJECTED).toSignError();
        await _walletKit!.rejectSession(id: args.id, reason: error);
        await _walletKit!.core.pairing.disconnect(
          topic: args.params.pairingTopic,
        );
        MethodsUtils.handleRedirect(
          '',
          proposer.metadata.redirect,
          error.message,
        );
      }
    }
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) async {
    debugPrint('[SampleWallet] _onSessionProposalError $args');
    DeepLinkHandler.waiting.value = false;
    if (args != null) {
      String errorMessage = args.error.message;
      if (args.error.code == 5100) {
        errorMessage =
            errorMessage.replaceFirst('Requested:', '\n\nRequested:');
        errorMessage =
            errorMessage.replaceFirst('Supported:', '\n\nSupported:');
      }
      MethodsUtils.goBackModal(
        title: 'Error',
        message: errorMessage,
        success: false,
      );
    }
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      final session = jsonEncode(args.session.toJson());
      log('[ChipBase Wallet] _onSessionConnect $session');
      MethodsUtils.handleRedirect(
        args.session.topic,
        args.session.peer.metadata.redirect,
        '',
        true,
      );
    }
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    debugPrint('[SampleWallet] _onPairingInvalid $args');
  }

  void _onPairingCreate(PairingEvent? args) {
    debugPrint('[SampleWallet] _onPairingCreate $args');
  }

  void _onRelayClientError(ErrorEvent? args) {
    debugPrint('[SampleWallet] _onRelayClientError ${args?.error}');
  }

  List<String> get _loaderMethods => [
        MethodConstants.WC_SESSION_PROPOSE,
        MethodConstants.WC_SESSION_REQUEST,
        MethodConstants.WC_SESSION_AUTHENTICATE,
      ];

  void _onRelayClientMessage(MessageEvent? event) async {
    if (event != null) {
      final jsonObject = await EthUtils.decodeMessageEvent(event);
      debugPrint('[SampleWallet] _onRelayClientMessage $jsonObject');
      if (jsonObject is JsonRpcRequest) {
        DeepLinkHandler.waiting.value = _loaderMethods.contains(
          jsonObject.method,
        );
      }
    }
  }

  void _onRelayClientConnect(EventArgs? event) async {
    print('[SampleWallet] _onRelayClientConnect $event');
  }

  void _onRelayClientDisconnect(EventArgs? event) async {
    print('[SampleWallet] _onRelayClientDisconnect $event');
  }

  void _onSessionAuthRequest(SessionAuthRequest? args) async {
    if (args != null) {
      final SessionAuthPayload authPayload = args.authPayload;
      final jsonPyaload = jsonEncode(authPayload.toJson());
      print('[SampleWallet] _onSessionAuthRequest $jsonPyaload');
      final supportedChains = ChainsDataList.eip155Chains.map((e) => e.chainId);
      final supportedMethods = SupportedEVMMethods.values.map((e) => e.name);
      final newAuthPayload = AuthSignature.populateAuthPayload(
        authPayload: authPayload,
        chains: supportedChains.toList(),
        methods: supportedMethods.toList(),
      );
      final cacaoRequestPayload = CacaoRequestPayload.fromSessionAuthPayload(
        newAuthPayload,
      );
      final List<Map<String, dynamic>> formattedMessages = [];
      for (var chain in newAuthPayload.chains) {
        final chainKeys = GetIt.I<IKeyService>().getKeysForChain(chain);
        final iss = 'did:pkh:$chain:${chainKeys.first.address}';
        final message = _walletKit!.formatAuthMessage(
          iss: iss,
          cacaoPayload: cacaoRequestPayload,
        );
        formattedMessages.add({iss: message});
      }

      final WCBottomSheetResult rs =
          (await _bottomSheetHandler.queueBottomSheet(
                widget: WCSessionAuthRequestWidget(
                  child: WCConnectionRequestWidget(
                    sessionAuthPayload: newAuthPayload,
                    verifyContext: args.verifyContext,
                    requester: args.requester,
                  ),
                ),
              )) ??
              WCBottomSheetResult.reject;

      if (rs != WCBottomSheetResult.reject) {
        final chainKeys = GetIt.I<IKeyService>().getKeysForChain('eip155');
        final privateKey = '0x${chainKeys.first.privateKey}';
        final credentials = EthPrivateKey.fromHex(privateKey);
        //
        final messageToSign = formattedMessages.length;
        final count = (rs == WCBottomSheetResult.one) ? 1 : messageToSign;
        //
        final List<Cacao> cacaos = [];
        for (var i = 0; i < count; i++) {
          final iss = formattedMessages[i].keys.first;
          final message = formattedMessages[i].values.first;
          final signature = credentials.signPersonalMessageToUint8List(
            Uint8List.fromList(message.codeUnits),
          );
          final hexSignature = bytesToHex(signature, include0x: true);
          cacaos.add(
            AuthSignature.buildAuthObject(
              requestPayload: cacaoRequestPayload,
              signature: CacaoSignature(
                t: CacaoSignature.EIP191,
                s: hexSignature,
              ),
              iss: iss,
            ),
          );
        }
        //
        try {
          final session = await _walletKit!.approveSessionAuthenticate(
            id: args.id,
            auths: cacaos,
          );
          debugPrint('[$runtimeType] approveSessionAuthenticate $session');
          MethodsUtils.handleRedirect(
            session.topic,
            session.session?.peer.metadata.redirect,
            '',
            true,
          );
        } on ReownSignError catch (error) {
          MethodsUtils.handleRedirect(
            args.topic,
            args.requester.metadata.redirect,
            error.message,
          );
        }
      } else {
        final error = Errors.getSdkError(Errors.USER_REJECTED_AUTH);
        await _walletKit!.rejectSessionAuthenticate(
          id: args.id,
          reason: error.toSignError(),
        );
        MethodsUtils.handleRedirect(
          args.topic,
          args.requester.metadata.redirect,
          error.message,
        );
      }
    }
  }
}
