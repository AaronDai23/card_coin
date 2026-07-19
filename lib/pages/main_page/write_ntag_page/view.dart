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
      title: const Text('Write NTAG213'),
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
                'Domain / browsers come from My Card config. '
                'UID is read when you scan the NTAG, then written in the same tap.',
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
                title: 'Scanned UID',
                value: state.scannedUid.isEmpty
                    ? 'Not scanned yet — tap Scan & Write'
                    : state.scannedUid,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Full NDEF URL',
                value: state.fullNdefUrl.isEmpty
                    ? 'Built after scan: domain + uid=/Base64(UID)'
                    : state.fullNdefUrl,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lock after write'),
                subtitle: const Text(
                  'Permanent read-only. Cannot be unlocked later.',
                ),
                value: state.lockAfterWrite,
                onChanged: state.isScanning
                    ? null
                    : (v) =>
                        dispatch(WriteNtagActionCreator.onUpdateLock(v)),
              ),
              const SizedBox(height: 16),
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
