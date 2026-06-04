import 'dart:convert';
import 'dart:typed_data';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/reown_wallet/extensions/web3_client_ext.dart';
import 'package:card_coin/reown_wallet/utils/constants.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import '../i_walletkit_service.dart';
import '../key_service/i_key_service.dart';
import '../models/chain_metadata.dart';
import '../utils/blockchain_utils.dart';
import '../utils/eth_utils.dart';
import '../utils/methods_utils.dart';
import '../widgets/wc_connection_widget/wc_connection_model.dart';

enum SupportedEVMMethods {
  ethSign,
  ethSignTransaction,
  ethSignTypedData,
  ethSignTypedDataV4,
  switchChain,
  personalSign,
  ethSendTransaction;

  String get name {
    switch (this) {
      case ethSign:
        return 'eth_sign';
      case ethSignTransaction:
        return 'eth_signTransaction';
      case ethSignTypedData:
        return 'eth_signTypedData';
      case ethSignTypedDataV4:
        return 'eth_signTypedData_v4';
      case switchChain:
        return 'wallet_switchEthereumChain';
      case personalSign:
        return 'personal_sign';
      case ethSendTransaction:
        return 'eth_sendTransaction';
    }
  }
}

class EVMService {
  final _walletKit = GetIt.I<IWalletKitService>().walletKit;

  final ChainMetadata chainSupported;
  late final Web3Client ethClient;

  Map<String, dynamic Function(String, dynamic)> get sessionRequestHandlers => {
        SupportedEVMMethods.ethSign.name: ethSign,
        SupportedEVMMethods.ethSignTransaction.name: ethSignTransaction,
        SupportedEVMMethods.ethSignTypedData.name: ethSignTypedData,
        SupportedEVMMethods.ethSignTypedDataV4.name: ethSignTypedDataV4,
        SupportedEVMMethods.switchChain.name: switchChain,
        // 'wallet_addEthereumChain': addChain,
      };

  Map<String, dynamic Function(String, dynamic)> get methodRequestHandlers => {
        SupportedEVMMethods.personalSign.name: personalSign,
        SupportedEVMMethods.ethSendTransaction.name: ethSendTransaction,
      };

  EVMService({required this.chainSupported}) {
    ethClient = Web3Client(chainSupported.rpc.first, http.Client());

    for (final event in EventsConstants.allEvents) {
      _walletKit.registerEventEmitter(
        chainId: chainSupported.chainId,
        event: event,
      );
    }

    for (var handler in methodRequestHandlers.entries) {
      _walletKit.registerRequestHandler(
        chainId: chainSupported.chainId,
        method: handler.key,
        handler: handler.value,
      );
    }
    for (var handler in sessionRequestHandlers.entries) {
      _walletKit.registerRequestHandler(
        chainId: chainSupported.chainId,
        method: handler.key,
        handler: handler.value,
      );
    }

    _walletKit.onSessionRequest.subscribe(_onSessionRequest);
  }

  Uint8List personalHexMessageToUint8List(Uint8List payload) {
    final prefix = '\u0019Ethereum Signed Message:\n${payload.length}';
    final prefixBytes = ascii.encode(prefix);

    final message = prefixBytes + payload;
    print(message);
    final concat = uint8ListFromList(prefixBytes + payload);

    return keccak256(concat);
  }

