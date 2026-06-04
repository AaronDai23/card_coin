import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CardWalletListPage extends Page<CardWalletListState, Map<String, dynamic>> {
  CardWalletListPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CardWalletListState>(
                adapter: null,
                slots: <String, Dependent<CardWalletListState>>{
                }),
            middleware: <Middleware<CardWalletListState>>[
            ],);

}
