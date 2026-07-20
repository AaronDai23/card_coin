import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/utils/ntag_ndef_writer.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    WriteNtagState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (state.isScanning) {
            dispatch(WriteNtagActionCreator.onCancelScan());
          }
          Navigator.of(viewService.context).pop();
        },
      ),
      title: const Text('NTAG Write / Decode'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: state.isScanning
              ? null
              : () => dispatch(WriteNtagActionCreator.onLoadConfig()),
        ),
      ],
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () => dispatch(WriteNtagActionCreator.onLoadConfig()),
      onLoadSuccess: () {
        final packages = NtagNdefWriter.parseAarPackages(state.ndefAAR);
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '写入：识别 213/215 → 若已有密码则弹窗输入 → 鉴权解锁 → 重写 URL+包名 → 可选再加写保护\n'
                '解码：读回型号 / UID / URL / uid Base64 / AAR 包名\n'
                '密码写保护可再次鉴权改写；不是永久锁定。',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: 'Domain (ndefDomain)',
                value: state.domainUrl,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Browsers (ndefAAR)',
                value: packages.isEmpty
                    ? '(empty)'
                    : packages
                        .asMap()
                        .entries
                        .map((e) => '${e.key + 1}. ${e.value}')
                        .join('\n'),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Chip model',
                value: state.chipModel.isEmpty
                    ? 'Detected on scan (213 / 215 / 216)'
                    : state.chipModel,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Scanned UID',
                value: state.scannedUid.isEmpty
                    ? 'From tag on Scan & Write / Decode'
                    : state.scannedUid,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Full NDEF URL',
                value: state.fullNdefUrl.isEmpty
                    ? 'domain + uid=/Base64(UID)'
                    : state.fullNdefUrl,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Write password (hex)',
                value: NtagNdefWriter.defaultPasswordHex,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Password write-protect'),
                subtitle: const Text(
                  'Read/open URL free; rewrite needs password. Reversible.',
                ),
                value: state.passwordProtect,
                onChanged: state.isScanning
                    ? null
                    : (v) => dispatch(
                          WriteNtagActionCreator.onUpdatePasswordProtect(v),
                        ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isScanning || state.domainUrl.isEmpty
                      ? null
                      : () =>
                          dispatch(WriteNtagActionCreator.onStartWrite()),
                  child: Text(
                    state.isScanning ? 'Waiting for tag…' : 'Scan & Write',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: state.isScanning
                      ? null
                      : () =>
                          dispatch(WriteNtagActionCreator.onStartDecode()),
                  child: const Text('Scan & Decode'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '解码流程\n'
                '1. 贴卡 → GET_VERSION 识别 213/215/216\n'
                '2. 读标签 UID\n'
                '3. NDEF.read 解析 URI 记录 → 完整 URL\n'
                '4. 从 URL 的 uid= 参数 Base64 还原出 UID 十六进制\n'
                '5. 解析 android.com:pkg 外部记录 → 浏览器包名列表',
                style: TextStyle(color: Colors.black45, fontSize: 12, height: 1.4),
              ),
              if (state.statusMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.statusMessage,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    ),
  );
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
