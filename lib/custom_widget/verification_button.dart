import 'dart:async';

import 'package:flutter/material.dart';

import '../global_store/state.dart';
import '../global_store/store.dart';
import 'custom_button.dart';

class VerificationButton extends StatefulWidget {
  final Function? onSendClick;
  final String text;
  final VerificationController controller;
  const VerificationButton(this.text,
      {super.key, this.onSendClick, required this.controller});

  @override
  State<StatefulWidget> createState() => VerificationButtonState();
}

class VerificationButtonState extends State<VerificationButton>
    implements CountDownInterface {
  Timer? _timer;
  int _countdownTime = 0;

  @override
  void initState() {
    widget.controller.initController(this);
    super.initState();
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime < 1) {
          _timer?.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = GlobalStore.store.getState();
    return CCButton(
      color: Colors.black,
      onPressed: _countdownTime > 0
          ? null
          : () {
              if (widget.onSendClick != null) {
                widget.onSendClick?.call();
              }
            },
      verticalPadding: 6,
      child: Text(_countdownTime > 0
          ? globalState.languageResource!
              .getCountDown(_countdownTime.toString())
          : widget.text),
    );
  }

  @override
  void cancelCountdown() {
    setState(() {
      _countdownTime = 0;
    });
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
  }

  @override
  void startCountdown() {
    setState(() {
      _countdownTime = 60;
    });
    startCountdownTimer();
  }
}

abstract class CountDownInterface {
  void startCountdown();
  void cancelCountdown();
}

class VerificationController {
  CountDownInterface? _countDownInterface;
  VerificationController();
  void startCountdown() {
    _countDownInterface?.startCountdown();
  }

  void cancelCountdown() {
    _countDownInterface?.cancelCountdown();
  }

  void initController(CountDownInterface countDownInterface) {
    _countDownInterface = countDownInterface;
  }
}
