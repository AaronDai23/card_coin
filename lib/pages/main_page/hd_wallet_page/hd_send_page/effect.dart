import 'dart:async';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/hd_send_page/dialogContainer.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import '../../../../bean/address_book_info.dart';
import '../../../../cache/local_storage.dart';
import 'action.dart';
import 'state.dart';

Effect<HdSendState>? buildEffect() {
  return combineEffects(<Object, Effect<HdSendState>>{
    Lifecycle.initState: _onInit,
    HdSendAction.scanQR: _onScanQR,
    HdSendAction.amountChange: _onAmountChange,
    HdSendAction.validateAddress: _onValidateAddress,
    HdSendAction.showPinCodeDialog: _onShowPinCodeDialog,
    HdSendAction.sendTransaction: _onSendTransaction,
    HdSendAction.showNetworks: _onShowNetworkList,
    HdSendAction.update: _onUpdate,
    HdSendAction.back: _onBack,
    HdSendAction.checkData: _onCheckData,
    HdSendAction.showAlert: _onShowAlert,

    // HdSendAction.sendSignedHash: _onSendTransaction,
  });
}

Future<void> _onInit(Action action, Context<HdSendState> ctx) async {
  // BlockchainClient blockchainClient = BlockchainClient();
  // blockchainClient.addSignHashListener((hashes, publicKey) async {
  //   var resignResponse = await ScanUtil.scanCard(ctx.context,
  //       runnable: SignHashRunnable(hashes as List<Uint8List>));
  //   // sw1: 0xAA,sw2: 0x21
  //   if (resignResponse.isSuccess) {
  //     return resignResponse.data;
  //   } else {
  //     if (resignResponse.sw1 == 0xAA && resignResponse.sw2 == 0x21) {
  //       var result = await ctx.dispatch(
  //           HdSendActionCreator.onShowPinCodeDialog(hashes));
  //       if (result != null) {
  //         List<int> pinCode = result;
  //         final retryResponse = await ScanUtil.scanCard(ctx.context,
  //             runnable: SignHashRunnable(
  //                 hashes as List<Uint8List>, pinCode: pinCode));
  //         if (retryResponse.isSuccess) {
  //           return retryResponse.data;
  //         } else {
  //           showToast(retryResponse.message ?? '');
  //           return [];
  //         }
  //       } else {
  //         return [];
  //       }
  //     } else {
  //       print('Sign hash failed');
  //       showToast(resignResponse.message ?? '');
  //       return [];
  //     }
  //   }
  // });

  CurrencyInfo info = ctx.state.bigCurrency;
  // if (info.address != null) {
  ctx.dispatch(HdSendActionCreator.onShowNetworks(info));
  // }
}

void _onBack(Action action, Context<HdSendState> ctx) {
  // await Future.delayed(const Duration(seconds: 0));
  Navigator.of(ctx.context).pop();
  //  Navigator.of(ctx.context).pop();
  // }
}

Future<void> _onCheckData(Action action, Context<HdSendState> ctx) async {
  String amount = ctx.state.amountController.text;
  final address = ctx.state.addressController.text;
  // 允许 isValidate == null（验证中）时也加载手续费，只在明确验证失败时才跳过
  if (amount.isEmpty || address.isEmpty || ctx.state.isValidate == false) {
    return;
  }
  final currencyType =
      (ctx.state.currencyInfo.currencyData.contractAddress?.isEmpty ?? true)
          ? 'blockchain'
          : 'token';
  final receiverAddress = ctx.state.addressController.text;
  List<NetworkItem>? list;
  try {
    list = await BlockchainPlatform.instance.getFee(
        blockchainId: ctx.state.currencyInfo.currencyData.networkId,
        symbol: ctx.state.currencyInfo.currencyData.symbol,
        currencyType: currencyType,
        sumToSend: amount,
        receiverAddress: receiverAddress,
        isTest: ctx.state.currencyInfo.isTest != null &&
                ctx.state.currencyInfo.isTest == true
            ? "1"
            : "0");
  } catch (e) {
    print("amount error $e");
    showToast('get fee error, please check your balance or network');
    return;
  }

  for (var element in list) {
    print(
        "getFee:name:${element.name} result:fee:${element.fee},gasLimit:${element.gasLimit},gasPrice:${element.gasPrice}");
  }

  ctx.dispatch(HdSendActionCreator.onUpdateNetworks(list));
}

void _onUpdate(Action action, Context<HdSendState> ctx) {
  CurrencyInfo info = action.payload;

  if (info.balance != null) {
    ctx.dispatch(HdSendActionCreator.onLoadSuccess(info));
  } else {
    ctx.dispatch(HdSendActionCreator.onShowLoading());
  }
}

