import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SendLightningInvoicePage extends Page<SendLightningInvoiceState, Map<String, dynamic>> {
  SendLightningInvoicePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SendLightningInvoiceState>(
                adapter: null,
                slots: <String, Dependent<SendLightningInvoiceState>>{
                }),
            middleware: <Middleware<SendLightningInvoiceState>>[
            ],);

}
