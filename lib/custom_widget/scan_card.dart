import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';
// import 'package:is_lock_screen2/is_lock_screen2.dart';

class ScanCard extends StatefulWidget {
  final VoidCallback? onCancel;

  final AppLanguageResource? appLanguageResource;

  const ScanCard({super.key, this.onCancel, this.appLanguageResource});

  @override
  State<StatefulWidget> createState() => _ScanCardState();
}

class _ScanCardState extends State<ScanCard> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToAppLifecycle();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _listenToAppLifecycle() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.inactive) {
    //   if(!_isLockScreen){
    //     isLockScreen().then((value) {
    //       print('=========state: inactive , _isLockScreen:$value');
    //       _isLockScreen = value??false;

    //     });
    //   }

    // } else if (state == AppLifecycleState.resumed) {
    //   print('=========state: resumed , _isLockScreen:$_isLockScreen');
    //   if(_isLockScreen){
    //     Navigator.of(context).pop();
    //   }

    // }
  }

  @override
  Widget build(BuildContext context) {
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
                '${widget.appLanguageResource?.readyToScan}',
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
              Text('${widget.appLanguageResource?.scanTips}'),
              const SizedBox(
                height: 20.0,
              ),
              if (widget.onCancel != null)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onPressed: widget.onCancel,
                    child: Center(
                        child: Text('${widget.appLanguageResource?.cancel}')))
            ],
          ),
        ),
      ],
    );
  }
}
