import 'dart:async';

import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ExchangeState state, Dispatch dispatch, ViewService viewService) {
  final from = state.selectedFrom;
  final to = state.selectedTo;

  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text('Exchange'),
      actions: [
        IconButton(
          tooltip: 'Convert History',
          onPressed: () {
            Navigator.of(viewService.context).pushNamed(
              'convertHistoryPage',
              arguments: {'uid': state.uid},
            );
          },
          icon: const Icon(Icons.history),
        ),
      ],
    ),
    body: state.isLoadingFrom
        ? const Center(child: CircularProgressIndicator())
        : state.fromList.isEmpty
            ? const Center(
                child: Text('No available currencies',
                    style: TextStyle(color: Colors.grey)))
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    // ── From card ─────────────────────────────────
                    _AmountCard(
                      label: 'From',
                      currencyIcon: from?.imageUrl ?? '',
                      currencyCode: from?.code ?? '',
                      onCurrencyTap: () async {
                        final index =
                            await _showFromPicker(viewService.context, state);
                        if (index != null) {
                          dispatch(ExchangeActionCreator.onSelectFrom(index));
                        }
                      },
                      amount: state.inputAmount,
                      onMinus: () =>
                          dispatch(ExchangeActionCreator.onStepFrom(-1)),
                      onPlus: () =>
                          dispatch(ExchangeActionCreator.onStepFrom(1)),
                      onAmountInput: (v) {
                        dispatch(ExchangeActionCreator.onAmountChanged(
                            v.isEmpty ? '0' : v));
                        dispatch(ExchangeActionCreator.onRequestPreview());
                      },
                      subLabel: 'Available:${from?.balance ?? ''}',
                      onAll: () =>
                          dispatch(ExchangeActionCreator.onSetAllFrom()),
                    ),

                    const SizedBox(height: 12),

                    // ── Convert rate ──────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Convert rate',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13)),
                          if (state.isLoadingRate)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.rate.isNotEmpty
                                      ? '1 ${from?.code ?? ''} = ${state.rate} ${to?.code ?? ''}'
                                      : '--',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black87),
                                ),
                                if (state.rate.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  _CountdownTimer(
                                    totalSeconds: 30,
                                    rateUpdatedAt: state.rateUpdatedAt,
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── To card ───────────────────────────────────
                    if (state.isLoadingTo)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      )
                    else if (state.toList.isNotEmpty)
                      _AmountCard(
                        label: 'To',
                        currencyIcon: to?.imageUrl ?? '',
                        currencyCode: to?.code ?? '',
                        onCurrencyTap: () async {
                          final index =
                              await _showToPicker(viewService.context, state);
                          if (index != null) {
                            dispatch(ExchangeActionCreator.onSelectTo(index));
                          }
                        },
                        amount: state.estimatedToAmount.isEmpty
                            ? '0'
                            : state.estimatedToAmount,
                        onMinus: () =>
                            dispatch(ExchangeActionCreator.onStepTo(-1)),
                        onPlus: () =>
                            dispatch(ExchangeActionCreator.onStepTo(1)),
                        subLabel: 'Max convertible:${to?.maxConvertible ?? ''}',
                        onAll: () =>
                            dispatch(ExchangeActionCreator.onSetAllTo()),
                      ),

                    // ── Preview card ─────────────────────────────
                    if (state.estimatedToAmount.isNotEmpty ||
                        state.isLoadingPreview)
                      _PreviewCard(
                        toCode: to?.code ?? '',
                        initialAmount: state.previewEstimated.isNotEmpty
                            ? state.previewEstimated
                            : state.estimatedToAmount,
                        feeDisplay: state.previewFeeDisplay,
                        receiveAmount: state.previewReceived,
                        isLoading: state.isLoadingPreview,
                      ),

                    const SizedBox(height: 32),

                    // ── Submit button ─────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (state.isSubmitting ||
                                state.isLoadingRate ||
                                state.toList.isEmpty)
                            ? null
                            : () => dispatch(ExchangeActionCreator.onSubmit()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Convert',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
  );
}

Future<int?> _showFromPicker(BuildContext context, ExchangeState state) {
  return showModalBottomSheet<int>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => ListView.builder(
      itemCount: state.fromList.length,
      itemBuilder: (itemContext, i) {
        final item = state.fromList[i];
        return ListTile(
          leading: item.imageUrl.isNotEmpty
              ? LoadImage(item.imageUrl, width: 32, height: 32)
              : null,
          title: Text(item.code,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle:
              Text(item.balance, style: const TextStyle(color: Colors.grey)),
          onTap: () {
            Navigator.of(sheetContext).pop(i);
          },
        );
      },
    ),
  );
}

Future<int?> _showToPicker(BuildContext context, ExchangeState state) {
  return showModalBottomSheet<int>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => ListView.builder(
      itemCount: state.toList.length,
      itemBuilder: (itemContext, i) {
        final item = state.toList[i];
        return ListTile(
          leading: item.imageUrl.isNotEmpty
              ? LoadImage(item.imageUrl, width: 32, height: 32)
              : null,
          title: Text(item.code,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          onTap: () {
            Navigator.of(sheetContext).pop(i);
          },
        );
      },
    ),
  );
}

