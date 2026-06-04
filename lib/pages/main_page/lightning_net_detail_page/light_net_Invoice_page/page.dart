import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class LightNetInvoicePage extends Page<LightNetInvoiceState, Map<String, dynamic>> {
  LightNetInvoicePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<LightNetInvoiceState>(
                adapter: null,
                slots: <String, Dependent<LightNetInvoiceState>>{
                }),
            middleware: <Middleware<LightNetInvoiceState>>[
            ],);

}