  // personal_sign is handled using onSessionRequest event for demo purposes
  Future<void> personalSign(String topic, dynamic parameters) async {
    debugPrint('[SampleWallet] personalSign request: $parameters');
    final SessionRequest pRequest = _walletKit.pendingRequests.getAll().last;
    final address = EthUtils.getAddressFromSessionRequest(pRequest);
    final data = EthUtils.getDataFromSessionRequest(pRequest);
    var message = EthUtils.getUtf8Message(data.toString());

    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    if (await MethodsUtils.requestLoginApproval(
      '',
      data: message,
      method: pRequest.method,
      chainId: pRequest.chainId,
      address: address,
      transportType: pRequest.transportType.name,
      verifyContext: pRequest.verifyContext,
    )) {
      try {
        // Load the private key
        final keys = GetIt.I<IKeyService>().getKeysForChain(
          chainSupported.chainId,
        );
        String signedTx;
        String addressHex;
        if (Constants.isCard) {
          // var chainKey = keys.firstWhere((element) => element.chains.first == pRequest.chainId);
          var chainKey = keys[0];

          Uint8List payload = utf8.encode(message);

          // var personalMessage = personalMessageToUint8List(utf8.encode(message));
          var personalHexMessage = personalHexMessageToUint8List(payload);
          var personalHexMessageString = utf8.decode(personalHexMessage);
          final signature = await BlockchainPlatform.instance
              .signText(chainKey.blockchainId, personalHexMessageString);
          int signatureLength = signature.length;
          print('signatureLength:$signatureLength');
          List<int> bytes = utf8.encode(signature);
          signedTx = bytesToHex(bytes, include0x: true);
          addressHex = chainKey.address;
        } else {
          final pk = '0x${keys[0].privateKey}';
          final credentials = EthPrivateKey.fromHex(pk);
          Uint8List payload = utf8.encode(message);
          final signature = credentials.signPersonalMessageToUint8List(
            payload,
          );

          int signatureLength = signature.length;
          print('signatureLength:$signatureLength');

          signedTx = bytesToHex(signature, include0x: true);
          addressHex = credentials.address.hex;
        }

        bool isValid = isValidSignature(signedTx, message, addressHex);
        print('isValid:$isValid');

        response = response.copyWith(result: signedTx);
      } catch (e) {
        debugPrint('[SampleWallet] personalSign error $e');
        // TODO document errors
        final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
        response = response.copyWith(
          error: JsonRpcError(
            code: error.code,
            message: error.message,
          ),
        );
      }
    } else {
      final error = Errors.getSdkError(Errors.USER_REJECTED);
      response = response.copyWith(
        error: JsonRpcError(
          code: error.code,
          message: error.message,
        ),
      );
    }

    _handleResponseForTopic(topic, response);
  }

  Future<void> ethSign(String topic, dynamic parameters) async {
    debugPrint('[SampleWallet] ethSign request: $parameters');
    final pRequest = _walletKit.pendingRequests.getAll().last;
    final data = EthUtils.getDataFromSessionRequest(pRequest);
    final message = EthUtils.getUtf8Message(data.toString());
    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    if (await MethodsUtils.requestApproval(
      message,
      transportType: pRequest.transportType.name,
      verifyContext: pRequest.verifyContext,
    )) {
      try {
        // Load the private key
        // final keys = GetIt.I<IKeyService>().getKeysForChain(
        //   chainSupported.chainId,
        // );
        //
        // final pk = '0x${keys[0].privateKey}';
        // final credentials = EthPrivateKey.fromHex(pk);
        // final signature = credentials.signPersonalMessageToUint8List(
        //   utf8.encode(message),
        // );

        var blockchainId =
            BlockchainUtils.getChainMetadata(pRequest.chainId).blockchainId;
        final signature = await BlockchainPlatform.instance.signText(
            blockchainId, utf8.decode(keccak256(utf8.encode(message))));

        final signedTx = bytesToHex(utf8.encode(signature), include0x: true);
        // String addressHex = credentials.address.hex;
        // isValidSignature(signedTx, message, credentials.address.hex);

        response = response.copyWith(result: signedTx);
      } catch (e) {
        debugPrint('[SampleWallet] ethSign error $e');
        final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
        response = response.copyWith(
          error: JsonRpcError(
            code: error.code,
            message: error.message,
          ),
        );
      }
    } else {
      final error = Errors.getSdkError(Errors.USER_REJECTED).toSignError();
      response = response.copyWith(
        error: JsonRpcError(
          code: error.code,
          message: error.message,
        ),
      );
    }

    _handleResponseForTopic(topic, response);
  }

