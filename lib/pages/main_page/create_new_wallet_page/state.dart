import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../widget/base_page_loading.dart';

class CreateNewWalletState extends LoadPageState<CreateNewWalletState> {
  late CardInfo cardInfo;
  CardDetail? cardDetail;
  late List<CardInfo> cardInfoList;
  List<CurrencyInfo> defaultCurrencyList = [];
  @override
  CreateNewWalletState clone() {
    return CreateNewWalletState()
      ..cardInfo = cardInfo
      ..cardDetail = cardDetail
      ..cardInfoList = cardInfoList
      ..loadStatus = loadStatus
      ..defaultCurrencyList = defaultCurrencyList
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..errorMsg = errorMsg;
  }
}

CreateNewWalletState initState(Map<String, dynamic>? args) {
  return CreateNewWalletState()
    ..cardInfo = args!['cardInfo']
    ..cardInfoList = args['cardInfoList'];
}
