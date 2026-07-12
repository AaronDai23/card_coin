import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/utils/card_coin_util.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
    CoinMessageDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          automaticallyImplyLeading: (ModalRoute.of(viewService.context)
                  ?.settings
                  .arguments as Map?)?['fromDeepLink'] !=
              true,
          title: const Text("Message Detail")),
      body: PageDataLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onLoadSuccess: () {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: SingleChildScrollView(
              // ✅ 防止整体溢出
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      "From", state.messageDetail?.sender ?? "Unknown"),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      "Time",
                      CardCoinUtil.timeStampToTime(
                          state.messageDetail?.createTime ?? 0)),
                  const SizedBox(height: 40),
                  _buildContentText(state.messageDetail?.message ?? ""),
                ],
              ),
            ),
          );
        },
      ));
}

Widget _buildInfoRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 60, // 固定label宽度
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        // ✅ 自动换行关键
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          softWrap: true,
          maxLines: null,
        ),
      ),
    ],
  );
}

Widget _buildContentText(String content) {
  return Center(
    child: Text(
      content,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      softWrap: true,
      maxLines: null, // ✅ 不限制行数
    ),
  );
}
