import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NoticeDetailPage extends Page<NoticeDetailState, Map<String, dynamic>> {
  NoticeDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NoticeDetailState>(
                adapter: null,
                slots: <String, Dependent<NoticeDetailState>>{
                }),
            middleware: <Middleware<NoticeDetailState>>[
            ],);

}
