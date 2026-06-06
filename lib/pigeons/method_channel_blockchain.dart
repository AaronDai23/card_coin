import 'dart:io';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/reown_wallet/key_service/chain_key.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:chipcore_sdk/src/demo/utils/scan_util.dart' as chip_scan;
import 'package:chipcore_sdk/src/pigeon/messages.dart' as chip_msg;
import 'package:flutter/services.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import 'messages.dart';

const netWorkNames = ['Low', 'Normal', 'Priority'];

class SendCommandResponse {
  bool isSuccess;
  String? cardId;
  String? appletVersionCode;
  String? appletVersion;
  String? errorMessage;
  Uint8List? data;
  int? resetCount;
  bool? isActivated;

  SendCommandResponse(
      {required this.isSuccess,
      this.cardId,
      this.appletVersionCode,
      this.appletVersion,
      this.errorMessage,
      this.isActivated,
      this.resetCount,
      this.data});
}

/// 将 chipcore 的 CardMessage 转换为 card_coin 自身的 CardMessage
CardMessage _fromChipCard(chip_msg.CardMessage m) => CardMessage(
      uid: m.uid,
      isPasswordSet: m.isPasswordSet,
      publicKey: m.publicKey,
      currencyList: m.currencyList
          .map((e) => e == null
              ? null
              : CurrencyInfoMessage(
                  id: e.id,
                  icon: e.icon,
                  name: e.name,
                  networkId: e.networkId,
                  networkName: e.networkName,
                  networkIcon: e.networkIcon,
                  symbol: e.symbol,
                  contractAddress: e.contractAddress,
                  decimalCount: e.decimalCount,
                  amount: e.amount,
                  address: e.address,
                  publicKey: e.publicKey,
                  chainCode: e.chainCode,
                  isTest: e.isTest,
                ))
          .toList(),
    );

/// card_coin CurrencyInfoMessage → chip_msg.CurrencyInfoMessage
chip_msg.CurrencyInfoMessage _toChipCurrencyMsg(CurrencyInfoMessage e) =>
    chip_msg.CurrencyInfoMessage(
      id: e.id,
      icon: e.icon,
      name: e.name,
      networkId: e.networkId,
      networkName: e.networkName,
      networkIcon: e.networkIcon,
      symbol: e.symbol,
      contractAddress: e.contractAddress,
      decimalCount: e.decimalCount,
      amount: e.amount,
      address: e.address,
      publicKey: e.publicKey,
      chainCode: e.chainCode,
      isTest: e.isTest,
    );

/// chip_msg.TransactionsHistory → card_coin TransactionsHistory
TransactionsHistory _fromChipHistory(chip_msg.TransactionsHistory e) =>
    TransactionsHistory(
      time: e.time,
      direction: e.direction,
      status: e.status,
      type: e.type,
      value: e.value,
      decimals: e.decimals,
    );

class MethodChannelBlockchain extends BlockchainPlatform {
  final _chipApi = chip_msg.BlockchainApi();

  @override
  Future<bool> initScanResponse(String uuid) {
    return _chipApi.initScanResponse(uuid);
  }

  @override
  Future<List<NetworkItem>> getFee(
      {required String blockchainId,
      required String symbol,
      required String currencyType,
      required String sumToSend,
      required String receiverAddress,
      required String isTest}) async {
    List<chip_msg.FeeResponse> feeList = await _chipApi.getFee(
        chip_msg.FeeMessage(
            symbol: symbol,
            blockchain: blockchainId,
            currencyType: currencyType,
            receiverAddress: receiverAddress,
            sumToSend: sumToSend,
            isTest: isTest));
    return feeList
        .map((e) => NetworkItem(e.type.name, e.value,
            gasLimit: e.gasLimit, gasPrice: e.gasPrice))
        .toList();
  }

