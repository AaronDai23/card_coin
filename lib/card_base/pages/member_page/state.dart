import 'package:card_swiper/card_swiper.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/member_level_bean.dart';


class MemberState extends LoadPageState<MemberState> {
  CurrentLevel? currentLevel;
  List<CustomerLevel>? customerLevels;
  late int index;
  SwiperController controller = SwiperController();
  // List<LevelRank> rankList = [];
  CustomerLevelInfo? customerLevelInfo;
  @override
  MemberState clone() {
    return MemberState()
      ..errorMsg = errorMsg
      ..currentLevel = currentLevel
      ..languageLocale = languageLocale
      ..customerLevels = customerLevels
      ..index = index
      ..customerLevelInfo = customerLevelInfo
      ..languageResource = languageResource
      // ..rankList = rankList
      ..controller = controller
      ..loadStatus = loadStatus;
  }
}

MemberState initState(Map<String, dynamic>? args) {
  return MemberState()..index = 0;
}
