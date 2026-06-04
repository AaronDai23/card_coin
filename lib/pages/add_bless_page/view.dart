import 'package:card_coin/card_base/bean/chain_stamp.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AddBlessState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text('Chain Stamp Message'),
    ),
    body: Stack(
      children: [
        _buildContent(state, dispatch),
        _buildBottomButton(dispatch, viewService.context),
      ],
    ),
  );
}

Widget _buildContent(AddBlessState state, Dispatch dispatch) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          /// 接收人卡号
          const Text(
            "Receiver Card Number:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),

          buildSearchInput(state, dispatch), // 替换为自动完成输入框

          const SizedBox(height: 30),

          /// 祝福语
          const Text(
            "Message:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildBlessInput(state, dispatch),

          // /// 金额
          // Text(
          //   "金额(可选)",
          //   style: TextStyle(fontSize: 16),
          // ),
          // SizedBox(height: 12),

          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 12),
          //   decoration: _boxDecoration(),
          //   child: TextField(
          //     controller: state.amountController,
          //     keyboardType: TextInputType.numberWithOptions(decimal: true),
          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       hintText: "请输入金额",
          //     ),
          //   ),
          // ),

          const SizedBox(height: 50),
        ],
      ),
    ),
  );
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.grey.shade200,
    border: Border.all(color: Colors.black54),
    borderRadius: BorderRadius.circular(4),
  );
}

Widget _buildBlessInput(AddBlessState state, Dispatch dispatch) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: _boxDecoration(),
        child: TextField(
          controller: state.blessController,
          maxLines: 5,
          maxLength: 200,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
            hintText: "",
          ),
          onChanged: (text) {
            dispatch(AddBlessActionCreator.onUpdateRemain(200 - text.length));
          },
        ),
      ),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          "left ${state.remainCount} characters",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      )
    ],
  );
}

Widget _buildBottomButton(Dispatch dispatch, BuildContext context) {
  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  return Positioned(
    left: 0,
    right: 0,
    bottom: bottomInset > 0 ? bottomInset + 10 : 20,
    child: Center(
      child: SizedBox(
        width: 160,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            dispatch(AddBlessActionCreator.onSend());
          },
          child: const Text("Send"),
        ),
      ),
    ),
  );
}

// 核心Widget实现（替换你原来的TextField）
Widget buildSearchInput(AddBlessState state, Dispatch dispatch) {
  // 模拟网络请求（实际项目中替换为真实接口）
  Future<List<ChainStamp>> fetchSuggestions(String query) async {
    // 标记加载状态
    dispatch(AddBlessActionCreator.updateLoading(true));

    try {
      var resultData = await HttpManager.getInstance().get(
        NetworkAddress.smartCardCardNumberPage,
        queryParameters: {'cardNo': query},
      );

      if (!resultData.isSuccess) {
        return [];
      }

      var list = resultData.data['rows'] as List? ?? [];
      // dispatch(AddBlessActionCreator.updateResults(state.searchResults));
      return list.map((e) => ChainStamp.fromJson(e)).toList();
    } catch (e) {
      return [];
    } finally {
      // 结束加载状态
      dispatch(AddBlessActionCreator.updateLoading(false));
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    decoration: _boxDecoration(), // 复用你原来的装饰器
    child: TypeAheadField<ChainStamp>(
      // 关联Controller
      controller: state.amountController,
      // 防抖：输入停止500ms后再请求（避免频繁请求）
      debounceDuration: const Duration(milliseconds: 500),
      // 网络请求获取建议列表
      suggestionsCallback: fetchSuggestions,
      // 加载中显示的Widget
      loadingBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      ),

      // 建议项的UI渲染
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.alias != null && suggestion.alias!.isNotEmpty
              ? "${suggestion.cardNo}(${suggestion.alias!})"
              : suggestion.cardNo!),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        );
      },

      onSelected: (ChainStamp value) {
        state.amountController.text = value.cardNo!;

        state.selectedCard.alias = value.alias; // 更新选中的卡片信息
        state.selectedCard.cardNo = value.cardNo; // 更新选中的卡片信息
        state.selectedCard.uid = value.uid; // 更新选中的卡片信息
      },
    ),
  );
}
