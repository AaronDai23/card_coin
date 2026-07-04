import 'dart:async';

import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ConvertHistoryState state, Dispatch dispatch, ViewService viewService) {
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
      title: const Text('Convert History'),
    ),
    body: RefreshIndicator(
      onRefresh: () async {
        final completer = Completer<void>();
        dispatch(
            ConvertHistoryActionCreator.onLoadHistory(completer: completer));
        await completer.future;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 80 &&
              state.rows.isNotEmpty &&
              state.hasMore &&
              !state.isLoading) {
            dispatch(ConvertHistoryActionCreator.onLoadMore());
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.rows.isEmpty
              ? 1
              : state.rows.length + (state.hasMore && state.isLoading ? 1 : 0),
          separatorBuilder: (_, __) => state.rows.isEmpty
              ? const SizedBox.shrink()
              : const Divider(height: 1, indent: 72, endIndent: 16),
          itemBuilder: (context, index) {
            if (state.rows.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'No records',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                ),
              );
            }

            if (index == state.rows.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            final item = state.rows[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pushNamed(
                'convertDetailPage',
                arguments: {
                  'uid': state.uid,
                  'exchangeOrderId': item.exchangeOrderId,
                },
              ),
              child: _HistoryCell(item: item),
            );
          },
        ),
      ),
    ),
  );
}

class _HistoryCell extends StatelessWidget {
  final ConvertHistoryItem item;

  const _HistoryCell({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);
    final pair = '${item.fromCode} -> ${item.toCode}';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.swap_horiz, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(item.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _statusLabel(item.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- ${item.fromAmount} ${item.fromCode}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+ ${item.toAmount} ${item.toCode}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
      case 'FAILED':
      case 'CANCELLED':
        return Colors.red;
      case 'CREATE':
      case 'SIGNED':
      case 'ON_CHAIN':
      case 'GATEWAY_SELL':
      case 'PENDING':
      case 'PROCESSING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return 'Completed';
      case 'FAILED':
        return 'Failed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'CREATE':
      case 'SIGNED':
      case 'ON_CHAIN':
      case 'GATEWAY_SELL':
      case 'PENDING':
      case 'PROCESSING':
        return 'Processing';
      default:
        return status;
    }
  }
}
