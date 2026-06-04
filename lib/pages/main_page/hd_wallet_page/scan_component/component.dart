import 'package:fish_redux/fish_redux.dart';

import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ScanComponent extends Component<ScanState> {
  ScanComponent()
      : super(
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ScanState>(
                adapter: null,
                slots: <String, Dependent<ScanState>>{
                }),);

}
