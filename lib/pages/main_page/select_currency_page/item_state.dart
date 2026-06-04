import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/bean/select_item_state.dart';

class NetworkItemState extends SelectItemState<CurrencyCoin> {
  @override
  SelectItemState clone() {
    return NetworkItemState()
      ..bean = bean
      ..isSelected = isSelected;
  }
}

NetworkItemState initCurrencySelectItemState(CurrencyCoin bean,
    {bool isSelected = false}) {
  return NetworkItemState()
    ..isSelected = isSelected
    ..bean = bean;
}
