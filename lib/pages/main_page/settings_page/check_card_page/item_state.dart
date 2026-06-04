import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

class HealthCheckItemState implements Cloneable<HealthCheckItemState> {
  late HealthCheckInfo bean;
  LoadType loadType = LoadType.loading;
  String errorMsg = '';
  bool isSelected = false;

  @override
  HealthCheckItemState clone() {
    return HealthCheckItemState()
      ..loadType = loadType
      ..errorMsg = errorMsg
      ..isSelected = isSelected
      ..bean = bean;
  }
}
