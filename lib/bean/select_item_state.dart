import 'package:fish_redux/fish_redux.dart';

abstract class SelectItemState<T> implements  Cloneable<SelectItemState>{
  late bool isSelected;
  late T bean;
}

