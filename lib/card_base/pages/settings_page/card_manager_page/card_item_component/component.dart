import 'package:fish_redux/fish_redux.dart';

import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CardItemComponent extends Component<CardItemState> {
  CardItemComponent()
      : super(
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CardItemState>(
                adapter: null,
                slots: <String, Dependent<CardItemState>>{
                }),);

}
