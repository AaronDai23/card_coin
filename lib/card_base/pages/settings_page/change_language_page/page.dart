import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ChangeLanguagePage extends Page<ChangeLanguageState, Map<String, dynamic>> {
  ChangeLanguagePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ChangeLanguageState>(
                adapter: null,
                slots: <String, Dependent<ChangeLanguageState>>{
                }),
            middleware: <Middleware<ChangeLanguageState>>[
            ],);

}
