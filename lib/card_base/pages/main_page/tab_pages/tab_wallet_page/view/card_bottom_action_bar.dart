import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/action.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class CardBottomActionBar extends StatelessWidget {
  final MyCardState state;
  final Dispatch dispatch;

  const CardBottomActionBar({
    Key? key,
    required this.state,
    required this.dispatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 如果底部没有任何按钮，直接不占位
    if (!_hasAnyAction()) {
      return Container(
        color: const Color.fromARGB(255, 225, 240, 255),
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 225, 240, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: _buildReTapActionButtons(),
            ),
          ),
        ),
      );
    }

    return Container(
      color: const Color.fromARGB(255, 225, 240, 255),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 240, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: _buildActionButtons(),
          ),
        ),
      ),
    );
  }

  /// 构建所有操作按钮，支持 1～4 个
  List<Widget> _buildActionButtons() {
    final List<Widget> buttons = [];

    void addButton(Widget button) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 12));
      }
      buttons.add(Expanded(child: button));
    }

    // Re-Tap
    if (state.pageConfig.isShowPostCardReTap == true) {
      addButton(_buildReTapButton());
    }

    // Wallet
    if (state.pageConfig.isShowWallet == true) {
      addButton(_buildWalletButton());
    }

    // Chain Stamp
    if (state.pageConfig.isShowCardChainStamp == true) {
      addButton(_buildChainStampButton());
    }

    // Collection
    if (state.pageConfig.isShowCardAddCollection == true) {
      addButton(_buildSecondaryAction());
    }
    // Detail（只有在不显示 Collection 时）
    else if (state.pageConfig.isShowCardDetail == true) {
      addButton(_buildDetailButton());
    }

    return buttons;
  }

  /// 构建所有操作按钮，支持 1～4 个
  List<Widget> _buildReTapActionButtons() {
    final List<Widget> buttons = [];

    void addButton(Widget button) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 12));
      }
      buttons.add(Expanded(child: button));
    }

    addButton(_buildNewReTapButton());
    return buttons;
  }

  /// 是否有任何操作按钮
  bool _hasAnyAction() {
    return state.pageConfig.isShowPostCardReTap == true ||
        state.pageConfig.isShowCardAddCollection == true ||
        state.pageConfig.isShowCardDetail == true ||
        state.pageConfig.isShowWallet == true ||
        state.pageConfig.isShowCardChainStamp == true;
  }

  /// Re-NewTap 按钮
  Widget _buildNewReTapButton() {
    return ElevatedButton(
      onPressed: () => dispatch(MyCardActionCreator.onScanCardClick()),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF3E146),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Re-Tap'),
    );
  }

  /// Re-Tap 按钮
  Widget _buildReTapButton() {
    if (state.pageConfig.isShowPostCardReTap != true) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => dispatch(MyCardActionCreator.onScanCardClick()),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF3E146),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Re-Tap'),
    );
  }

  /// 详情 按钮
  Widget _buildDetailButton() {
    if (state.pageConfig.isShowCardDetail != true) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => dispatch(
          MyCardActionCreator.onPushWalletPage(state.cardDetail?.uid ?? '')),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF3E146),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Detail'),
    );
  }

  /// 钱包 按钮
  Widget _buildWalletButton() {
    if (state.pageConfig.isShowWallet != true) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => dispatch(MyCardActionCreator.onPushOneWalletPage()),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF3E146),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Wallet'),
    );
  }

  /// 链印 按钮
  Widget _buildChainStampButton() {
    if (state.pageConfig.isShowCardChainStamp != true) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => dispatch(MyCardActionCreator.onGotoChainStamp()),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF3E146),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Chain Stamp'),
    );
  }

  /// 间距（已弃用，现在通过_buildActionButtons自动添加间距）
  // Widget _buildGap() {
  //   if (state.pageConfig.isShowPostCardReTap == true &&
  //       state.pageConfig.isShowCardAddCollection == true) {
  //   return const SizedBox(width: 30);
  //   }
  //   return const SizedBox.shrink();
  // }

  /// 次级操作（Detail / Collection）
  Widget _buildSecondaryAction() {
    if (state.pageConfig.isShowCardAddCollection != true) {
      return const SizedBox.shrink();
    }

    return OutlinedButton(
      onPressed: () {
        dispatch(
          MyCardActionCreator.onExchangeCardSwitch(!state.isSwitched),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        state.isSwitched ? 'Added' : 'Add to collection',
      ),
    );
  }
}
