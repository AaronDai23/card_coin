import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class CoinMessageDetailState extends LoadPageState<CoinMessageDetailState> {
  CoinMessageDetail? messageDetail;
  late String noticeId;
  @override
  CoinMessageDetailState clone() {
    return CoinMessageDetailState()
      ..messageDetail = messageDetail
      ..noticeId = noticeId;
  }
}

CoinMessageDetailState initState(Map<String, dynamic>? args) {
  var noticeId = args?['noticeId'] ?? '1234567890';

  return CoinMessageDetailState()..noticeId = noticeId;
}
