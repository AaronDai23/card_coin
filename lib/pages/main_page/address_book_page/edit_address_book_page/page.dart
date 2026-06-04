import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EditAddressBookPage extends Page<EditAddressBookState, Map<String, dynamic>> {
  EditAddressBookPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<EditAddressBookState>(
            adapter: null,
            slots: <String, Dependent<EditAddressBookState>>{},
          ),
          middleware: <Middleware<EditAddressBookState>>[],
        );
}
