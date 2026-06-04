import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HDWalletListPage extends Page<HDWalletListState, Map<String, dynamic>> {
  HDWalletListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HDWalletListState>(
              adapter: null, slots: <String, Dependent<HDWalletListState>>{}),
          middleware: <Middleware<HDWalletListState>>[],
        );
}
