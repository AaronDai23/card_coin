import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../cache/local_storage.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/country_register_info.dart';
import '../../bean/login_bean.dart';

const String _multipleLoginMethodCacheKey = 'multiple_login_method_cache_v1';
const String _multipleLoginCountryCacheKey = 'multiple_login_country_cache_v1';

class MultipleLoginState extends LoadPageState<MultipleLoginState> {
  late TextEditingController phoneController;
  late TextEditingController phonePwdController;
  late TextEditingController emailController;
  late TextEditingController emailPwdController;
  late int currentIndex = 0;
  late List<LoginMethod> loginMethodList;
  List<CountryRegisterInfo> countryList = [];
  // late List<LoginType> loginTypeList;

  @override
  MultipleLoginState clone() {
    return MultipleLoginState()
      ..phoneController = phoneController
      ..currentIndex = currentIndex
      ..phonePwdController = phonePwdController
      ..emailController = emailController
      ..emailPwdController = emailPwdController
      ..languageLocale = languageLocale
      ..countryList = countryList
      // ..loginTypeList = loginTypeList
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageResource = languageResource
      ..loginMethodList = loginMethodList;
  }
}

MultipleLoginState initState(Map<String, dynamic>? args) {
  return MultipleLoginState()
        ..loadStatus = LoadType.loadSuccess
        ..phoneController = TextEditingController()
        ..phonePwdController = TextEditingController()
        ..emailPwdController = TextEditingController()
        ..emailController = TextEditingController()
        ..loginMethodList = []
      // ..loginTypeList = [LoginType.MOBILE_OTP,LoginType.MOBILE_PASSWORD,LoginType.EMAIL_OTP,LoginType.EMAIL_PASSWORD]
      ;
}

Future<void> restoreMultipleLoginCache(
    MultipleLoginState state,
    void Function(
            List<LoginMethod> loginMethods, List<CountryRegisterInfo> countries)
        onCacheReady) async {
  final results = await Future.wait([
    LocalStorage.getString(_multipleLoginMethodCacheKey),
    LocalStorage.getString(_multipleLoginCountryCacheKey),
  ]);

  final cachedLoginMethods = _parseLoginMethods(results[0]);
  final cachedCountries = _parseCountries(results[1]);
  if (cachedLoginMethods.isNotEmpty || cachedCountries.isNotEmpty) {
    onCacheReady(cachedLoginMethods, cachedCountries);
  }
}

List<LoginMethod> _parseLoginMethods(String? raw) {
  if (raw == null || raw.isEmpty) {
    return [];
  }
  try {
    final decoded = json.decode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((e) => LoginMethod.fromJson(e))
          .toList();
    }
  } catch (_) {}
  return [];
}

List<CountryRegisterInfo> _parseCountries(String? raw) {
  if (raw == null || raw.isEmpty) {
    return [];
  }
  try {
    final decoded = json.decode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((e) => CountryRegisterInfo.fromJson(e))
          .toList();
    }
  } catch (_) {}
  return [];
}
