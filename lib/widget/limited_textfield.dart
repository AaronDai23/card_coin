import 'package:flutter/material.dart';

class LimitedTextField extends StatefulWidget {
  final int maxLength;
  final int? maxLine;
  final TextEditingController controller;

  const LimitedTextField(
      {Key? key,
      required this.maxLength,
      required this.controller,
      this.maxLine})
      : super(key: key);

  @override
  _LimitedTextFieldState createState() => _LimitedTextFieldState();
}

class _LimitedTextFieldState extends State<LimitedTextField> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _charCount = widget.controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          maxLength: widget.maxLength,
          maxLines: widget.maxLine ?? 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '$_charCount/${widget.maxLength}',
          ),
        ),
      ],
    );
  }
}
