import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:update_app/bean/download_process.dart';
import 'package:update_app/update_app.dart';



class UpgradeDialog extends StatefulWidget{
  final String apkUrl;


  const UpgradeDialog(this.apkUrl, {super.key});

  @override
  State<StatefulWidget> createState() => _UpgradeDialogState();

}

class _UpgradeDialogState extends State<UpgradeDialog>{

  Timer? timer;
  double progress = 0;

  @override
  void initState() {
    progress = 0;
    _download(widget.apkUrl);
    super.initState();
  }

  void _download(String url) async {
    var downloadId = await UpdateApp.updateApp(
        url: url,
        appleId: "375380948");

    //本地已有一样的apk, 下载成功
    if (downloadId == 0) {
      print('download success');
      // setState(() {
      //   downloadProcess = 1;
      //   downloadStatus = ProcessState.STATUS_SUCCESSFUL.toString();
      // });
      showToast('Download successful');
      Navigator.pop(context);
      return;
    }

    //出现了错误, 下载失败
    if (downloadId == -1) {
      print('download failure');
      showToast('Download fail');
      Navigator.pop(context);
      // setState(() {
      //   downloadProcess = 1;
      //   downloadStatus = ProcessState.STATUS_FAILED.toString();
      // });
      return;
    }


    //正在下载文件
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      try{
        var process = await UpdateApp.downloadProcess(downloadId: downloadId);
        setState(() {
          progress = process.current / process.count;
          if(progress < 0){
            progress = 0;
          }
          if (process.status == ProcessState.STATUS_SUCCESSFUL ||
              process.status == ProcessState.STATUS_FAILED) {
            //如果已经下载成功, 取消计时
            timer.cancel();
            Navigator.pop(context);
          }
        });
      }catch(error){
        timer.cancel();
        showToast('Upgrade fail');
        Navigator.pop(context);
      }

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LinearProgressIndicator(
        value: progress,
      ),
      Text('${NumUtil.getNumByValueDouble(progress*100, 2).toString()}% downloaded'),

    ],);
  }

}