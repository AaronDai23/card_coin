import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WithdrawBankPage extends Page<WithdrawBankState, Map<String, dynamic>> {
  WithdrawBankPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WithdrawBankState>(
            adapter: null,
            slots: <String, Dependent<WithdrawBankState>>{},
          ),
          middleware: <Middleware<WithdrawBankState>>[],
        );
}
