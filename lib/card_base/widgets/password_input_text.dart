import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';

class PasswordInputText extends StatefulWidget {
  final String placeholder;
  final TextEditingController? textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isAName;
  final bool isAPhone;
  final int? maxLength;
  final int? minLength;
  final void Function(String)? onChanged;
  final bool? validation;
  final bool enabled;
  final Color? backgroundColor;
  final bool obscureText;

  const PasswordInputText({
    super.key,
    this.placeholder = '',
    this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isAName = false,
    this.isAPhone = false,
    this.maxLength,
    this.minLength,
    this.onChanged,
    this.validation,
    this.enabled = true,
    this.backgroundColor,
    this.obscureText = false,
  });

  @override
  _PasswordInputTextState createState() => _PasswordInputTextState();
}

class _PasswordInputTextState extends State<PasswordInputText> {
  late bool dontShow;
  bool emailValid = true;

  @override
  void initState() {
    dontShow = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //If the atribute isPassword is true, the padding right will be 0
      padding: const EdgeInsets.only(right: 0),
      // the attribute onfocusColor will change the primary color of the textField
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.textController,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  obscureText: dontShow,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      hintText: widget.placeholder,
                      counterText: ''),
                ),
              ),
              // this is the show or hide password button
              IconButton(
                  icon: dontShow
                      ? const LoadAssetImage(
                          'eyes0',
                          width: 24,
                          height: 24,
                          color: Colors.black,
                        )
                      : const LoadAssetImage(
                          'eyes1',
                          width: 24,
                          height: 24,
                          color: Colors.black,
                        ),
                  onPressed: () {
                    setState(() {
                      dontShow = !dontShow;
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }
}

// this method verifies that the email complies with the standards
bool validateEmail(String email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (regExp.hasMatch(email)) {
    return true;
  } else {
    return false;
  }
}
