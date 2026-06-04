import 'package:fish_redux/fish_redux.dart';

class ErrorTipState implements Cloneable<ErrorTipState> {
  String? errorMessage = "Page not found"; // 默认错误提示
  String? returnRoute = "/splash"; // 默认返回闪屏

  @override
  ErrorTipState clone() {
    return ErrorTipState()
      ..errorMessage = errorMessage
      ..returnRoute = returnRoute;
  }
}

ErrorTipState initState(Map<String, dynamic>? args) {
  return ErrorTipState();
}