  Future<void> ethSignTypedData(String topic, dynamic parameters) async {
    debugPrint('[SampleWallet] ethSignTypedData request: $parameters');
    final pRequest = _walletKit.pendingRequests.getAll().last;
    final data = EthUtils.getDataFromSessionRequest(pRequest);
    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    if (await MethodsUtils.requestApproval(
      data,
      transportType: pRequest.transportType.name,
      verifyContext: pRequest.verifyContext,
    )) {
      try {
        var blockchainId =
            BlockchainUtils.getChainMetadata(pRequest.chainId).blockchainId;
        var hexMessage = TypedDataUtil.hashMessage(
            jsonData: data, version: TypedDataVersion.V4);
        String message = utf8.decode(hexMessage);
        final signature =
            await BlockchainPlatform.instance.signText(blockchainId, message);
        // String signedTx = bytesToHex(signature, include0x: true);
        String signedTx = bytesToHex(utf8.encode(signature), include0x: true);
        response = response.copyWith(result: signedTx);
      } catch (e) {
        debugPrint('[SampleWallet] ethSignTypedData error $e');
        final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
        response = response.copyWith(
          error: JsonRpcError(
            code: error.code,
            message: error.message,
          ),
        );
      }
    } else {
      final error = Errors.getSdkError(Errors.USER_REJECTED).toSignError();
      response = response.copyWith(
        error: JsonRpcError(
          code: error.code,
          message: error.message,
        ),
      );
    }

    _handleResponseForTopic(topic, response);
  }

  Future<void> ethSignTypedDataV4(String topic, dynamic parameters) async {
    debugPrint('[SampleWallet] ethSignTypedDataV4 request: $parameters');
    final pRequest = _walletKit.pendingRequests.getAll().last;
    final data = EthUtils.getDataFromSessionRequest(pRequest);
    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    if (await MethodsUtils.requestApproval(
      data,
      transportType: pRequest.transportType.name,
      verifyContext: pRequest.verifyContext,
    )) {
      try {
        var blockchainId =
            BlockchainUtils.getChainMetadata(pRequest.chainId).blockchainId;
        var hexMessage = TypedDataUtil.hashMessage(
            jsonData: data, version: TypedDataVersion.V4);
        String message = utf8.decode(hexMessage);
        final signature =
            await BlockchainPlatform.instance.signText(blockchainId, message);
        String signedTx = bytesToHex(utf8.encode(signature), include0x: true);
        response = response.copyWith(result: signedTx);
      } catch (e) {
        debugPrint('[SampleWallet] ethSignTypedDataV4 error $e');
        final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
        response = response.copyWith(
          error: JsonRpcError(
            code: error.code,
            message: error.message,
          ),
        );
      }
    } else {
      response = response.copyWith(
        error: const JsonRpcError(code: 5002, message: 'User rejected method'),
      );
    }

    _handleResponseForTopic(topic, response);
  }

  Future<void> ethSignTransaction(String topic, dynamic parameters) async {
    print('[SampleWallet] ethSignTransaction request: $parameters');
    final SessionRequest pRequest = _walletKit.pendingRequests.getAll().last;

    final data = EthUtils.getTransactionFromSessionRequest(pRequest);
    if (data == null) return;

    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    final transaction = await _approveTransaction(
      data,
      method: pRequest.method,
      chainId: pRequest.chainId,
      transportType: pRequest.transportType.name,
      verifyContext: pRequest.verifyContext,
    );
    if (transaction is Transaction) {
      try {
        final chainId = int.parse(chainSupported.chainId.split(':').last);

        var blockchainId =
            BlockchainUtils.getChainMetadata(chainSupported.chainId)
                .blockchainId;
        var signature = await ethClient
            .signTransactionByCard(blockchainId, transaction, chainId: chainId);
        // Sign the transaction
        final signedTx = bytesToHex(signature, include0x: true);
        response = response.copyWith(result: signedTx);
      } on RPCError catch (e) {
        debugPrint('[SampleWallet] ethSignTransaction error $e');
        response = response.copyWith(
          error: JsonRpcError(
            code: e.errorCode,
            message: e.message,
          ),
        );
      } catch (e) {
        debugPrint('[SampleWallet] ethSignTransaction error $e');
        final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
        response = response.copyWith(
          error: JsonRpcError(
            code: error.code,
            message: error.message,
          ),
        );
      }
    } else {
      response = response.copyWith(error: transaction as JsonRpcError);
    }

    _handleResponseForTopic(topic, response);
  }