Future<void> _onShowNetworkList(Action action, Context<HdSendState> ctx) async {
  await Future.delayed(const Duration(seconds: 0));

  final languageResource = ctx.state.languageResource!;
  CurrencyInfo info = action.payload;

  if (info.networkLists!.length == 1) {
    ctx.state.networkIndex = 0;
    final networkInfo = info.networkLists![0];
    if (networkInfo.balance == null || networkInfo.address == null) {
      _showTipView(action, ctx);
      return;
    }
    ctx.dispatch(HdSendActionCreator.onUpdate(networkInfo));
    return;
  }

  await showModalBottomSheet(
      context: ctx.context,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      builder: ((_) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languageResource.selectSendNet),
                      CloseButton(
                        onPressed: () {
                          Navigator.of(ctx.context).pop();
                          Navigator.of(ctx.context).pop();
                        },
                      )
                    ]),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: info.networkLists!.length,
                      itemBuilder: (context, index) {
                        final cardInfo = info.networkLists![index];
                        return GestureDetector(
                            onTap: () {
                              if (cardInfo.balance == null ||
                                  cardInfo.address == null) {
                                _showTipView(action, ctx);
                                return;
                              }
                              Navigator.of(ctx.context).pop();
                              ctx.dispatch(
                                  HdSendActionCreator.onUpdate(cardInfo));
                            },
                            child: _itemWidgetBuild(ctx, context, cardInfo));
                      }),
                )
              ],
            ));
      }));
}

void _showTipView(Action action, Context<HdSendState> ctx) async {
  final languageResource = ctx.state.languageResource!;
  await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(
          languageResource.sendNetAbnoraml,
        );
      });
}

Widget _itemWidgetBuild(
    Context<HdSendState> ctx, BuildContext context, CurrencyInfo currency) {
  String coin =
      "${currency.currencyData.id}-${currency.currencyData.networkId.toUpperCase()}";
  return Card(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              coin,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        )),
  );
}

Future<void> _onSendTransaction(Action action, Context<HdSendState> ctx) async {
  if (!(ctx.state.isValidate ?? false)) {
    showToast(ctx.state.languageResource!.invalidAddress);
    return;
  }
  String sumToSend = ctx.state.amountController.text;
  if (sumToSend.isEmpty || num.parse(sumToSend) == 0) {
    showToast(ctx.state.languageResource!.inputAmountTip);
    return;
  }

  num balance = num.parse(ctx.state.currencyInfo.balance ?? '0');
  if (num.parse(sumToSend) > balance) {
    showToast(ctx.state.languageResource!.lackBalance);
    return;
  }

  String receiverAddress = ctx.state.addressController.text;

  String fee;
  String? gasLimit;
  String? gasPrice;
  if (ctx.state.networkList?.isNotEmpty ?? false) {
    var networkItem = ctx.state.networkList![ctx.state.networkIndex];
    fee = networkItem.fee;
    gasLimit = networkItem.gasLimit;
    gasPrice = networkItem.gasPrice;
    print(
        '[hd_send] networkItem: fee=$fee, gasLimit=$gasLimit, gasPrice=$gasPrice, name=${networkItem.name}');
  } else {
    fee = "0";
  }
  final currencyType =
      (ctx.state.currencyInfo.currencyData.contractAddress?.isEmpty ?? true)
          ? 'blockchain'
          : 'token';

  // 对原生链资产（UTXO 链 BTC/DOGE 或 ETH），发送额 + 网络手续费不可超过余额
  // TRX 手续费来自带宽(bandwidth)，不从 TRX 余额扣除，跳过此检查
  final isTrx = ctx.state.currencyInfo.currencyData.networkId
          .toLowerCase()
          .contains('trx') ||
      ctx.state.currencyInfo.currencyData.networkId
          .toLowerCase()
          .contains('tron');
  if (currencyType == 'blockchain' && !isTrx) {
    final feeNum = num.tryParse(fee) ?? 0;
    if (num.parse(sumToSend) + feeNum > balance) {
      showToast(ctx.state.languageResource!.lackBalance);
      return;
    }
  }
  var blockchainId = "";

  blockchainId = ctx.state.currencyInfo.currencyData.networkId;

  // EVM 链 native 转账固定使用 100000 gas，不依赖后端返回值。
  // BTC/DOGE 等 UTXO 链 gasLimit 无意义，保持后端值。
  // ERC20 token 转账 gasLimit 由后端估算，保持后端值。
  final blockchainIdUpper = blockchainId.toUpperCase();
  final isEvmChain = blockchainIdUpper.contains('ETH') ||
      blockchainIdUpper.contains('BSC') ||
      blockchainIdUpper.contains('BNB') ||
      blockchainIdUpper.contains('MATIC') ||
      blockchainIdUpper.contains('POLYGON') ||
      blockchainIdUpper.contains('RTAP') ||
      blockchainIdUpper.contains('RTBP');
  String? safeGasLimit =
      (currencyType == 'blockchain' && isEvmChain) ? '100000' : gasLimit;

  final symbol = ctx.state.currencyInfo.currencyData.symbol;
  final isTestFlag = ctx.state.currencyInfo.isTest != null &&
      ctx.state.currencyInfo.isTest == true;
  print(
      "sendTransaction receiverAddress:$receiverAddress ,sumToSend:$sumToSend currencyType:$currencyType blockchainId:$blockchainId symbol:$symbol fee:$fee gasLimit:$safeGasLimit gasPrice:$gasPrice isTest:$isTestFlag");
  var result = await BlockchainPlatform.instance.sendTransaction(
      receiverAddress: receiverAddress,
      sumToSend: sumToSend,
      type: currencyType,
      fee: fee.toString(),
      walletAddress: ctx.state.currencyInfo.address!,
      blockchainId: blockchainId,
      symbol: symbol,
      gasLimit: safeGasLimit,
      gasPrice: gasPrice,
      isTest: isTestFlag ? "1" : "0",
      contractAddress: ctx.state.currencyInfo.currencyData.contractAddress);

  if (!result.isSuccess) {
    final errorMsg = result.errorMsg ?? '';
    // 用户主动取消 PIN 输入，静默返回
    if (errorMsg.contains("PIN input cancelled") ||
        errorMsg.contains("pin-cancelled")) {
      return;
    }
    if (errorMsg.contains("uid not same")) {
      showToast("uid not same");
    } else {
      String errorMessage =
          errorMsg.isNotEmpty ? errorMsg : 'Send transaction failed';
      showToast(errorMessage.length <= 200
          ? errorMessage
          : '${errorMessage.substring(0, 200)}...');
    }

    return;
  }

  ///添加地址到地址薄
  List<AddressBookInfo> items = await LocalStorage.getAddressBookInfoList();
  int index = items.indexWhere((element) => element.address == receiverAddress);
  if (index == -1) {
    items.add(AddressBookInfo(
      name: '',
      address: receiverAddress,
      remark: '$symbol-$blockchainId',
    ));

    LocalStorage.saveAddressBookInfoList(items);
  }

  await showDialog(
      context: ctx.context,
      builder: (BuildContext context) {
        return ZenggeTextAlertDialog(
            ctx.state.languageResource!.sentSuccessfully);
      });

  Navigator.of(ctx.context).pop();
}

