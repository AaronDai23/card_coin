
import 'package:app_links/app_links.dart';
import 'package:fish_redux/fish_redux.dart';


class SplashState implements Cloneable<SplashState> {
  // 1. 初始化 app_links（处理 https 链接）
  final AppLinks appLinks = AppLinks();

  @override
  SplashState clone() {
    return SplashState();
  }
}

SplashState initState(Map<String, dynamic>? args) {
  return SplashState();
}
