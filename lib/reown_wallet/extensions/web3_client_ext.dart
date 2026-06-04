import 'dart:convert';
import 'dart:typed_data';

import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import '../utils/rlp.dart' as rlp;

extension Web3ClientExt on Web3Client {
  Future<String> sendTransactionByCard(
    String blockchainId,
    Transaction transaction, {
    int? chainId = 1,
    bool fetchChainIdFromNetworkId = false,
  }) async {
    var signed = await signTransactionByCard(
      blockchainId,
      transaction,
      chainId: chainId,
      fetchChainIdFromNetworkId: fetchChainIdFromNetworkId,
    );

    if (transaction.isEIP1559) {
      signed = prependTransactionType(0x02, signed);
    }

    return sendRawTransaction(signed);
  }

  Future<Uint8List> signTransactionByCard(
    String blockchainId,
    Transaction transaction, {
    int? chainId = 1,
    bool fetchChainIdFromNetworkId = false,
  }) async {
    final signingInput = await _fillMissingData(
      transaction: transaction,
      chainId: chainId,
      loadChainIdFromNetwork: fetchChainIdFromNetworkId,
      client: this,
    );

    return signTransactionRaw(
      signingInput.transaction,
      blockchainId,
      chainId: signingInput.chainId,
    );
  }

  Future<_SigningInput> _fillMissingData({
    required Transaction transaction,
    int? chainId,
    bool loadChainIdFromNetwork = false,
    Web3Client? client,
  }) async {
    if (loadChainIdFromNetwork && chainId != null) {
      throw ArgumentError(
        "You can't specify loadChainIdFromNetwork and specify a custom chain id!",
      );
    }

    final sender = transaction.from!;
    var gasPrice = transaction.gasPrice;

    if (client == null &&
        (transaction.nonce == null ||
            transaction.maxGas == null ||
            loadChainIdFromNetwork ||
            (!transaction.isEIP1559 && gasPrice == null))) {
      throw ArgumentError('Client is required to perform network actions');
    }

    if (!transaction.isEIP1559 && gasPrice == null) {
      gasPrice = await client!.getGasPrice();
    }

    var maxFeePerGas = transaction.maxFeePerGas;
    var maxPriorityFeePerGas = transaction.maxPriorityFeePerGas;

    if (transaction.isEIP1559) {
      maxPriorityFeePerGas ??= await _getMaxPriorityFeePerGas();
      maxFeePerGas ??= await _getMaxFeePerGas(
        client!,
        maxPriorityFeePerGas.getInWei,
      );
    }

    final nonce = transaction.nonce ??
        await client!
            .getTransactionCount(sender, atBlock: const BlockNum.pending());

    final maxGas = transaction.maxGas ??
        await client!
            .estimateGas(
              sender: sender,
              to: transaction.to,
              data: transaction.data,
              value: transaction.value,
              gasPrice: gasPrice,
              maxPriorityFeePerGas: maxPriorityFeePerGas,
              maxFeePerGas: maxFeePerGas,
            )
            .then((bigInt) => bigInt.toInt());

    // apply default values to null fields
    final modifiedTransaction = transaction.copyWith(
      value: transaction.value ?? EtherAmount.zero(),
      maxGas: maxGas,
      from: sender,
      data: transaction.data ?? Uint8List(0),
      gasPrice: gasPrice,
      nonce: nonce,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
      maxFeePerGas: maxFeePerGas,
    );

    int resolvedChainId;
    if (!loadChainIdFromNetwork) {
      resolvedChainId = chainId!;
    } else {
      resolvedChainId = await client!.getNetworkId();
    }

    return _SigningInput(
        transaction: modifiedTransaction, chainId: resolvedChainId);
  }

  Future<Uint8List> signTransactionRaw(
    Transaction transaction,
    String blockchainId, {
    int? chainId = 1,
  }) async {
    final encoded = transaction.getUnsignedSerialized(chainId: chainId);
    String text1 = utf8.decode(keccak256(encoded));
    var signature = await BlockchainPlatform.instance
        .signTransaction(blockchainId, text1, chainId: chainId);
    if (transaction.isEIP1559 && chainId != null) {
      return uint8ListFromList(
        rlp.encode(
          _encodeEIP1559ToRlp(transaction, signature, BigInt.from(chainId)),
        ),
      );
    }
    return uint8ListFromList(rlp.encode(_encodeToRlp(transaction, signature)));
  }
}

Future<EtherAmount> _getMaxPriorityFeePerGas() {
  // We may want to compute this more accurately in the future,
  // using the formula "check if the base fee is correct".
  // See: https://eips.ethereum.org/EIPS/eip-1559
  return Future.value(EtherAmount.inWei(BigInt.from(1000000000)));
}

// Max Fee = (2 * Base Fee) + Max Priority Fee
Future<EtherAmount> _getMaxFeePerGas(
  Web3Client client,
  BigInt maxPriorityFeePerGas,
) async {
  final blockInformation = await client.getBlockInformation();
  final baseFeePerGas = blockInformation.baseFeePerGas;

  if (baseFeePerGas == null) {
    return EtherAmount.zero();
  }

  return EtherAmount.inWei(
    baseFeePerGas.getInWei * BigInt.from(2) + maxPriorityFeePerGas,
  );
}

List<dynamic> _encodeEIP1559ToRlp(
  Transaction transaction,
  MsgSignature? signature,
  BigInt chainId,
) {
  final list = [
    chainId,
    transaction.nonce,
    transaction.maxPriorityFeePerGas!.getInWei,
    transaction.maxFeePerGas!.getInWei,
    transaction.maxGas,
  ];

  if (transaction.to != null) {
    list.add(transaction.to!.addressBytes);
  } else {
    list.add('');
  }

  list
    ..add(transaction.value?.getInWei)
    ..add(transaction.data);

  list.add([]); // access list

  if (signature != null) {
    list
      ..add(signature.v)
      ..add(signature.r)
      ..add(signature.s);
  }

  return list;
}

List<dynamic> _encodeToRlp(Transaction transaction, MsgSignature? signature) {
  final list = [
    transaction.nonce,
    transaction.gasPrice?.getInWei,
    transaction.maxGas,
  ];

  if (transaction.to != null) {
    list.add(transaction.to!.addressBytes);
  } else {
    list.add('');
  }

  list
    ..add(transaction.value?.getInWei)
    ..add(transaction.data);

  if (signature != null) {
    list
      ..add(signature.v)
      ..add(signature.r)
      ..add(signature.s);
  }

  return list;
}

class _SigningInput {
  _SigningInput({
    required this.transaction,
    this.chainId,
  });

  final Transaction transaction;
  final int? chainId;
}
