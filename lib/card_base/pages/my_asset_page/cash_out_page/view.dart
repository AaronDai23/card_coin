import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CashOutState state, Dispatch dispatch, ViewService viewService) {
  final bankInfo = state.bankInfo;
  final feeInfo = state.feeInfo;

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
      title: const Text('Cash Out'),
      actions: [
        IconButton(
          icon: const Icon(Icons.receipt_long_outlined),
          onPressed: () => Navigator.of(viewService.context).pushNamed(
            'cashOutHistoryPage',
            arguments: {'uid': state.uid, 'symbol': state.symbol},
          ),
        ),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── 到账银行卡 ────────────────────────────────────
                _BankCard(
                  bankInfo: bankInfo,
                  isLoading: state.isLoadingBank,
                  onTap: () => dispatch(CashOutActionCreator.onPushBindBank()),
                ),

                const SizedBox(height: 1),

                // ── 提现金额 ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Withdraw Amount',
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            state.symbol,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.inputAmount.isEmpty ? '0' : state.inputAmount,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: state.inputAmount.isEmpty
                                  ? Colors.grey.shade300
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 余额 + 全部提现
                      Row(
                        children: [
                          Text(
                            'Balance: ${state.balance} ${state.symbol}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          if (state.balance.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                dispatch(CashOutActionCreator.onFillAll());
                                dispatch(
                                    CashOutActionCreator.onTriggerFeeLoad());
                              },
                              child: const Text(
                                'All',
                                style: TextStyle(
                                    color: Color(0xFF07C160),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),

                      // ── 手续费详情 ─────────────────────────────
                      if (state.isLoadingFee)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else if (feeInfo != null &&
                          state.inputAmount.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        _FeeRow(
                            label: 'Fee',
                            value: '${feeInfo.fee} ${state.symbol}'),
                        _FeeRow(
                            label: 'Total Deduct',
                            value: '${feeInfo.totalDeduct} ${state.symbol}'),
                        if (!feeInfo.canCashOut)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text('Insufficient balance',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13)),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── 自定义数字键盘 ─────────────────────────────────────────
        _NumPad(
          onKey: (key) {
            String cur = state.inputAmount;
            if (key == '.') {
              if (cur.contains('.')) return;
              if (cur.isEmpty) cur = '0';
              dispatch(CashOutActionCreator.onAmountInput('$cur.'));
              dispatch(CashOutActionCreator.onTriggerFeeLoad());
            } else {
              // max 2 decimal places
              if (cur.contains('.')) {
                final parts = cur.split('.');
                if (parts[1].length >= 2) return;
              }
              if (cur == '0') {
                dispatch(CashOutActionCreator.onAmountInput(key));
              } else {
                dispatch(CashOutActionCreator.onAmountInput('$cur$key'));
              }
              dispatch(CashOutActionCreator.onTriggerFeeLoad());
            }
          },
          onDelete: () {
            final cur = state.inputAmount;
            if (cur.isEmpty) return;
            dispatch(CashOutActionCreator.onAmountInput(
                cur.substring(0, cur.length - 1)));
            dispatch(CashOutActionCreator.onTriggerFeeLoad());
          },
          onConfirm: (state.isSubmitting ||
                  state.isLoadingBank ||
                  (bankInfo != null && !bankInfo.bound) ||
                  state.inputAmount.isEmpty ||
                  (feeInfo != null && !feeInfo.canCashOut))
              ? null
              : () => dispatch(CashOutActionCreator.onSubmit()),
          isSubmitting: state.isSubmitting,
        ),
      ],
    ),
  );
}

// ── 银行卡信息卡片 ────────────────────────────────────────────
class _BankCard extends StatelessWidget {
  final WithdrawBankInfo? bankInfo;
  final bool isLoading;
  final VoidCallback onTap;

  const _BankCard(
      {required this.bankInfo, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: isLoading
            ? const SizedBox(
                height: 44,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
            : Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.account_balance_outlined,
                        color: Colors.blue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: bankInfo == null || !bankInfo!.bound
                        ? Row(children: [
                            const Text('Bank Account',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            const SizedBox(width: 4),
                            const Text('Bind Bank Card',
                                style: TextStyle(
                                    color: Color(0xFF07C160),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bank Account  ${bankInfo!.bankName} (${_lastFour(bankInfo!.cardNoMask)})',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              const Text('Arrives within 2 hours',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
      ),
    );
  }

  String _lastFour(String mask) {
    if (mask.length >= 4) return mask.substring(mask.length - 4);
    return mask;
  }
}

// ── 手续费行 ──────────────────────────────────────────────────
class _FeeRow extends StatelessWidget {
  final String label;
  final String value;

  const _FeeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value,
              style: const TextStyle(color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── 自定义数字键盘 ────────────────────────────────────────────
class _NumPad extends StatelessWidget {
  final Function(String key) onKey;
  final VoidCallback onDelete;
  final VoidCallback? onConfirm;
  final bool isSubmitting;

  const _NumPad({
    required this.onKey,
    required this.onDelete,
    required this.onConfirm,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD1D5DB),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFCBCBCB)),
          // 第一行：1 2 3 ⌫
          SizedBox(
            height: 56,
            child: Row(children: [
              _keyFlex('1'),
              _keyFlex('2'),
              _keyFlex('3'),
              _delKey(),
            ]),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFCBCBCB)),
          // 第 2-4 行 + 右侧「确定」，固定高度避免 IntrinsicHeight+Expanded 失效
          SizedBox(
            height: 170, // 3 × 56px + 2 × 1px 分隔线
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 左侧 3 列
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 56,
                        child: Row(children: [
                          _keyFlex('4'),
                          _keyFlex('5'),
                          _keyFlex('6'),
                        ]),
                      ),
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFFCBCBCB)),
                      SizedBox(
                        height: 56,
                        child: Row(children: [
                          _keyFlex('7'),
                          _keyFlex('8'),
                          _keyFlex('9'),
                        ]),
                      ),
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFFCBCBCB)),
                      SizedBox(
                        height: 56,
                        child: Row(children: [
                          _keyFlex('.'),
                          _keyFlex('0'),
                          Expanded(
                              child:
                                  ColoredBox(color: const Color(0xFFEEF0F3))),
                        ]),
                      ),
                    ],
                  ),
                ),
                // 垂直分隔线
                Container(width: 1, color: const Color(0xFFCBCBCB)),
                // 右侧「确定」
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: GestureDetector(
                    onTap: onConfirm,
                    behavior: HitTestBehavior.opaque,
                    child: ColoredBox(
                      color: onConfirm != null
                          ? const Color(0xFF07C160)
                          : const Color(0xFF86D6A3),
                      child: Center(
                        child: isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text(
                                'Confirm',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyFlex(String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onKey(label),
        behavior: HitTestBehavior.opaque,
        child: ColoredBox(
          color: const Color(0xFFEEF0F3),
          child: Center(
            child: Text(label,
                style: const TextStyle(fontSize: 22, color: Colors.black87)),
          ),
        ),
      ),
    );
  }

  Widget _delKey() {
    return Expanded(
      child: GestureDetector(
        onTap: onDelete,
        behavior: HitTestBehavior.opaque,
        child: const ColoredBox(
          color: Color(0xFFEEF0F3),
          child: Center(
            child:
                Icon(Icons.backspace_outlined, size: 22, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
