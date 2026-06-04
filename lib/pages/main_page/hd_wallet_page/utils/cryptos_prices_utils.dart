import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/utils/number_util.dart';

import '../../../../bean/fiat_bean.dart';
import '../cryptos_price.dart';

class CryptosPriceUtils {
  static String cryptoPairPrice(FiatInfo currentFiat,Map<String, CryptosPrice> cryptosPriceMap, CurrencyInfo bean, int type) {
    if (bean.currencyData.symbol == 'USDT' &&
        currentFiat.symbol == 'USDT') {
      return '1.00';
    }
    if (bean.currencyData.symbol == 'USDT') {
      return type == 0
          ? NumberUtils.getFullCount(NumberUtils.getFullCountBetweenTwoNumber(
              '1.00', currentFiat.currentPrice, 2))
          : NumberUtils.getFullCountBetweenTwoNumber(
              '1.00', currentFiat.currentPrice, 2);
    }
    var crptyoprice = cryptosPriceMap[bean.currencyData.symbol];
    if (crptyoprice == null) {
      return '0.00';
    }


    return type == 0
        ? NumberUtils.getFullCount(NumberUtils.getFullCountBetweenTwoNumber(
            crptyoprice.price.toString(), currentFiat.currentPrice, 2))
        : NumberUtils.getFullCountBetweenTwoNumber(
            crptyoprice.price.toString(), currentFiat.currentPrice, 2);
  }

  static cryptoTotalPrice(String price, int index) {
    if (price.isEmpty) {
      return "0.00";
    }
    var datas = price.split(".");
    if (datas.isEmpty) {
      return '0';
    }

    if (datas.length > index) {
      return datas[index];
    }
    return '0';
  }
}