  @override
  Future<SendTransactionResponse> sendTransaction(
      {required String receiverAddress,
      required String sumToSend,
      required String type,
      String? symbol,
      required String fee,
      String? gasLimit,
      String? gasPrice,
      required String walletAddress,
      required String blockchainId,
      required String isTest,
      String? contractAddress}) async {
    try {
      final r = await _chipApi.sendTransaction(chip_msg.SendMessage(
          symbol: symbol,
          currencyType: type,
          blockchainId: blockchainId,
          walletAddress: walletAddress,
          fee: fee,
          receiverAddress: receiverAddress,
          sumToSend: sumToSend,
          gasLimit: gasLimit,
          gasPrice: gasPrice,
          isTest: isTest,
          contractAddress: contractAddress));
      return SendTransactionResponse(
          isSuccess: r.isSuccess, errorMsg: r.errorMsg);
    } on PlatformException catch (e) {
      return SendTransactionResponse(
          isSuccess: false, errorMsg: e.message ?? e.code);
    }
  }

  @override
  Future<bool> validateAddress(
      {required String blockchain,
      required String address,
      required String isTest}) {
    return _chipApi.validateAddress(chip_msg.ValidateAddressMessage(
        blockchain: blockchain, address: address, isTest: isTest));
  }

  @override
  Future<ScanResponse> addCurrencyList(
      {required List<CurrencyInfo> currencyList}) async {
    var list = currencyList
        .map((e) => chip_msg.CurrencyInfoMessage(
            id: e.currencyData.id,
            icon: e.currencyData.icon,
            name: e.currencyData.name,
            networkId: e.currencyData.networkId,
            networkName: e.networkName ?? '',
            networkIcon: e.imageUrl,
            symbol: e.currencyData.symbol,
            contractAddress: e.currencyData.contractAddress,
            decimalCount: e.currencyData.decimals,
            amount: e.balance ?? '0',
            address: e.address,
            isTest: e.isTest != null && e.isTest == true ? 1 : 0))
        .toList();
    try {
      final result = await _chipApi.addCurrencyList(list);
      return ScanResponse(true, data: result);
    } catch (error) {
      return ScanResponse(false, message: error.toString());
    }
  }

  @override
  Future<SendCommandResponse> scanCardWithCommand(
      {String? cardId,
      Uint8List? command,
      bool checkPwd = false,
      bool checkLock = false,
      String? ndefLink,
      String? cardNo,
      bool needRun = false,
      bool needSyscUid = false}) async {
    try {
      var response = await _chipApi.scanCardWithCommand(
          chip_msg.SendCommandMessage(
              cardId: cardId,
              command: command,
              checkPwd: checkPwd,
              checkLock: checkLock,
              ndefLink: ndefLink,
              cardNo: cardNo,
              needRun: needRun,
              needSyscUid: needSyscUid));
      _updateLog(response.cardId, Uint8List.fromList(command ?? []),
          Uint8List.fromList(response.data ?? []));
      return SendCommandResponse(
          isSuccess: true,
          cardId: response.cardId,
          appletVersionCode: response.appletVersionCode,
          appletVersion: response.appletVersion,
          isActivated: response.isActivated,
          resetCount: response.resetCount,
          data: response.data);
    } catch (error) {
      print("SendCommandResponse:${error.toString()}");

      return SendCommandResponse(
          isSuccess: false, errorMessage: error.toString());
    }
  }

  void _updateLog(String uid, Uint8List requestData, Uint8List response) {
    final data = <String, dynamic>{
      "apduRequest": StringUtils.uint8ToHex(requestData),
      "apduResponse": StringUtils.uint8ToHex(response),
      "uid": uid
    };
    HttpManager.getInstance()
        .post(NetworkAddress.apduLogUrl, null, data: data)
        .then((value) {
      print('upload log result:$value');
    });
  }

