import 'dart:async';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:chipcore_sdk/src/pigeon/messages.dart' as chip_msg;
import 'messages.dart';

class BlockchainClient implements FlutterClientApi {
  static BlockchainClient? _instance;
  final StreamController<List<CurrencyInfoResponse>> _currentController =
      StreamController.broadcast();

  BlockchainClient._internal() {
    print("flutter-updateCurrencyInfo-_internal1");
    FlutterClientApi.setup(this);
    // 同时注册 chipcore 的回调 channel
    chip_msg.FlutterClientApi.setUp(_ChipFlutterClientApiAdapter(this));
  }

  factory BlockchainClient() {
    print("flutter-updateCurrencyInfo-_internal0");
    _instance ??= BlockchainClient._internal();
    return _instance!;
  }

  Stream<List<CurrencyInfoResponse>> get onUpdateBlockchain {
    return _currentController.stream;
  }

  @override
  bool updateCurrencyInfo(List<BalanceResponse?> currencyInfoList) {
    var list = currencyInfoList.map((e) {
      final response = e!;
      CurrencyInfoMessage currencyInfoMessage = response.data;
      String amountStr = currencyInfoMessage.amount ?? "";
      print(
          'flutter-updateCurrency-network:${currencyInfoMessage.networkId},address:${currencyInfoMessage.address},'
          'balance:$amountStr, oldbans:${currencyInfoMessage.amount},symbol:${currencyInfoMessage.symbol},id:${currencyInfoMessage.id},isTest:${currencyInfoMessage.isTest}');

      return CurrencyInfoResponse(
          CurrencyInfo(
              balance: amountStr,
              imageUrl: currencyInfoMessage.networkIcon,
              address: currencyInfoMessage.address,
              isTest: currencyInfoMessage.isTest != null &&
                      currencyInfoMessage.isTest == 1
                  ? true
                  : false,
              currencyData: CurrencyData(
                  currencyInfoMessage.id,
                  currencyInfoMessage.icon,
                  currencyInfoMessage.name,
                  currencyInfoMessage.symbol,
                  currencyInfoMessage.networkId,
                  decimals: currencyInfoMessage.decimalCount,
                  address: currencyInfoMessage.address,
                  contractAddress: currencyInfoMessage.contractAddress,
                  publicKey:
                      HexUtils.uint8ListToHex(currencyInfoMessage.publicKey),
                  chainCode:
                      HexUtils.uint8ListToHex(currencyInfoMessage.chainCode))),
          code: e.errorMessage?.code,
          errorMessage: e.errorMessage?.customMessage);
    }).toList();
    print(
        'flutter-updateCurrencyInfo:${list.toString()}，_currentController：$_currentController');
    _currentController.add(list);
    return true;
  }
}

/// 将 chipcore_sdk FlutterClientApi 的回调转换后转发给 BlockchainClient
class _ChipFlutterClientApiAdapter implements chip_msg.FlutterClientApi {
  final BlockchainClient _client;
  _ChipFlutterClientApiAdapter(this._client);

  @override
  bool updateCurrencyInfo(List<chip_msg.BalanceResponse> currencyInfoList) {
    final converted = currencyInfoList.map((e) {
      final d = e.data;
      return BalanceResponse(
        data: CurrencyInfoMessage(
          id: d.id,
          icon: d.icon,
          name: d.name,
          networkId: d.networkId,
          networkName: d.networkName,
          networkIcon: d.networkIcon,
          symbol: d.symbol,
          contractAddress: d.contractAddress,
          decimalCount: d.decimalCount,
          amount: d.amount,
          address: d.address,
          publicKey: d.publicKey,
          chainCode: d.chainCode,
          isTest: d.isTest,
        ),
        errorMessage: e.errorMessage != null
            ? BlockchainErrorMessage(
                code: e.errorMessage!.code,
                customMessage: e.errorMessage!.customMessage)
            : null,
      );
    }).toList();
    return _client.updateCurrencyInfo(converted);
  }
}
