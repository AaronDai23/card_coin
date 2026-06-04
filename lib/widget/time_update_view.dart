import 'dart:async';

import 'package:flutter/material.dart';

class TimeUpdateView extends StatefulWidget {
  final String? usd;
  final VoidCallback? timeUpdateBack;
  const TimeUpdateView(this.usd, this.timeUpdateBack, {super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TimeUpdateState();
  }
}

class _TimeUpdateState extends State<TimeUpdateView> {
  late Timer timer;
  bool completed = false;
  int count = 60;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // print("_home second:$count");

      // count = count - 1;
      setState(() {
        count--;
      });
      if (count == 0) {
        count = 60;
        if (widget.timeUpdateBack != null) {
          widget.timeUpdateBack!();
        }
        print("_home _loadCurrencyInfo start");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        widget.usd != null
            ? '≈ \$${(widget.usd)}(${count}s update)'
            : "≈ \$ 0(${count}s update)",
        style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.2));
  }
}
