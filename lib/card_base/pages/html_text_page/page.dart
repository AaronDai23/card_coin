import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HtmlTextPage extends Page<HtmlTextState, Map<String, dynamic>> {
  HtmlTextPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HtmlTextState>(
                adapter: null,
                slots: <String, Dependent<HtmlTextState>>{
                }),
            middleware: <Middleware<HtmlTextState>>[
            ],);

}
