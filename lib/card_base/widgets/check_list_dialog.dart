import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../global_store/state.dart';
import '../../global_store/store.dart';

class CheckItem {
  String name;
  Widget? icon;
  bool isSelected;

  CheckItem(this.name, {this.icon, this.isSelected = false});
}

class CheckListDialog extends StatefulWidget {
  final List<CheckItem> list;

  const CheckListDialog({super.key, required this.list});

  @override
  State<StatefulWidget> createState() {
    return _CheckListDialogState();
  }
}

class _CheckListDialogState extends State<CheckListDialog> {
  late List<CheckItem> checkList;

  @override
  void initState() {
    checkList = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = GlobalStore.store.getState();
    return AlertDialog(
      title: const Text("Edit networks"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(globalState.languageResource!.cancel)),
        ElevatedButton(
            onPressed: () {
              if (!checkList.any((element) => element.isSelected)) {
                showToast('至少选择一种网络');
                return;
              }
              Navigator.of(context).pop(checkList);
            },
            child: Text(globalState.languageResource!.confirm)),
      ],
      content: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: checkList.length,
          itemBuilder: (context, index) {
            var item = checkList[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  item.isSelected = !item.isSelected;
                });
              },
              child: Card(
                color: const Color(0xFFF1F1F1),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IgnorePointer(
                          ignoring: true,
                          child: Checkbox(
                              value: item.isSelected, onChanged: (value) {})),
                      if (item.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: item.icon!,
                        ),
                      Expanded(child: Text(item.name)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
