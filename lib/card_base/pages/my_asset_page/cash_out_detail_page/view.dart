import 'dart:async';

import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CashOutDetailState state, Dispatch dispatch, ViewService viewService) {
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
      title: const Text('Cash Out Detail'),
    ),
    body: RefreshIndicator(
      onRefresh: () async {
        final completer = Completer<void>();
        dispatch(CashOutDetailActionCreator.onLoadDetail(completer: completer));
        await completer.future;
      },
      child: state.detail != null
          ? _DetailBody(detail: state.detail!)
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(viewService.context).size.height * 0.7,
                  child: Center(
                    child: state.isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'No data',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                  ),
                ),
              ],
            ),
    ),
  );
}

// ── 详情主体 ──────────────────────────────────────────────────
class _DetailBody extends StatelessWidget {
  final CashOutDetailInfo detail;
  const _DetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    final last4 = detail.cardNoMask.length >= 4
        ? detail.cardNoMask.substring(detail.cardNoMask.length - 4)
        : detail.cardNoMask;
    final title = 'Cash Out → ${detail.bankName} (****$last4)';

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // ── 顶部图标 + 标题 + 金额 ───────────────────────────
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
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '¥',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '${detail.symbol} ${detail.amount}',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── 时间线 ────────────────────────────────────────────
          if (detail.timeline.isNotEmpty)
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Status',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  _Timeline(steps: detail.timeline),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // ── 信息明细 ──────────────────────────────────────────
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                _InfoRow(
                    label: 'Amount',
                    value: '${detail.symbol} ${detail.amount}'),
                _InfoRow(label: 'Fee', value: '${detail.symbol} ${detail.fee}'),
                _InfoRow(
                    label: 'Submitted',
                    value: _fmtAt(detail.timeline
                        .firstWhere(
                          (t) => t.code == 'SUBMITTED',
                          orElse: () => CashOutDetailTimeline(
                              code: '', label: '', at: null),
                        )
                        .at)),
                _InfoRow(
                    label: 'Completed',
                    value: _fmtAt(detail.timeline
                        .firstWhere(
                          (t) => t.code == 'COMPLETED',
                          orElse: () => CashOutDetailTimeline(
                              code: '', label: '', at: null),
                        )
                        .at)),
                _InfoRow(
                    label: 'Bank', value: '${detail.bankName} (****$last4)'),
                _InfoRow(
                    label: 'Cardholder',
                    value: detail.bankCardHolder,
                    isLast: false),
                _InfoRow(
                    label: 'Order ID',
                    value: detail.cashOutAuditId,
                    isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _fmtAt(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
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

// ── 时间线组件 ────────────────────────────────────────────────
class _Timeline extends StatelessWidget {
  final List<CashOutDetailTimeline> steps;
  const _Timeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        final isDone = step.at != null && step.at!.isNotEmpty;
        final isFinalDone = isLast && isDone && step.code == 'COMPLETED';

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 左侧节点 + 连接线 ──────────────────────
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    isFinalDone
                        ? Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFF07C160),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check,
                                color: Colors.white, size: 16),
                          )
                        : Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(top: 4, left: 6),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFF07C160)
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: EdgeInsets.only(
                              left: isFinalDone ? 11 : 5, top: 4),
                          color: Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // ── 右侧文字 ───────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: isFinalDone ? 2 : 4, bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDone ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      if (step.at != null && step.at!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          _fmtAt(step.at),
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

  String _fmtAt(String? iso) {
    if (iso == null || iso.isEmpty) return '';
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

// ── 信息行 ────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow(
      {required this.label, required this.value, this.isLast = false});

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
                width: 100,
                child: Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
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
