import 'dart:typed_data';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/reown_wallet/key_service/chain_key.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import '../bean/coin_balance_info.dart';
import 'messages.dart';
import 'method_channel_blockchain.dart';

abstract class BlockchainPlatform {
  static MethodChannelBlockchain _instance = MethodChannelBlockchain();

  static BlockchainPlatform get instance => _instance;

  static set instance(BlockchainPlatform instance) {
    try {
      instance._verifyProvidesDefaultImplementations();
    } on NoSuchMethodError catch (_) {
      throw AssertionError(
          'Platform interfaces must not be implemented with `implements`');
    }
    _instance = instance as MethodChannelBlockchain;
  }

  Future<void> loadCurrencyInfoList(List<CurrencyInfo> currencyList);

  Future<bool> initScanResponse(String uuid);

  Future<ScanResponse> addCurrencyList({
    required List<CurrencyInfo> currencyList,
  });

  Future<bool> validateAddress({
    required String blockchain,
    required String address,
    required String isTest,
  });

  Future<List<NetworkItem>> getFee(
      {required String blockchainId,
      required String symbol,
      required String currencyType,
      required String sumToSend,
      required String receiverAddress,
      required String isTest});

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
      String? contractAddress});

  ///调用原生弹窗发送APDU指令
  ///[cardId] 是否需要匹配卡ID
  ///[command] APDU指令
  ///[checkPwd] 是否需要密码
  ///[checkLock] 是否需要检查锁卡
  ///[ndefLink] 是否需要写入ndef
  //////[cardNo] 是否需要写入ndef
  Future<SendCommandResponse> scanCardWithCommand(
      {String? cardId,
      Uint8List? command,
      bool checkPwd = false,
      bool checkLock = false,
      String? ndefLink,
      String? ndefAar,
      String? cardNo,
      bool needRun = false,
      bool needSyscUid = false});

  Future<CardMessage> scanCardAndDerive(
      List<CurrencyInfo> currencyList, String ndefLink,
      {String? cardId, String? cardNo});

  Future<CardMessage> createWalletAndDerive(List<CurrencyInfo> currencyList);

  Future<void> clearLocalCurrency(String cardId, List<String> coinIds);

  Future<List<TransactionsHistory?>> loadTransactionHistoryList(
      TransactionHistoryRequest request);

  Future<bool> changeWallet(String cardId, List<CurrencyInfo> currencyList);

  Future<String> getBitcoinPublicKey();

  Future<String> getEthPublicKey();

  Future<String> signLightning(String hex, bool isBtc);

  Future<String> makeAddresses(String networkId, bool isBtc);

  Future<void> resetNfcReaderMode();

  Future<String> signText(String blockchainId, String hex, {int? chainId});

  Future<MsgSignature> signTransaction(String blockchainId, String hex,
      {int? chainId});

  Future<ChainKeyInfoResponse> createChainKeys(List<String> blockchains);

  Future<List<ChainKey>> getChainKeys(String cardId, List<String> blockchains);

  Future<void> postCatchedException(String error);

  Future<void> bindNetwork();

  Future<bool> isVpnActive();

  Future<bool> isDualSim();

  Future<String> signChallenge(String challenge);

  Future<String> generateKey();

  void _verifyProvidesDefaultImplementations() {}
}

class ChainKeyInfoResponse {
  late String cardId;
  late List<ChainKey> chainKeys;

  ChainKeyInfoResponse(this.cardId, this.chainKeys);
}