Future<void> _onShowAlert(Action action, Context<HdSendState> ctx) async {
  CurrencyInfo currency = ctx.state.currencyInfo;
  if (!(ctx.state.networkList?.isNotEmpty ?? false)) {
    showToast(ctx.state.languageResource!.selectSendNet);
    return;
  }

  var result = await showDialog(
    context: ctx.context,
    builder: (context) {
      return DialogContainer(
        titleText: ctx.state.languageResource!.sendConfirm,
        confirmText: ctx.state.languageResource!.confirm,
        cancelText: ctx.state.languageResource!.cancel,
        content: _AlertContentWidgetBuild(currency, ctx),
        onConfirm: () => Navigator.of(context).pop(true),
      );
    },
  );
  if (result != null) {
    ctx.dispatch(HdSendActionCreator.onSendTransaction());
  }
}

Widget _AlertContentWidgetBuild(
    CurrencyInfo currency, Context<HdSendState> ctx) {
  String sumToSend = ctx.state.amountController.text;
  //  String balance = "${ctx.state.currencyInfo.balance}";
  //  languageResource = ctx.state.languageResource;
  String fee = "0";
  if (ctx.state.networkList?.isNotEmpty ?? false) {
    fee = ctx.state.networkList![ctx.state.networkIndex].fee;
  } else {
    fee = "0";
  }
  String fee1 = fee;
  final feeSymbol = _feeSymbolByNetworkId(currency.currencyData.networkId);
  final feeText = feeSymbol.isNotEmpty ? "$fee1 $feeSymbol" : fee1;
  final sendQuantityText = "$sumToSend ${currency.currencyData.symbol}";

  // For native coins (blockchain type), fee is in the same unit → can subtract directly.
  // For ERC20 tokens (token type), fee is in network gas coin (e.g. ETH) → show sendAmount unchanged.
  String receivedQuantityText = sendQuantityText;
  final isCoin = (currency.currencyData.contractAddress?.isEmpty ?? true);
  if (isCoin) {
    try {
      num sendAmount = num.parse(sumToSend);
      num feeNum = num.tryParse(fee) ?? 0;
      num receivedAmount = sendAmount - feeNum;
      if (receivedAmount < 0) receivedAmount = 0;
      receivedQuantityText = "$receivedAmount ${currency.currencyData.symbol}";
    } catch (e) {
      print("Error calculating received quantity: $e");
    }
  }

  String netStr =
      "${ctx.state.currencyInfo.currencyData.id}-${ctx.state.currencyInfo.currencyData.networkId}";
  String receiverAddress = ctx.state.addressController.text;
  return SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(ctx.state.languageResource!.sendNetwork,
              style: const TextStyle(fontSize: 15.0)),
          const SizedBox(
            width: 30,
          ),
          Flexible(child: Text(netStr, style: const TextStyle(fontSize: 15.0)))
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(ctx.state.languageResource!.sendAddress,
              style: const TextStyle(fontSize: 15.0)),
          const SizedBox(
            width: 30,
          ),
          Flexible(
              child: Text(receiverAddress,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 15.0)))
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(ctx.state.languageResource!.sendQuantity,
              style: const TextStyle(fontSize: 15.0)),
          Flexible(
              child: Text(sendQuantityText,
                  style: const TextStyle(fontSize: 15.0)))
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(ctx.state.languageResource!.sendFee,
              style: const TextStyle(fontSize: 15.0)),
          const SizedBox(
            width: 30,
          ),
          Flexible(
              child: Text(feeText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 15.0)))
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(ctx.state.languageResource!.receivedQuantity,
              style: const TextStyle(fontSize: 15.0)),
          const SizedBox(
            width: 30,
          ),
          Flexible(
              child: Text(receivedQuantityText,
                  style: const TextStyle(fontSize: 15.0)))
        ]),
        const SizedBox(height: 4)
      ])
    ],
  ));
}

