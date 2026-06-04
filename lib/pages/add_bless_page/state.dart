import 'package:card_coin/card_base/bean/chain_stamp.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class AddBlessState implements Cloneable<AddBlessState> {
  late TextEditingController blessController;
  late TextEditingController amountController;
  late int remainCount;

  // 用于存储搜索结果
  List<ChainStamp> searchResults = [];

  late ChainStamp selectedCard; // 当前选中的卡片信息

  // 用于存储搜索结果
  // 标记是否正在加载
  bool isLoading = false;
  @override
  AddBlessState clone() {
    return AddBlessState()
      ..blessController = blessController
      ..amountController = amountController
      ..searchResults = searchResults
      ..isLoading = isLoading
      ..selectedCard = selectedCard
      ..remainCount = remainCount;
  }
}

AddBlessState initState(Map<String, dynamic>? args) {
  final controller = TextEditingController();
  var selectedCard1 = ChainStamp(uid: "", alias: "", cardNo: "");
  return AddBlessState()
    ..blessController = controller
    ..amountController = TextEditingController()
    ..selectedCard = selectedCard1
    ..remainCount = 200;
}
