import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';

class MessageBellWidget extends StatelessWidget {
  final int unReadCount;
  final VoidCallback? onTap;
  final Color? color;
  const MessageBellWidget(
      {Key? key, this.unReadCount = 0, this.onTap, this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              LoadAssetImage('bell', width: 26, height: 26, color: color),
              Visibility(
                visible: unReadCount > 0,
                child: Positioned(
                  top: 5,
                  right: 2,
                  child: Container(
                    height: 16,
                    constraints: const BoxConstraints(minWidth: 16),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(32)),
                    child: Center(
                      child: Text(
                        unReadCount.toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
