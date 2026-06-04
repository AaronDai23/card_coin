import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

class CurrencyItemState implements Cloneable<CurrencyItemState> {
  late CurrencyInfo bean;
  LoadType loadType = LoadType.loading;
  String errorMsg = '';
  bool isSelected = false;

  @override
  CurrencyItemState clone() {
    return CurrencyItemState()
      ..loadType = loadType
      ..errorMsg = errorMsg
      ..isSelected = isSelected
      ..bean = bean;
  }
}