// ────────────────────────────────────────────────────────────

class _AmountCard extends StatefulWidget {
  final String label;
  final String currencyIcon;
  final String currencyCode;
  final VoidCallback onCurrencyTap;
  final String amount;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final String subLabel;
  final VoidCallback onAll;
  final ValueChanged<String>? onAmountInput;

  const _AmountCard({
    required this.label,
    required this.currencyIcon,
    required this.currencyCode,
    required this.onCurrencyTap,
    required this.amount,
    required this.onMinus,
    required this.onPlus,
    required this.subLabel,
    required this.onAll,
    this.onAmountInput,
  });

  @override
  State<_AmountCard> createState() => _AmountCardState();
}

class _AmountCardState extends State<_AmountCard> {
  late TextEditingController _controller;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _toFieldText(widget.amount));
    _focus = FocusNode();
  }

  @override
  void didUpdateWidget(_AmountCard old) {
    super.didUpdateWidget(old);
    if (old.amount != widget.amount) {
      final newText = widget.onAmountInput != null
          ? _toFieldText(widget.amount)
          : _formatAmount(widget.amount);
      if (_controller.text != newText) {
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// 可编辑时：'0' 和空字符串均显示为空（让 hint 显示）
  static String _toFieldText(String amount) {
    if (amount.isEmpty || amount == '0') return '';
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = widget.onAmountInput != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            children: [
              // 货币选择器
              GestureDetector(
                onTap: widget.onCurrencyTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.keyboard_arrow_down,
                        size: 18, color: Colors.black54),
                    const SizedBox(width: 4),
                    if (widget.currencyIcon.isNotEmpty) ...[
                      LoadImage(widget.currencyIcon, width: 26, height: 26),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      widget.currencyCode,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // ⊖  amount  ⊕
              _StepButton(
                  icon: Icons.remove_circle_outline, onTap: widget.onMinus),
              const SizedBox(width: 8),
              if (isEditable)
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_DecimalInputFormatter()],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: '0',
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38),
                    ),
                    onChanged: (v) => widget.onAmountInput!(v),
                  ),
                )
              else
                Text(
                  _formatAmount(widget.amount),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              const SizedBox(width: 8),
              _StepButton(icon: Icons.add_circle_outline, onTap: widget.onPlus),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.subLabel,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              GestureDetector(
                onTap: widget.onAll,
                child: const Text('ALL',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 显示时去掉多余尾零，但保留至少 2 位小数
  static String _formatAmount(String raw) {
    final d = double.tryParse(raw);
    if (d == null) return raw;
    if (d == 0) return '0.00';
    final s = d.toStringAsFixed(8);
    final dot = s.indexOf('.');
    if (dot < 0) return '$s.00';
    String dec = s.substring(dot + 1).replaceAll(RegExp(r'0+$'), '');
    if (dec.length < 2) dec = dec.padRight(2, '0');
    return '${s.substring(0, dot)}.$dec';
  }
}

class _DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    // 只允许数字和最多一个小数点
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) return oldValue;
    return newValue;
  }
}

// ────────────────────────────────────────────────────────────

class _CountdownTimer extends StatefulWidget {
  final int totalSeconds;
  final String rateUpdatedAt;

  const _CountdownTimer(
      {required this.totalSeconds, required this.rateUpdatedAt});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.totalSeconds;
    _startTimer();
  }

  @override
  void didUpdateWidget(_CountdownTimer old) {
    super.didUpdateWidget(old);
    if (old.rateUpdatedAt != widget.rateUpdatedAt) {
      _timer?.cancel();
      _remaining = widget.totalSeconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) _remaining--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_remaining}s',
      style: const TextStyle(fontSize: 11, color: Colors.grey),
    );
  }
}

// ────────────────────────────────────────────────────────────

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 28, color: Colors.black87),
    );
  }
}

// ────────────────────────────────────────────────────────────

class _PreviewCard extends StatelessWidget {
  final String toCode;
  final String initialAmount;
  final String feeDisplay;
  final String receiveAmount;
  final bool isLoading;

  const _PreviewCard({
    required this.toCode,
    required this.initialAmount,
    required this.feeDisplay,
    required this.receiveAmount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          : Column(
              children: [
                _PreviewRow(
                  label: 'Initial amount converted',
                  value: '$toCode $initialAmount',
                  valueBold: true,
                ),
                const Divider(height: 1, color: Colors.black12),
                _PreviewRow(
                  label: 'Fee',
                  value: feeDisplay.isNotEmpty ? feeDisplay : '--',
                ),
                const Divider(height: 1, color: Colors.black12),
                _PreviewRow(
                  label: 'You get',
                  value: receiveAmount.isNotEmpty
                      ? '$toCode $receiveAmount'
                      : '--',
                  valueColor: Colors.blue,
                  valueBold: true,
                ),
              ],
            ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