  @override
  Future<CardMessage> scanCardAndDerive(
      List<CurrencyInfo> currencyList, String ndefLink,
      {String? cardId, String? cardNo}) async {
    final chipList = currencyList
        .map((e) => chip_msg.CurrencyInfoMessage(
            id: e.currencyData.id,
            icon: e.currencyData.icon,
            name: e.currencyData.name,
            networkId: e.currencyData.networkId,
            networkName: e.networkName ?? '',
            networkIcon: e.imageUrl,
            symbol: e.currencyData.symbol,
            contractAddress: e.currencyData.contractAddress,
            decimalCount: e.currencyData.decimals,
            amount: e.balance ?? '0',
            address: e.address,
            isTest: e.isTest != null && e.isTest == true ? 1 : 0))
        .toList();
    final resp = await chip_scan.ScanUtil.scanCardAndDerive(
      chipList,
      walletName: ndefLink,
      cardId: cardId,
      cardNo: cardNo,
    );
    if (!resp.isSuccess) {
      final code = resp.errorCode ?? 'scan-failed';
      final msg = resp.message ?? code;
      throw PlatformException(code: code, message: msg, details: resp.message);
    }

    final scannedCardId = resp.data?.uid;
    if (cardId != null &&
        cardId.isNotEmpty &&
        scannedCardId != null &&
        scannedCardId.isNotEmpty &&
        scannedCardId.toUpperCase() != cardId.toUpperCase()) {
      throw PlatformException(
        code: 'uid-mismatch',
        message: 'WrongCardNumber',
      );
    }

    return _fromChipCard(resp.data!);
  }

  @override
  Future<CardMessage> createWalletAndDerive(
      List<CurrencyInfo> currencyList) async {
    final chipList = currencyList
        .map((e) => chip_msg.CurrencyInfoMessage(
            id: e.currencyData.id,
            icon: e.currencyData.icon,
            name: e.currencyData.name,
            networkId: e.currencyData.networkId,
            networkName: e.networkName ?? '',
            networkIcon: e.imageUrl,
            symbol: e.currencyData.symbol,
            contractAddress: e.currencyData.contractAddress,
            decimalCount: e.currencyData.decimals,
            amount: e.balance ?? '0',
            address: e.address,
            isTest: e.isTest != null && e.isTest == true ? 1 : 0))
        .toList();
    final resp = await chip_scan.ScanUtil.createWalletAndDerive(chipList);
    if (!resp.isSuccess) {
      final code = resp.errorCode ?? 'scan-failed';
      final msg = resp.message ?? code;
      throw PlatformException(code: code, message: msg, details: resp.message);
    }
    return _fromChipCard(resp.data!);
  }

  @override
  Future<void> loadCurrencyInfoList(List<CurrencyInfo> currencyList) {
    var list = currencyList
        .map((e) => chip_msg.CurrencyInfoMessage(
            id: e.currencyData.id,
            icon: e.currencyData.icon,
            name: e.currencyData.name,
            networkId: e.currencyData.networkId,
            networkName: e.networkName ?? '',
            networkIcon: e.imageUrl,
            symbol: e.currencyData.symbol,
            contractAddress: e.currencyData.contractAddress,
            decimalCount: e.currencyData.decimals,
            amount: e.balance ?? '0',
            address: e.address,
            isTest: e.isTest != null && e.isTest == true ? 1 : 0))
        .toList();
    return _chipApi.loadCurrencyInfoList(list);
  }

  @override
  Future<void> clearLocalCurrency(String cardId, List<String> coinIds) {
    return _chipApi.clearLocalCurrency(cardId, coinIds);
  }

  @override
  Future<List<TransactionsHistory?>> loadTransactionHistoryList(
      TransactionHistoryRequest request) async {
    final chipReq = chip_msg.TransactionHistoryRequest(
        address: request.address,
        page: request.page,
        type: request.type,
        currencyInfo: _toChipCurrencyMsg(request.currencyInfo));
    final result = await _chipApi.loadTransactionHistoryList(chipReq);
    return result.map((e) => _fromChipHistory(e)).toList();
  }

