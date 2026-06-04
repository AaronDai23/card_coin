import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AddressBookPage extends Page<AddressBookState, Map<String, dynamic>> {
  AddressBookPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AddressBookState>(
            adapter: null,
            slots: <String, Dependent<AddressBookState>>{},
          ),
          middleware: <Middleware<AddressBookState>>[],
        );
}
