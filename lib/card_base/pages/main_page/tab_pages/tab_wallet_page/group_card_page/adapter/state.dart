

import 'package:card_coin/card_base/bean/card_group_bean.dart';

import '../../../../../../../base/base_item.dart';

class CardGroupItemState extends BaseItem<CardGroup> {
  @override
  CardGroupItemState clone() {
    return CardGroupItemState()
      ..bean = bean
      ..type = type;
  }

  @override
  String get type {
    return 'cardGroupItem';
  }

  @override
  set type(String type) {
    // TODO: implement type
  }
}

CardGroupItemState initState(Map<String, dynamic> args) {
  return CardGroupItemState();
}

CardGroupItemState initCardGroupItemState(CardGroup bean) {
  return CardGroupItemState()..bean = bean;
}
