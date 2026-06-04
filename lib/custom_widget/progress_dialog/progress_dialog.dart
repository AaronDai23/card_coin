import 'package:card_coin/custom_widget/progress_dialog/wave.dart';
import 'package:flutter/material.dart';

enum ProgressDialogType { Normal, Download }

bool _showLogs = false;

Curve _insetAnimCurve = Curves.easeInOut;

class ProgressDialog {
  ProgressDialog(this._context,
      {bool? isDismissible, bool? showLogs, Widget? customBody})
      : _barrierDismissible = isDismissible ?? false,
        _customBody = customBody {
    _showLogs = showLogs ?? false;
  }

  final BuildContext _context;
  final bool _barrierDismissible;
  final Widget? _customBody;

  late _Body _dialog;
  bool _isShowing = false;
  bool _dismissWhenShown = false;
  BuildContext? _dismissingContext;

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _dismissWhenShown = true;
        _dismissDialogIfPossible();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  Future<bool> showNoMask() async {
    try {
      if (!_isShowing) {
        _isShowing = true;
        _dismissWhenShown = false;
        _dialog = _Body();
        showDialog<dynamic>(
          context: _context,
          barrierColor: Colors.transparent,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            if (_dismissWhenShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _dismissDialogIfPossible();
              });
            }
            return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: _customBody ?? _createContent(_dialog),
            );
          },
        ).then((_) {
          _isShowing = false;
          _dismissWhenShown = false;
          _dismissingContext = null;
        });

        if (_showLogs) debugPrint('ProgressDialog shown');
        return true;
      } else {
        if (_showLogs) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }

  Future<bool> show() async {
    try {
      if (!_isShowing) {
        _isShowing = true;
        _dismissWhenShown = false;
        _dialog = _Body(
          onDisposed: () {
            _isShowing = false;
            _dismissWhenShown = false;
            _dismissingContext = null;
          },
        );
        showDialog<dynamic>(
          context: _context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            if (_dismissWhenShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _dismissDialogIfPossible();
              });
            }
            return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: _customBody ?? _createContent(_dialog),
            );
          },
        ).then((_) {
          _isShowing = false;
          _dismissWhenShown = false;
          _dismissingContext = null;
        });

        if (_showLogs) debugPrint('ProgressDialog shown');
        return true;
      } else {
        if (_showLogs) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }

  void _dismissDialogIfPossible() {
    final dismissingContext = _dismissingContext;
    if (dismissingContext == null) {
      return;
    }
    if (!Navigator.of(dismissingContext).canPop()) {
      return;
    }
    Navigator.of(dismissingContext).pop();
  }
}

Widget _createContent(Widget dialog) {
  return UnconstrainedBox(
    child: SizedBox(
      width: 80.0,
      height: 80.0,
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          insetPadding: EdgeInsets.zero,
          insetAnimationCurve: _insetAnimCurve,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: dialog),
    ),
  );
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _Body({this.onDisposed});

  final VoidCallback? onDisposed;
  final _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.onDisposed?.call();
    if (_showLogs) debugPrint('ProgressDialog dismissed by back button');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0),
      child: SpinKitWave(
        color: Colors.black,
        size: 30.0,
        itemCount: 6,
      ),
    );
  }
}

class DialogRouter extends PageRouteBuilder {
  final Widget page;

  DialogRouter(this.page)
      : super(
          opaque: false,
          barrierColor: const Color(0x00000001),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
        );
}
