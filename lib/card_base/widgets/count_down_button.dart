import 'dart:async';

import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:flutter/material.dart';

class CountDownButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final int count;
  final Color? backgroundColor;
  const CountDownButton({super.key, this.onPressed, required this.text,this.count = 15,this.backgroundColor});

  @override
  State<StatefulWidget> createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton> {
  late Timer timer;
  bool completed = false;
  late int count;


  @override
  void initState() {
    count = widget.count;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (count == 1) {
          completed = true;
        } else {
          count--;
        }
      });
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
    if(widget.backgroundColor != null){
      return CCButton(
        onPressed: completed ? widget.onPressed : null,
        child: Text(
          completed ? widget.text : '${widget.text}($count)',
          // style: TextStyle(color: Colors.grey[800]),
        ),
      );
    }else{
      return TextButton(
        onPressed: completed ? widget.onPressed : null,
        child: Text(
          completed ? widget.text : '${widget.text}($count)',
          // style: TextStyle(color: Colors.grey[800]),
        ),
      );
    }

  }
}
