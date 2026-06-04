import 'package:fish_redux/fish_redux.dart';

class HtmlTextState implements Cloneable<HtmlTextState> {
  String? title;
  String? textContent;

  @override
  HtmlTextState clone() {
    return HtmlTextState()
      ..title = title
      ..textContent = textContent;
  }
}

HtmlTextState initState(Map<String, dynamic>? args) {
  String title = args!['title'];
  String textContent = args['textContent'];
  return HtmlTextState()
    ..title = title
    ..textContent = textContent;
}