  Future<void> ethSendTransaction(String topic, dynamic parameters) async {
    debugPrint('[SampleWallet] ethSendTransaction request: $parameters');
    final SessionRequest pRequest = _walletKit.pendingRequests.getAll().last;

    final data = EthUtils.getTransactionFromSessionRequest(pRequest);
    if (data == null) return;

    var response = JsonRpcResponse(
      id: pRequest.id,
      jsonrpc: '2.0',
    );

    final transaction = await _approveTransaction(
      data,
      method: pRequest.method,
      chainId: pRequest.chainId,
      transportType: pRequest.transportType.name,
      verifyContext: pRequest.verifyContext,
    );
    if (transaction is Transaction) {
      try {
        // Load the private key
        // final keys = GetIt.I<IKeyService>().getKeysForChain(
        //   chainSupported.chainId,
        // );

        final chainId = int.parse(chainSupported.chainId.split(':').last);

        var blockchainId =
            BlockchainUtils.getChainMetadata(chainSupported.chainId)
                .blockchainId;

        var signedTx = await ethClient
            .sendTransactionByCard(blockchainId, transaction, chainId: chainId);

        response = response.copyWith(result: signedTx);
      } on RPCError catch (e) {
        debugPrint('[SampleWallet] ethSendTransaction error $e');
        response = response.copyWith(
          error: JsonRpcError(
            code: e.errorCode,
            message: e.message,
          ),
        );
      } catch (e) {
        debugPrint('[SampleWallet] ethSendTransaction error $e');
        final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
        response = response.copyWith(
          error: JsonRpcError(
            code: error.code,
            message: error.message,
          ),
        );
      }
    } else {
      response = response.copyWith(error: transaction as JsonRpcError);
    }

    _handleResponseForTopic(topic, response);
  }

  Future<void> switchChain(String topic, dynamic parameters) async {
    debugPrint('[SampleWallet] switchChain request: $topic $parameters');
    final pRequest = _walletKit.pendingRequests.getAll().last;
    var response = JsonRpcResponse(id: pRequest.id, jsonrpc: '2.0');
    try {
      final params = (parameters as List).first as Map<String, dynamic>;
      final hexChainId = params['chainId'].toString().replaceFirst('0x', '');
      final chainId = int.parse(hexChainId, radix: 16);
      await _walletKit.emitSessionEvent(
        topic: topic,
        chainId: 'eip155:$chainId',
        event: SessionEventParams(
          name: 'chainChanged',
          data: chainId,
        ),
      );
      response = response.copyWith(result: true);
    } on ReownSignError catch (e) {
      debugPrint('[SampleWallet] switchChain error $e');
      response = response.copyWith(
        error: JsonRpcError(
          code: e.code,
          message: e.message,
        ),
      );
    } catch (e) {
      debugPrint('[SampleWallet] switchChain error $e');
      final error = Errors.getSdkError(Errors.MALFORMED_REQUEST_PARAMS);
      response = response.copyWith(
        error: JsonRpcError(
          code: error.code,
          message: error.message,
        ),
      );
    }

    _handleResponseForTopic(topic, response);
  }

  void _handleResponseForTopic(String topic, JsonRpcResponse response) async {
    final session = _walletKit.sessions.get(topic);

    try {
      await _walletKit.respondSessionRequest(
        topic: topic,
        response: response,
      );
      MethodsUtils.handleRedirect(
        topic,
        session!.peer.metadata.redirect,
        response.error?.message,
        response.error == null,
      );
    } on ReownSignError catch (error) {
      MethodsUtils.handleRedirect(
        topic,
        session!.peer.metadata.redirect,
        error.message,
      );
    }
  }

  // Future<void> addChain(String topic, dynamic parameters) async {
  //   final pRequest = _walletKit.pendingRequests.getAll().last;
  //   await _walletKit.respondSessionRequest(
  //     topic: topic,
  //     response: JsonRpcResponse(
  //       id: pRequest.id,
  //       jsonrpc: '2.0',
  //       result: true,
  //     ),
  //   );
  //   CommonMethods.goBackToDapp(topic, true);
  // }

