import 'package:fish_redux/fish_redux.dart';

import '../adapter/state.dart';
import 'reducer.dart';
import 'view.dart';

class MemberItemComponent extends Component<CardGroupItemState> {
  MemberItemComponent()
      : super(
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CardGroupItemState>(
                adapter: null,
                slots: <String, Dependent<CardGroupItemState>>{
                }),);

}
