import 'dart:typed_data';

import 'package:reown_walletkit/reown_walletkit.dart';
import 'rlp.dart' as rlp;
Uint8List buildTransferToSend(Transaction transaction,{List<int>? signature,int? chainId = 1}){
  if (transaction.isEIP1559 && chainId != null) {
    return uint8ListFromList(
      rlp.encode(
        _encodeEIP1559ToRlp(transaction, signature, BigInt.from(chainId)),
      ),
    );
  }
  return uint8ListFromList(rlp.encode(_encodeToRlp(transaction, signature)));
}





List<dynamic> _encodeEIP1559ToRlp(
    Transaction transaction,
    List<int>? signature,
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
    list.addAll(signature);
  }

  return list;
}

List<dynamic> _encodeToRlp(Transaction transaction, List<int>? signature) {
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
    list.addAll(signature);
  }

  return list;
}