  Future<dynamic> _approveTransaction(
    Map<String, dynamic> tJson, {
    String? title,
    String? method,
    String? chainId,
    VerifyContext? verifyContext,
    required String transportType,
  }) async {
    Transaction transaction = tJson.toTransaction();

    final gasPrice = await ethClient.getGasPrice();
    try {
      final gasLimit = await ethClient.estimateGas(
        sender: transaction.from,
        to: transaction.to,
        value: transaction.value,
        data: transaction.data,
        gasPrice: gasPrice,
      );

      transaction = transaction.copyWith(
        gasPrice: gasPrice,
        maxGas: gasLimit.toInt(),
      );
    } on RPCError catch (e) {
      return JsonRpcError(code: e.errorCode, message: e.message);
    }

    final gweiGasPrice = (transaction.gasPrice?.getInWei ?? BigInt.zero) /
        BigInt.from(1000000000);

    const encoder = JsonEncoder.withIndent('  ');
    final trx = encoder.convert(tJson);

    if (await MethodsUtils.requestApproval(
      trx,
      title: title,
      method: method,
      chainId: chainId,
      transportType: transportType,
      verifyContext: verifyContext,
      extraModels: [
        WCConnectionModel(
          title: 'Gas price',
          elements: ['${gweiGasPrice.toStringAsFixed(2)} GWEI'],
        ),
      ],
    )) {
      return transaction;
    }

    return const JsonRpcError(code: 5002, message: 'User rejected method');
  }

  void _onSessionRequest(SessionRequestEvent? args) async {
    if (args != null && args.chainId == chainSupported.chainId) {
      debugPrint('[SampleWallet] _onSessionRequest ${args.toString()}');
      final handler = sessionRequestHandlers[args.method];
      if (handler != null) {
        await handler(args.topic, args.params);
      }
    }
  }

  bool isValidSignature(
    String hexSignature,
    String message,
    String hexAddress,
  ) {
    try {
      print(
          '[SampleWallet] isValidSignature: $hexSignature, $message, $hexAddress');
      final recoveredAddress = EthSigUtil.recoverPersonalSignature(
        signature: hexSignature,
        message: utf8.encode(message),
      );
      print('[SampleWallet] recoveredAddress: $recoveredAddress');

      // final recoveredAddress2 = EthSigUtil.recoverSignature(
      //   signature: hexSignature,
      //   message: utf8.encode(message),
      // );
      // debugPrint('[SampleWallet] recoveredAddress2: $recoveredAddress2');

      final isValid = recoveredAddress == hexAddress.toLowerCase();
      return isValid;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getBalance({required String address}) async {
    final uri = Uri.parse('https://rpc.walletconnect.org/v1');
    final queryParams = {
      'projectId': _walletKit.core.projectId,
      'chainId': chainSupported.chainId
    };
    final response = await http.post(
      uri.replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': 1,
        'jsonrpc': '2.0',
        'method': 'eth_getBalance',
        'params': [address, 'latest'],
      }),
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      try {
        final result = _parseRpcResultAs<String>(response.body);
        final amount = EtherAmount.fromBigInt(
          EtherUnit.wei,
          hexToInt(result),
        );
        return amount.getValueInUnit(EtherUnit.ether);
      } catch (e) {
        throw Exception('Failed to load balance. $e');
      }
    }
    try {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>;
      final reasons = errorData['reasons'] as List<dynamic>;
      final reason = reasons.isNotEmpty
          ? reasons.first['description'] ?? ''
          : response.body;
      throw Exception(reason);
    } catch (e) {
      rethrow;
    }
  }

  T _parseRpcResultAs<T>(String body) {
    try {
      final result = Map<String, dynamic>.from({...jsonDecode(body), 'id': 1});
      final jsonResponse = JsonRpcResponse.fromJson(result);
      if (jsonResponse.result != null) {
        return jsonResponse.result;
      } else {
        throw jsonResponse.error ?? 'Error parsing result';
      }
    } catch (e) {
      rethrow;
    }
  }
}