  @override
  Future<bool> changeWallet(String cardId, List<CurrencyInfo> currencyList) {
    var list = currencyList
        .map((e) => chip_msg.CurrencyInfoMessage(
              id: e.currencyData.id,
              icon: e.currencyData.icon,
              name: e.currencyData.name,
              networkId: e.currencyData.networkId,
              networkName: e.networkName,
              networkIcon: e.imageUrl,
              symbol: e.currencyData.symbol,
              contractAddress: e.currencyData.contractAddress,
              decimalCount: e.currencyData.decimals,
              amount: e.balance ?? '0',
              address: e.address,
              isTest: e.isTest != null && e.isTest == true ? 1 : 0,
              // publicKey: ...
            ))
        .toList();
    return _chipApi.changeWallet(cardId, list);
  }

  @override
  Future<void> postCatchedException(String error) {
    return _chipApi.postCatchedException(error);
  }

  @override
  Future<String> getBitcoinPublicKey() {
    return _chipApi.getBitcoinPublicKey();
  }

  @override
  Future<String> getEthPublicKey() {
    return _chipApi.getEthPublicKey();
  }

  @override
  Future<String> signLightning(String hex, bool isBtc) async {
    try {
      return await _chipApi.signLightning(hex, isBtc);
    } on PlatformException catch (e) {
      // pin-cancelled 或其他原生错误，抛出带 code 的 PlatformException 供调用方区分
      throw PlatformException(
          code: e.code, message: e.message, details: e.details);
    }
  }

  @override
  Future<String> makeAddresses(String networkId, bool isBtc) {
    return _chipApi.makeAddresses(networkId, isBtc);
  }

  @override
  Future<void> resetNfcReaderMode() async {
    if (Platform.isAndroid) {
      return _chipApi.resetNfcReaderMode();
    } else {
      return;
    }
  }

  @override
  Future<String> signText(String blockchainId, String hex, {int? chainId}) {
    return _chipApi.signText(blockchainId, hex, chainId);
  }

  @override
  Future<ChainKeyInfoResponse> createChainKeys(List<String> blockchains) async {
    var chainKeysInfo = await _chipApi.createChainKeys(blockchains);
    List<ChainKey> list = [];
    for (int i = 0; i < chainKeysInfo.chainKeys.length; i++) {
      final chainKey = chainKeysInfo.chainKeys[i];
      final chain = ChainKey(
          blockchainId: chainKey!.blockchainId,
          chains: ['eip155:${chainKey.chainId}'],
          privateKey: chainKey.privateKey,
          publicKey: chainKey.publicKey,
          address: chainKey.address);
      list.add(chain);
    }
    return ChainKeyInfoResponse(chainKeysInfo.cardId, list);
  }

  @override
  Future<List<ChainKey>> getChainKeys(
      String cardId, List<String> blockchains) async {
    var chainKeys = await _chipApi.getChainKeys(cardId, blockchains);
    List<ChainKey> list = [];
    for (int i = 0; i < chainKeys.length; i++) {
      final chainKey = chainKeys[i];
      final chain = ChainKey(
          blockchainId: chainKey.blockchainId,
          chains: ['eip155:${chainKey.chainId}'],
          privateKey: chainKey.privateKey,
          publicKey: chainKey.publicKey,
          address: chainKey.address);
      list.add(chain);
    }
    return list;
  }

  @override
  Future<MsgSignature> signTransaction(String blockchainId, String hex,
      {int? chainId}) async {
    var signatureMessage =
        await _chipApi.signTransaction(blockchainId, hex, chainId);
    var r = signatureMessage.substring(0, 64);
    var s = signatureMessage.substring(64, 128);
    var v = signatureMessage.substring(128);
    return MsgSignature(BigInt.parse(r, radix: 16), BigInt.parse(s, radix: 16),
        int.parse(v, radix: 16));
  }

  @override
  Future<void> bindNetwork() {
    return _chipApi.bindNetwork();
  }

  @override
  Future<bool> isVpnActive() {
    return _chipApi.isVpnActive();
  }

  @override
  Future<bool> isDualSim() {
    return _chipApi.isDualSim();
  }

  @override
  Future<String> signChallenge(String challenge) {
    return _chipApi.signChallenge(challenge);
  }

  @override
  Future<String> generateKey() {
    return _chipApi.generateKey();
  }
}
