
import 'package:fish_redux/fish_redux.dart';

import '../../../../bean/link_bean.dart';
import '../card_item_component/component.dart';
import '../card_item_component/state.dart';
import '../state.dart';

FlowAdapter<CardManagerState> get adapter => FlowAdapter<CardManagerState>(
  view: (CardManagerState state) => DependentArray<CardManagerState>(
    length: state.itemCount,
    builder: (int index) {
      return CardItemConnector(index: index) + CardItemComponent();
    },
  ),
);

class CardItemConnector extends ConnOp<CardManagerState, CardItemState> {
  CardItemConnector({required this.index});

  final int index;

  @override
  CardItemState? get(CardManagerState? state) {
    if (index >= state!.list.length) {
      return initCardItemState(NFCCardItem());
    }
    return state.list[index];
  }

  @override
  void set(CardManagerState state, CardItemState subState) {
    state.list[index] = subState;
  }
}