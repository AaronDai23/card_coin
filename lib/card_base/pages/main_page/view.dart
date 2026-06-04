import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../custom_widget/load_image.dart';
import '../../../pages/main_page/hd_wallet_list_page/view/lazy_indexed_stack.dart';
import '../../../utils/startup_time.dart';
import '../../../widget/base_page_loading.dart';
import '../../widgets/animations/scaling_animation.dart';
import '../../widgets/animations/settings_floating_location.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(MainState state, Dispatch dispatch, ViewService viewService) {
  var currentItem =
      state.tabList.isEmpty ? null : state.tabList[state.currentIndex];

  final isHiddenTab = currentItem?.hiddenTab ?? false; // 根据 hiddenTab 判断
  return Scaffold(
    body: BasePageLoadingView(
        errorMsg: state.errorMsg,
        loadStatus: state.loadStatus,
        onReload: () {
          dispatch(MainActionCreator.onReload());
        },
        buildBody: (isSuccess) {
          if (isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              StartupTime.markOnce('card_base_main_visible');
            });
            return Column(
              children: [
                Expanded(
                    child: LazyIndexedStack(
                  reuse: false,
                  index: state.currentIndex,
                  itemBuilder: (c, i) {
                    var item = state.tabList[i];
                    if (item.type == 'ACTIVITY') {
                      return AppRoute.global
                          .buildPage(state.tabList[i].target ?? '', {
                        'userInfo': state.userInfo,
                        'categoryItem': item,
                        'unReadCount': state.unReadCount,
                        'taskItemId': state.taskItemId
                      });
                    } else {
                      return AppRoute.global.buildPage('tabWebviewPage', {
                        'userInfo': state.userInfo,
                        'categoryItem': item,
                        'unReadCount': state.unReadCount
                      });
                    }
                  },
                  itemCount: state.tabList.length,
                )),
                if (!isHiddenTab) ...[
                  Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  Container(
                    width: double.infinity,
                    height: 80.0,
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 0),
                    child: TabBar(
                      key: ValueKey(state.tabList.map((e) => e.name).join()),
                      labelPadding: const EdgeInsets.all(0),
                      controller: state.tabController,
                      indicator: const BoxDecoration(),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[500],
                      labelStyle: const TextStyle(fontSize: 12.0),
                      unselectedLabelStyle: const TextStyle(fontSize: 12.0),
                      isScrollable: false,
                      onTap: (int index) {
                        if (state.currentIndex != index) {
                          dispatch(MainActionCreator.onJump(index));
                        }
                      },
                      tabs: state.tabList
                          .asMap()
                          .entries
                          .map((e) => SizedBox(
                              height: 55,
                              child: Tab(
                                icon: Stack(
                                  children: [
                                    Visibility(
                                      visible: e.key == state.currentIndex,
                                      child: LoadImage(
                                        e.value.hoverImageUrl ?? '',
                                        width: 23,
                                        height: 23,
                                      ),
                                    ),
                                    Visibility(
                                      visible: e.key != state.currentIndex,
                                      child: LoadImage(
                                        e.value.imageUrl ?? '',
                                        width: 23,
                                        height: 23,
                                      ),
                                    )
                                  ],
                                ),
                                text: e.value.name,
                                iconMargin: const EdgeInsets.all(2.0),
                              )))
                          .toList(),
                    ),
                  )
                ]
              ],
            );
          } else {
            return const SizedBox();
          }
        }),
    floatingActionButtonAnimator: ScalingAnimation(),
    floatingActionButtonLocation: SettingsFloatingLocation(
        FloatingActionButtonLocation.endDocked,
        offsetY: -110,
        offsetX: -2),
    floatingActionButton: state.menuInfo != null && state.animation != null
        ? GestureDetector(
            key: state.showPopWinKey,
            onTap: () => dispatch(MainActionCreator.onShowMenu()),
            child: RotationTransition(
              turns: state.animation!,
              child: LoadImage(
                state.menuInfo?.imageUrl ?? '',
                width: 46.0,
                height: 46.0,
              ),
            ),
          )
        : null,
  );
}
