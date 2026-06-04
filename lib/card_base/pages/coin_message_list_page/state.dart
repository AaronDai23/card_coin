import 'package:card_coin/bean/coin_message_item.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoinMessageListState extends LoadPageState<CoinMessageListState> {
  List<CoinMessageItem> items = [];
  late String uid;

  late RefreshController refreshController;
  int currentPage = 1;
  @override
  CoinMessageListState clone() {
    return CoinMessageListState()
      ..items = items
      ..uid = uid
      ..refreshController = refreshController
      ..currentPage = currentPage
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg;
  }
}

CoinMessageListState initState(Map<String, dynamic>? args) {
  var uid = args?['uid'] ?? 'user123';
  return CoinMessageListState()
    ..loadStatus = LoadType.loading
    ..refreshController = RefreshController()
    ..items = []
    ..uid = uid;
}
