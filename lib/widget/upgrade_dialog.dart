import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:ota_update/ota_update.dart';

class UpgradeDialog extends StatefulWidget {
  final String apkUrl;

  const UpgradeDialog(this.apkUrl, {super.key});

  @override
  State<StatefulWidget> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  StreamSubscription<OtaEvent>? _subscription;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    progress = 0;
    _download(widget.apkUrl);
  }

  void _download(String url) {
    _subscription?.cancel();
    _subscription = OtaUpdate().execute(url).listen(
      (OtaEvent event) {
        switch (event.status) {
          case OtaStatus.DOWNLOADING:
            final value = double.tryParse(event.value ?? '') ?? 0;
            if (!mounted) return;
            setState(() {
              progress = (value / 100).clamp(0.0, 1.0);
            });
            break;
          case OtaStatus.INSTALLING:
          case OtaStatus.INSTALLATION_DONE:
            if (mounted) Navigator.pop(context);
            break;
          case OtaStatus.ALREADY_RUNNING_ERROR:
          case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
          case OtaStatus.INTERNAL_ERROR:
          case OtaStatus.DOWNLOAD_ERROR:
          case OtaStatus.CHECKSUM_ERROR:
          case OtaStatus.CANCELED:
          case OtaStatus.INSTALLATION_ERROR:
            showToast('Upgrade fail');
            if (mounted) Navigator.pop(context);
            break;
        }
      },
      onError: (_) {
        showToast('Upgrade fail');
        if (mounted) Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
        ),
        Text(
            '${NumUtil.getNumByValueDouble(progress * 100, 2).toString()}% downloaded'),
      ],
    );
  }
}
