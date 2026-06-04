import 'package:fish_redux/fish_redux.dart';

import '../member_item_component/component.dart';
import '../state.dart';
import 'state.dart';


FlowAdapter<GroupCardState> get adapter => FlowAdapter<GroupCardState>(
  view: (GroupCardState state) => DependentArray<GroupCardState>(
    length: state.itemCount,
    builder: (int index) {
      return CardMemberItemConnector(index: index) + MemberItemComponent();
    },
  ),
);

class CardMemberItemConnector extends ConnOp<GroupCardState, CardGroupItemState> {
  CardMemberItemConnector({required this.index});

  final int index;

  @override
  CardGroupItemState? get(GroupCardState? state) {
    if (index >= state!.list.length) {
      return CardGroupItemState();
    }
    return state.list[index];
  }

  @override
  void set(GroupCardState state, CardGroupItemState subState) {
    state.list[index] = subState;
  }
}