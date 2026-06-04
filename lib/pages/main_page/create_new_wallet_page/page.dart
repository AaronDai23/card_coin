import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CreateNewWalletPage extends Page<CreateNewWalletState, Map<String, dynamic>> {
  CreateNewWalletPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CreateNewWalletState>(
                adapter: null,
                slots: <String, Dependent<CreateNewWalletState>>{
                }),
            middleware: <Middleware<CreateNewWalletState>>[
            ],);

}
