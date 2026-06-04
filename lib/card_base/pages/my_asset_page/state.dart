import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/bean/asset_summary_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:super_tooltip/super_tooltip.dart';

class MyAssetState extends LoadPageState<MyAssetState> {
  String uid = '';
  SmartCardDetail? cardDetail;
  AssetSummaryInfo? assetSummaryInfo;
  String selectedType = 'ALL'; // 记录选中类别
  List<AssetTypeData>? selectedTypes = []; // 类别数据
  String tooltip = "";
  String selectedShowPrice = '0.0'; // 记录选中类别

  SuperTooltipController controller = SuperTooltipController();
  @override
  MyAssetState clone() {
    return MyAssetState()
      ..uid = uid
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..errorMsg = errorMsg
      ..cardDetail = cardDetail
      ..assetSummaryInfo = assetSummaryInfo
      ..selectedType = selectedType
      ..selectedTypes = selectedTypes
      ..controller = controller
      ..tooltip = tooltip
      ..selectedShowPrice = selectedShowPrice
      ..loadStatus = loadStatus;
  }
}

MyAssetState initState(Map<String, dynamic>? args) {
  return MyAssetState()
    ..uid = args?['uid'] ?? ''
    ..cardDetail = args?['cardDetail'];
}
