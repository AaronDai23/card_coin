import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
    ConvertDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F5F5),
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text('Convert Detail'),
    ),
    body: state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : state.detail == null
            ? const Center(
                child: Text('No data',
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
              )
            : _DetailBody(detail: state.detail!),
  );
}

class _DetailBody extends StatelessWidget {
  final ConvertDetailInfo detail;

  const _DetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.swap_horiz, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${detail.fromCode} -> ${detail.toCode}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '${detail.fromAmount} ${detail.fromCode}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _statusLabel(detail.status),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(detail.status),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (detail.steps.isNotEmpty)
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Timeline',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Timeline(steps: detail.steps),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                _InfoRow(
                    label: 'From Amount',
                    value: '${detail.fromAmount} ${detail.fromCode}'),
                _InfoRow(
                    label: 'Requested To Amount',
                    value: _withCode(detail.requestedToAmount, detail.toCode)),
                _InfoRow(
                    label: 'Actual To Amount',
                    value: _withCode(detail.actualToAmount, detail.toCode)),
                _InfoRow(
                    label: 'Fee',
                    value: _withCode(detail.fee, detail.feeSymbol)),
                _InfoRow(label: 'Rate', value: detail.rate),
                _InfoRow(label: 'Created At', value: _fmtAt(detail.createdAt)),
                _InfoRow(label: 'Signed At', value: _fmtAt(detail.signedAt)),
                _InfoRow(label: 'On Chain At', value: _fmtAt(detail.onChainAt)),
                _InfoRow(label: 'Gateway At', value: _fmtAt(detail.gatewayAt)),
                _InfoRow(
                    label: 'Fiat Credited At',
                    value: _fmtAt(detail.fiatCreditedAt)),
                _InfoRow(label: 'Tx Hash', value: detail.txHash),
                _InfoRow(
                    label: 'Error Message',
                    value: detail.errorMessage.isEmpty
                        ? 'None'
                        : detail.errorMessage),
                _InfoRow(
                    label: 'Order ID',
                    value: detail.exchangeOrderId,
                    isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (detail.chain.isNotEmpty)
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'On-chain Information',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buildChainRows(detail.chain),
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _withCode(String amount, String code) {
    if (amount.isEmpty) return '—';
    if (code.isEmpty) return amount;
    return '$amount $code';
  }

  List<Widget> _buildChainRows(Map<String, dynamic> chain) {
    const keyOrder = <String>[
      'gasDelegateEnabled',
      'txExplain',
      'delegateTxExplain',
      'txHash',
      'transferTxHash',
      'permitTxHash',
      'delegateRelayerAddress',
      'sinkAddress',
      'tokenContractAddress',
      'transferRecipient',
      'transferAmountWei',
      'sinkAddressMatch',
      'signType',
      'signStatusName',
    ];

    final entries = <MapEntry<String, dynamic>>[];
    for (final key in keyOrder) {
      if (!chain.containsKey(key)) continue;
      entries.add(MapEntry(key, chain[key]));
    }

    final extras = chain.keys.where((k) => !keyOrder.contains(k)).toList()
      ..sort();
    for (final key in extras) {
      entries.add(MapEntry(key, chain[key]));
    }

    return List<Widget>.generate(entries.length, (i) {
      final entry = entries[i];
      return _InfoRow(
        label: _chainLabel(entry.key),
        value: _fmtValue(entry.value),
        isLast: i == entries.length - 1,
      );
    });
  }

  String _chainLabel(String key) {
    switch (key) {
      case 'gasDelegateEnabled':
        return 'Gas Delegate Enabled';
      case 'txExplain':
        return 'Tx Explain';
      case 'delegateTxExplain':
        return 'Delegate Tx Explain';
      case 'txHash':
        return 'Tx Hash';
      case 'transferTxHash':
        return 'Transfer Tx Hash';
      case 'permitTxHash':
        return 'Permit Tx Hash';
      case 'delegateRelayerAddress':
        return 'Delegate Relayer Address';
      case 'sinkAddress':
        return 'Sink Address';
      case 'tokenContractAddress':
        return 'Token Contract Address';
      case 'transferRecipient':
        return 'Transfer Recipient';
      case 'transferAmountWei':
        return 'Transfer Amount Wei';
      case 'sinkAddressMatch':
        return 'Sink Address Match';
      case 'signType':
        return 'Sign Type';
      case 'signStatusName':
        return 'Sign Status';
      default:
        return key;
    }
  }

  String _fmtValue(dynamic value) {
    if (value == null) return '—';
    if (value is bool) return value ? 'true' : 'false';
    final s = value.toString();
    return s.isEmpty ? '—' : s;
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return 'Completed';
      case 'FAILED':
        return 'Failed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFF07C160);
      case 'FAILED':
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _fmtAt(String iso) {
    if (iso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final y = dt.year;
      final mo = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final h = dt.hour.toString().padLeft(2, '0');
      final mi = dt.minute.toString().padLeft(2, '0');
      final s = dt.second.toString().padLeft(2, '0');
      return '$y-$mo-$d $h:$mi:$s';
    } catch (_) {
      return iso;
    }
  }
}

class _Timeline extends StatelessWidget {
  final List<ConvertDetailStep> steps;

  const _Timeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        final status = step.status.toUpperCase();
        final isDone = status == 'DONE' || status == 'COMPLETED';
        final isCurrent = status == 'PROCESSING' || status == 'PENDING';

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 4, left: 6),
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFF07C160)
                            : isCurrent
                                ? Colors.orange
                                : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.only(left: 5, top: 4),
                          color: Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.label.isEmpty ? step.code : step.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDone || isCurrent
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                      if (step.at != null && step.at!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          _fmtAt(step.at!),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _fmtAt(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final y = dt.year;
      final mo = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final h = dt.hour.toString().padLeft(2, '0');
      final mi = dt.minute.toString().padLeft(2, '0');
      final s = dt.second.toString().padLeft(2, '0');
      return '$y-$mo-$d $h:$mi:$s';
    } catch (_) {
      return iso;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}
