import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    WithdrawBankState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(state.isEdit ? 'Edit Bank Account' : 'Bank Account'),
    ),
    body: state.isLoadingBanks
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Bank Name ───────────────────────────────────
                const Text('Bank Name',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    value: state.selectedBankCode.isNotEmpty
                        ? state.selectedBankCode
                        : null,
                    hint: const Text('Select bank',
                        style: TextStyle(color: Colors.grey)),
                    items: state.bankList
                        .map((b) => DropdownMenuItem<String>(
                              value: b.bankCode,
                              child: Text(b.bankName),
                            ))
                        .toList(),
                    onChanged: (code) {
                      if (code == null) return;
                      final bank =
                          state.bankList.firstWhere((b) => b.bankCode == code);
                      dispatch(WithdrawBankActionCreator.onSelectBank(bank));
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ── Holder ──────────────────────────────────────
                const Text('Holder',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: state.cardHolder)
                    ..selection = TextSelection.collapsed(
                        offset: state.cardHolder.length),
                  decoration: InputDecoration(
                    hintText: 'Full name as on card',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) =>
                      dispatch(WithdrawBankActionCreator.onUpdateCardHolder(v)),
                ),

                const SizedBox(height: 20),

                // ── Card No ─────────────────────────────────────
                const Text('Card No.',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: state.cardNo)
                    ..selection =
                        TextSelection.collapsed(offset: state.cardNo.length),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Bank account number',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (v) =>
                      dispatch(WithdrawBankActionCreator.onUpdateCardNo(v)),
                ),

                const SizedBox(height: 36),

                // ── Submit button ────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => dispatch(WithdrawBankActionCreator.onSubmit()),
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
                        : Text(
                            state.isEdit ? 'Update' : 'Bind',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
  );
}
