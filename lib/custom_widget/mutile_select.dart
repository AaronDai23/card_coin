import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:flutter/material.dart';

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    AppLanguageResource languageResource =
        GlobalStore.store.getState().languageResource!;
    return AlertDialog(
      title: Text(languageResource.scanCarInitialization),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10.0, // 控制点的大小
                            height: 10.0,
                            decoration: const BoxDecoration(
                              color: Colors.black, // 点的颜色
                              shape: BoxShape.circle, // 形状设置为圆形
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(item)
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: _cancel,
          child: Text(languageResource.cancel),
        ),
        const SizedBox(width: 20,),
        ElevatedButton(
          onPressed: _submit,
          child: Text(languageResource.scanCard),
        ),
      ],
    );
  }
}
