import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EncryptCheckPage extends Page<EncryptCheckState, Map<String, dynamic>> {
  EncryptCheckPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EncryptCheckState>(
                adapter: null,
                slots: <String, Dependent<EncryptCheckState>>{
                }),
            middleware: <Middleware<EncryptCheckState>>[
            ],);

}
