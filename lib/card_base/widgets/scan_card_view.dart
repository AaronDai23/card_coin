import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';
import '../../global_store/store.dart';

class ScanCardView extends StatelessWidget {
  final VoidCallback? onCancelClick;

  const ScanCardView({Key? key, this.onCancelClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var globalState = GlobalStore.store.getState();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(30.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          child: Column(
            children: [
              Text(
                globalState.languageResource!.alreadyScan,
                style: const TextStyle(fontSize: 30.0, color: Colors.grey),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: LoadAssetImage(
                  '1/nfc_scan',
                  width: 100,
                  height: 100,
                ),
              ),
              Text(globalState.languageResource!.scanTips),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onPressed: onCancelClick,
                  child:
                      Center(child: Text(globalState.languageResource!.cancel)))
            ],
          ),
        ),
      ],
    );
  }
}
