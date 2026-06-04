import 'dart:convert';

import 'package:card_coin/cache/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 替换为你的LocalStorage

// 登录状态管理工具类
class LoginAuthUtil {
  // 需要登录才能访问的路由白名单
  static final List<String> _needLoginRoutes = [
    'bindEmailPage',
    'updatePasswordPage',
    'cardBaseMainPage',
    // 按需添加其他需要登录的页面
  ];

  // 检查路由是否需要登录
  static bool isRouteNeedLogin(String routeName) {
    return _needLoginRoutes.contains(routeName);
  }

  // 检查是否已登录（根据你的LocalStorage实现）
  static Future<bool> isLogin() async {
    // 替换为你实际的登录状态判断逻辑
    var userInfo = await LocalStorage.getUserInfo();
    return userInfo != null;
  }

  // 记录需要跳转的目标页面（用于登录后自动跳转）
  static Future<void> saveTargetRoute(String routeName,
      {Object? arguments}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('target_route', routeName);
    if (arguments != null) {
      // 如果参数是Map，可转为JSON存储（需引入dart:convert）
      await prefs.setString('target_arguments', jsonEncode(arguments));
    }
  }

  // 获取并清除目标页面
  static Future<Map<String, dynamic>?> getAndClearTargetRoute() async {
    final prefs = await SharedPreferences.getInstance();
    String? routeName = prefs.getString('target_route');
    String? arguments = prefs.getString('target_arguments');

    if (routeName == null) return null;

    // 清除记录，避免重复跳转
    await prefs.remove('target_route');
    await prefs.remove('target_arguments');

    return {
      'routeName': routeName,
      'arguments': arguments != null ? jsonDecode(arguments) : null,
    };
  }
}
