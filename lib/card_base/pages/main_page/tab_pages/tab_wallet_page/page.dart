import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TabWalletPage extends Page<TabWalletState, Map<String, dynamic>> {
  TabWalletPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<TabWalletState>(
                slots: <String, Dependent<TabWalletState>>{
                }),
            middleware: <Middleware<TabWalletState>>[
            ],);

}
