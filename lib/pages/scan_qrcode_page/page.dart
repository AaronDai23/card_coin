import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ScanQrcodePage extends Page<ScanQrcodeState, Map<String, dynamic>> {
  ScanQrcodePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ScanQrcodeState>(
                adapter: null,
                slots: <String, Dependent<ScanQrcodeState>>{
                }),
            middleware: <Middleware<ScanQrcodeState>>[
            ],);

}
