
import '../../../../../base/base_item.dart';
import '../../../../bean/link_bean.dart';

class CardItemState extends BaseItem<NFCCardItem> {
  @override
  CardItemState clone() {
    return CardItemState()
      ..bean = bean
      ..type = type;
  }

  @override
  String type = '';
}

CardItemState initState(Map<String, dynamic> args) {
  return CardItemState();
}

CardItemState initCardItemState(NFCCardItem bean) {
  return CardItemState()..bean = bean;
}
