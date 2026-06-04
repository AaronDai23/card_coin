import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AssetSettingsPage extends Page<AssetSettingsState, Map<String, dynamic>> {
  AssetSettingsPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AssetSettingsState>(
                adapter: null,
                slots: <String, Dependent<AssetSettingsState>>{
                }),
            middleware: <Middleware<AssetSettingsState>>[
            ],);

}
