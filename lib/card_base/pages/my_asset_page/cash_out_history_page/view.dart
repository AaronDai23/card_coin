import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CashOutHistoryState state, Dispatch dispatch, ViewService viewService) {
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
      title: const Text('Cash Out History'),
    ),
    body: state.isLoading && state.rows.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : state.rows.isEmpty
            ? const Center(
                child: Text('No records',
                    style: TextStyle(color: Colors.grey, fontSize: 15)))
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 80 &&
                      state.hasMore &&
                      !state.isLoading) {
                    dispatch(CashOutHistoryActionCreator.onLoadMore());
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.rows.length +
                      (state.hasMore && state.isLoading ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72, endIndent: 16),
                  itemBuilder: (context, index) {
                    if (index == state.rows.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    final item = state.rows[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pushNamed(
                        'cashOutDetailPage',
                        arguments: {
                          'uid': state.uid,
                          'cashOutAuditId': item.cashOutAuditId,
                        },
                      ),
                      child: _HistoryCell(item: item, symbol: state.symbol),
                    );
                  },
                ),
              ),
  );
}

// ── 单元格 ────────────────────────────────────────────────────
class _HistoryCell extends StatelessWidget {
  final CashOutHistoryItem item;
  final String symbol;

  const _HistoryCell({required this.item, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final last4 = item.cardNoMask.length >= 4
        ? item.cardNoMask.substring(item.cardNoMask.length - 4)
        : item.cardNoMask;
    final title = 'Cash Out → ${item.bankName} (****$last4)';
    final dateStr = _formatDate(item.submittedAt);
    final statusColor = _statusColor(item.status);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // ── 左侧圆形图标 ─────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFFC107),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '¥',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ── 中间标题 + 日期 ──────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateStr,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _statusLabel(item.status),
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ── 右侧金额 ─────────────────────────────
          Text(
            item.amount,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';
    } catch (_) {
      return iso;
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFF07C160);
      case 'REJECTED':
      case 'CANCELLED':
        return Colors.red;
      case 'AUDITING':
      case 'APPROVED':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'AUDITING':
        return 'Reviewing';
      case 'APPROVED':
        return 'Processing';
      case 'COMPLETED':
        return 'Completed';
      case 'REJECTED':
        return 'Rejected';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
