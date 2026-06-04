import 'dart:convert';

import 'package:card_coin/bean/address_book_info.dart';
import 'package:card_coin/cache/sp_util.dart';
import 'package:card_coin/utils/runnable/bean/compatibility_info.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bean/blockchain/bit_coin_transaction_info.dart';
import '../card_base/bean/page_button_info.dart';
import '../utils/string_util.dart';
import 'bean/user_info_bean.dart';

///SharedPreferences 本地存储
class LocalStorage {
  static const localeKey = "locale_key";
  static const userInfoKey = "user_info_key";
  static const localizationMd5 = "localization_md5";
  static const localizationList = "localization_list";
  static const cardInfo = "card_info";
  static const cardInvestmentConfig = "card_invest_config";
  static const cardInfoList = "card_info_list";
  static const addressBookKey = "address_book_key";
  static const allCryptoList = "all_crypto_list";
  static const allCryptoListMd5 = "all_crypto_list_md5";
  static const liteAllCryptoList = "lite_all_crypto_list";
  static const buttonListKey = "button_list";
  static const cardActivited = "card_activited";
  static const cardResetCount = "card_reset_count";
  static const cardSwitched = "card_switched_";
  static const customerSmartCardId = "customerSmartCardId_";

  static UserInfo? _userInfo;
  static List<PageButtonInfo>? _buttonList;

  static save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future<bool> saveStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, list);
  }

  static Future<Object?> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<List<CurrencyInfo>?> getWallets(String mnemonic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var walletStrings = prefs.getStringList('wallet_$mnemonic');
    if (walletStrings?.isNotEmpty ?? false) {
      return walletStrings!
          .map((e) => CurrencyInfo.fromJson(json.decode(e))..balance = '0')
          .toList();
    }
    return null;
  }

  static Future<bool> saveWallets(
      String mnemonic, List<CurrencyInfo> wallets) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = wallets.map((e) {
      return e.toString();
    }).toList();
    var result = await prefs.setStringList('wallet_$mnemonic', list);
    return result;
  }

  static Future<Locale?> getLocale() async {
    await SpUtil.getInstance();
    String localeStr = SpUtil.getString(localeKey);
    if (localeStr.isNotEmpty) {
      return StringUtils.string2Locale(localeStr);
    } else {
      return null;
    }

    // GlobalStore.store.dispatch(GlobalActionCreator.onChangeLanguage(locale));
  }

  ///持久化主题资源
  static void saveLocale(Locale locale) async {
    await SpUtil.getInstance();
    SpUtil.putString(localeKey, StringUtils.locale2String(locale));
  }

  static UserInfo? getCacheUserInfo() {
    return _userInfo;
  }

  static Future<String?> getCardUuid() async {
    if (_userInfo != null) {
      String? cardUuid =
          await getString('${_userInfo!.customer!.id}_card_uuid');
      return cardUuid;
    }
    return null;
  }

  static Future<bool> saveCardUuid(String cardUuid) async {
    if (_userInfo != null) {
      return LocalStorage.saveString(
          '${_userInfo!.customer!.id}_card_uuid', cardUuid);
    }
    return false;
  }

  static Future<String?> getCardNo(String cardUuid) async {
    if (_userInfo != null) {
      String? cardNo =
          await getString('${_userInfo!.customer!.id}_${cardUuid}_card_no');
      return cardNo;
    }
    return null;
  }

  static Future<bool> saveCardNo(String cardUuid, String cardNo) async {
    if (_userInfo != null) {
      return LocalStorage.saveString(
          '${_userInfo!.customer!.id}_${cardUuid}_card_no', cardNo);
    }
    return false;
  }

  static Future<UserInfo?> getUserInfo() async {
    if (_userInfo == null) {
      String? jsonStr = (await get(userInfoKey)) as String?;
      if (jsonStr != null) {
        _userInfo = JsonUtil.getObj(
            jsonStr, (v) => UserInfo.fromJson(v as Map<String, dynamic>));
      }
    }
    return _userInfo;
  }

  static saveUserInfo(UserInfo userInfo) {
    _userInfo = userInfo;
    save(userInfoKey, JsonUtil.encodeObj(userInfo));
  }

  static cleanUserInfo() {
    LocalStorage.remove(LocalStorage.userInfoKey);
    _userInfo = null;
  }

  /// 地址簿
  static Future<List<AddressBookInfo>> getAddressBookInfoList() async {
    final list = await getStringList(addressBookKey);
    if (list == null) return [];
    return list.map((e) => AddressBookInfo.fromJson(json.decode(e))).toList();
  }

  static Future<bool> saveAddressBookInfoList(
      List<AddressBookInfo> items) async {
    final list = items.map((e) => json.encode(e)).toList();
    return await saveStringList(addressBookKey, list);
  }

  static List<PageButtonInfo>? getCacheButtonList() {
    return _buttonList;
  }

  static Future<List<PageButtonInfo>?> getButtonList() async {
    if (_buttonList == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var stringList = prefs.getStringList(buttonListKey);
      if (stringList != null) {
        _buttonList = stringList
            .map((e) => PageButtonInfo.fromJson(json.decode(e)))
            .toList();
      }
    }
    return _buttonList;
  }

  static saveButtonList(List<PageButtonInfo> buttonList) async {
    _buttonList = buttonList;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        buttonListKey, buttonList.map((e) => json.encode(e.toJson())).toList());
  }

  static saveCompatibility(
      String key, CompatibilityInfo compatibilityInfo) async {
    String? jsss = json.encode(compatibilityInfo.toJson());
    print('saveCompatibility:$jsss');
    save(key, jsss);
  }

  static Future<CompatibilityInfo?> getCompatibility(String key) async {
    String? jsonStr = (await get(key)) as String?;
    if (jsonStr != null) {
      CompatibilityInfo? compatibilityInfo = JsonUtil.getObj(jsonStr,
          (v) => CompatibilityInfo.fromJson(v as Map<String, dynamic>));
      return compatibilityInfo;
    }

    return null;
  }
}
