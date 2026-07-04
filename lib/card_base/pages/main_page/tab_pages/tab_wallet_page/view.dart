import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app.dart';
import '../../../../../custom_widget/load_image.dart';
import '../../../../../pages/main_page/hd_wallet_list_page/view/lazy_indexed_stack.dart';
import '../../../../../utils/startup_time.dart';
import '../../../../../widget/base_page_loading.dart';
import '../../../../widgets/message_bell_widget.dart';
import 'action.dart';
import 'state.dart';

const double bannerHeight = 160;

Widget buildView(
    TabWalletState state, Dispatch dispatch, ViewService viewService) {
  // 设置状态栏为透明
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 透明状态栏
    statusBarIconBrightness: Brightness.light, // 状态栏图标颜色
  ));
  return DefaultTabController(
    length: 2,
    child: Scaffold(
        body: PageDataLoadingView(
      onReload: () {
        dispatch(TabWalletActionCreator.onLoadData());
      },
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onLoadSuccess: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          StartupTime.markOnce('tab_wallet_visible');
        });
        return Container(
          color: state.bgColor,
          child: Column(
            children: [
              SizedBox(
                height: bannerHeight,
                child: Stack(children: [
                  // 背景图片
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            AppThemeConfig.bannerBackgroundAsset), // 本地背景图片
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Card(
                      margin: const EdgeInsets.only(
                          top: 40, left: 10, right: 10, bottom: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent, // 设置背景透明
                      elevation: 0, // 移除阴影
                      shadowColor: Colors.transparent, // 设置阴影颜色为透明
                      surfaceTintColor: Colors.transparent, // 移除表面色调
                      child: Swiper(
                        autoplay: true,
                        autoplayDelay: 5000,
                        itemCount: state.banners!.length,
                        curve: Curves.easeIn,
                        // indicatorLayout: PageIndicatorLayout.SLIDE,
                        // layout: SwiperLayout.DEFAULT,

                        pagination: const SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: SwiperPagination.dots),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => dispatch(
                                TabWalletActionCreator.onBannerItemClick(
                                    state.banners![index])),
                            child: LoadImage(state.banners![index].fileUrl!,
                                fit: BoxFit.fill),
                          );
                        },
                      )),

                  // 设置 & 通知图标（移出 AppBar 避免遮挡 banner 触摸区域）
                  Positioned(
                    top: MediaQuery.of(viewService.context).padding.top,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(viewService.context)
                                .pushNamed('cardBaseSettingsPage'),
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: MessageBellWidget(
                              unReadCount: state.unReadCount,
                              onTap: () => Navigator.of(viewService.context)
                                  .pushNamed('messageManagerPage'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: LazyIndexedStack(
                          index: state.currentIndex,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return AppRoute.global.buildPage('myCardPage', {
                              'typeList': state.typeList,
                              'taskItemId': state.taskItemId
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      onLoadFailure: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          StartupTime.markOnce('tab_wallet_visible');
        });
        return Container(
            color: state.bgColor,
            child: Column(
              children: [
                SizedBox(
                  height: bannerHeight,
                  child: Stack(children: [
                    // 背景图片
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              AppThemeConfig.bannerBackgroundAsset), // 本地背景图片
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Card(
                        margin: const EdgeInsets.only(
                            top: 40, left: 10, right: 10, bottom: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent, // 设置背景透明
                        elevation: 0, // 移除阴影
                        shadowColor: Colors.transparent, // 设置阴影颜色为透明
                        surfaceTintColor: Colors.transparent, // 移除表面色调
                        child: Swiper(
                          autoplay: true,
                          autoplayDelay: 5000,
                          itemCount: 1,
                          curve: Curves.easeIn,
                          // indicatorLayout: PageIndicatorLayout.SLIDE,
                          // layout: SwiperLayout.DEFAULT,

                          pagination: const SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: SwiperPagination.dots),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // dispatch(TabWalletActionCreator
                                //     .onBannerItemClick(
                                //         state.banners![index]));
                              },
                              child: const LoadImage(
                                  'https://static.zengge.com/app/card_coin/banner1.jpg',
                                  fit: BoxFit.fill,
                                  format: 'jpg'),
                            );
                          },
                        )),

                    // 设置 & 通知图标
                    Positioned(
                      top: MediaQuery.of(viewService.context).padding.top,
                      right: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(viewService.context)
                                  .pushNamed('cardBaseSettingsPage'),
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: MessageBellWidget(
                                unReadCount: state.unReadCount,
                                onTap: () => Navigator.of(viewService.context)
                                    .pushNamed('messageManagerPage'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: LazyIndexedStack(
                            index: state.currentIndex,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return AppRoute.global.buildPage(
                                  'myCardPage', {'typeList': state.typeList});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
    )),
  );
}