String _feeSymbolByNetworkId(String networkId) {
  final id = networkId.toUpperCase();
  if (id.contains('ETH')) {
    return 'ETH';
  }
  if (id.contains('BSC') || id.contains('BNB')) {
    return 'BNB';
  }
  if (id.contains('MATIC') || id.contains('POLYGON')) {
    return 'MATIC';
  }
  if (id.contains('TRON') || id.contains('TRX')) {
    return 'TRX';
  }
  if (id == 'BTC') {
    return 'BTC';
  }
  // RTAP and RTBP chains use ETH for gas fees
  if (id.contains('RTAP') || id.contains('RTBP')) {
    return 'ETH';
  }
  return '';
}

Future<void> _onScanQR(Action action, Context<HdSendState> ctx) async {
  var result = await Navigator.of(ctx.context).pushNamed('scanQrcodePage');
  if (result != null) {
    ctx.state.addressController.text = result.toString();
    ctx.dispatch(HdSendActionCreator.onValidateAddress(result.toString()));
  }
}

Future<List<int>?> _onShowPinCodeDialog(
    Action action, Context<HdSendState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var result = await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeInputAlertDialog(
          titleText: ctx.state.languageResource!.inputPinCode,
          keyboardType: TextInputType.number,
          enableCancel: true,
          hintText: languageResource.pinCode,
        );
      });
  await Future.delayed(const Duration(seconds: 1));

  if (result != null) {
    List<int> pinCode = [];
    for (int i = 0; i < result.length; i++) {
      pinCode.add(int.parse(result[i]));
    }
    return pinCode;
  } else {
    return null;
  }
}

void _onAmountChange(Action action, Context<HdSendState> ctx) {
  var amount = ctx.state.amountController.text;
  if (amount.isEmpty) {
    if (ctx.state.amountTimer?.isActive == true) {
      ctx.state.amountTimer?.cancel();
    }
    ctx.state.networkList = [];
    ctx.state.networkIndex = 0;
    ctx.dispatch(HdSendActionCreator.onLoadSuccess(ctx.state.currencyInfo));
    return;
  }

  if (ctx.state.amountTimer?.isActive == true) {
    ctx.state.amountTimer?.cancel();
  }
  ctx.state.amountTimer =
      Timer.periodic(const Duration(seconds: 1), (timer) async {
    timer.cancel();
    ctx.dispatch(HdSendActionCreator.onCheckData());
  });
}

void _onValidateAddress(Action action, Context<HdSendState> ctx) {
  ctx.state.validateTimer?.cancel();
  ctx.state.validateTimer =
      Timer.periodic(const Duration(seconds: 1), (timer) async {
    timer.cancel();

    bool isValidate = await BlockchainPlatform.instance.validateAddress(
        blockchain: ctx.state.currencyInfo.currencyData.networkId,
        address: action.payload,
        isTest: ctx.state.currencyInfo.isTest != null &&
                ctx.state.currencyInfo.isTest == true
            ? "1"
            : "0");
    print(
        "validate address ${ctx.state.currencyInfo.currencyData.networkId} ${action.payload} $isValidate");
    ctx.state.isValidate = isValidate;
    ctx.dispatch(HdSendActionCreator.onUpdateValid(isValidate));
    ctx.dispatch(HdSendActionCreator.onCheckData());
  });
}
