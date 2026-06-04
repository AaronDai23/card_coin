class StartupTime {
  StartupTime._();

  static int? _coldStartBeginMs;
  static final Set<String> _markedLabels = <String>{};

  static void markAppStartIfNeeded() {
    _coldStartBeginMs ??= DateTime.now().millisecondsSinceEpoch;
    print('[Startup] cold_start_begin_ms=$_coldStartBeginMs');
  }

  static int? elapsedMs() {
    if (_coldStartBeginMs == null) {
      return null;
    }
    return DateTime.now().millisecondsSinceEpoch - _coldStartBeginMs!;
  }

  static void printElapsed(String stage) {
    final elapsed = elapsedMs();
    if (elapsed == null) {
      print('[Startup] $stage elapsed_ms=unavailable (start_not_marked)');
      return;
    }
    print('[Startup] $stage elapsed_ms=$elapsed');
  }

  static void mark(String label) {
    final elapsed = elapsedMs();
    if (elapsed == null) {
      print('[Startup] $label elapsed_ms=unavailable');
      return;
    }
    print('[Startup] $label elapsed_ms=$elapsed');
  }

  static void markOnce(String label) {
    if (!_markedLabels.add(label)) {
      return;
    }
    mark(label);
  }
}
