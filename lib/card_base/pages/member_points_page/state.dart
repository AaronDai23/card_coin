
import 'package:card_coin/card_base/bean/points_history_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/member_points_info.dart';

class MemberPointsState extends LoadPageState<MemberPointsState> {
  late String title;
  MemberPointsInfo? memberPointsInfo;
  RefreshController refreshController = RefreshController();
  int currentPage = 1;
  List<PointsHistory> list = [];
  @override
  MemberPointsState clone() {
    return MemberPointsState()
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..title = title
      ..list = list
      ..memberPointsInfo = memberPointsInfo
      ..currentPage = currentPage
      ..refreshController = refreshController
    ;
  }

}

MemberPointsState initState(Map<String, dynamic>? args) {
  return MemberPointsState()..title = args?['title']??'';
}
