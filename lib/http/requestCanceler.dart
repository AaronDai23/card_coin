import 'package:dio/dio.dart';

class RequestCanceler {
  final CancelToken pageToken = CancelToken();
  final List<CancelToken> _tokens = [];

  CancelToken newToken() {
    final token = CancelToken();
    _tokens.add(token);
    return token;
  }

  void cancelAll([String? reason]) {
    for (final t in _tokens) {
      if (!t.isCancelled) {
        t.cancel(reason);
      }
    }
    if (!pageToken.isCancelled) {
      pageToken.cancel(reason);
    }
  }
}
