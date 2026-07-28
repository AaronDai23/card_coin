import 'package:card_swiper/card_swiper.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../custom_widget/load_image.dart';
import '../../../widget/app_splash_logo.dart';
import '../../../widget/banner_skeleton_placeholder.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/page_categroy_item.dart';
import 'action.dart';
import 'state.dart';

bool _hasHttpBanners(ScanLoginState state) {
  final banners = state.banners;
  if (banners == null || banners.isEmpty) return false;
  final url = banners.first.fileUrl?.trim() ?? '';
  return url.startsWith('http');
}

Widget _bannerPlaceholder() {
  return const SizedBox.expand(
    child: BannerSkeletonPlaceholder(),
  );
}

Widget buildView(
    ScanLoginState state, Dispatch dispatch, ViewService viewService) {
  final isDark =
      MediaQuery.platformBrightnessOf(viewService.context) == Brightness.dark;
  final showSwiper = _hasHttpBanners(state);
  final waitingForBanners =
      !_hasHttpBanners(state) && !state.bannerFetchCompleted;
  final showChrome = !waitingForBanners;

  // No Scaffold here — MaterialApp already wraps routes in one.
  // Nested Scaffold was flashing theme bg and making the logo look smaller.
  return BasePageLoadingView(
    loadStatus: state.loadStatus,
    errorMsg: state.errorMsg,
    onReload: () {
      dispatch(ScanLoginActionCreator.onLoadData());
    },
    buildBody: (bool isLoadSuccess) {
      if (!isLoadSuccess || waitingForBanners) {
        // Same tree as SplashPage — no Stack/chrome wrapping.
        return const AppSplashLogo();
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          // Cover while swiper mounts; same widget/size as SplashPage.
          const AppSplashLogo(),
          // When carousel URLs are ready, cover logo with placeholder then images.
          if (showSwiper) ...[
            _bannerPlaceholder(),
            Swiper(
              autoplay: true,
              autoplayDelay: 5000,
              itemCount: state.banners!.length,
              itemWidth: MediaQuery.of(viewService.context).size.width,
              itemHeight: MediaQuery.of(viewService.context).size.height,
              curve: Curves.easeIn,
              pagination: const SwiperPagination(
                  margin: EdgeInsets.symmetric(vertical: 60, horizontal: 60),
                  alignment: Alignment.topCenter,
                  builder: SwiperPagination.dots),
              itemBuilder: (BuildContext context, int index) {
                var bannerItem = state.banners![index];
                final dpr = MediaQuery.devicePixelRatioOf(context);
                final cacheW =
                    (MediaQuery.sizeOf(context).width * dpr).round();
                return GestureDetector(
                    onTap: () => dispatch(
                        ScanLoginActionCreator.onBannerItemClick(bannerItem)),
                    child: LoadImage(
                      bannerItem.fileUrl!,
                      fit: BoxFit.cover,
                      holderImg: _bannerPlaceholder(),
                      // Decode at screen width — much faster than full remote res.
                      memCacheWidth: cacheW,
                    ));
              },
            ),
          ],
          if (showChrome)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(viewService.context)
                              .pushNamed('multipleLoginPage');
                        },
                        child: Text(
                          state.languageResource!.clickLogin,
                          style: TextStyle(
                              color: showSwiper
                                  ? Colors.white
                                  : (isDark ? Colors.white : Colors.black87),
                              shadows: showSwiper
                                  ? [
                                      Shadow(
                                          color: Colors.black.withOpacity(0.4),
                                          offset: const Offset(1, 1))
                                    ]
                                  : null),
                        ),
                      ),
                      IconButton(
                          onPressed: () => Navigator.of(viewService.context)
                              .pushNamed('appVersionPage'),
                          icon: Icon(
                            Icons.settings,
                            color: showSwiper
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                            shadows: showSwiper
                                ? [
                                    Shadow(
                                        color: Colors.black.withOpacity(0.4),
                                        offset: const Offset(1, 1))
                                  ]
                                : null,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          if (showChrome && (state.buttons?.isNotEmpty ?? false))
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40.0,
                    child: Row(
                        children: state.buttons!.asMap().entries.map((e) {
                      int index = e.key;
                      PageCategoryItem buttonItem = e.value;
                      bool isScanButton = buttonItem.target == 'scanCard';
                      Widget buttonChild = Text(
                        buttonItem.name ?? "",
                        style: const TextStyle(color: Colors.black),
                      );
                      if (isScanButton && state.isScanning) {
                        buttonChild = const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: index == (state.buttons!.length - 1)
                                  ? 0.0
                                  : 8.0),
                          child: ElevatedButton(
                              onPressed: () => dispatch(
                                  ScanLoginActionCreator.onButtonItemClick(
                                      buttonItem)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0))),
                              child: Center(child: buttonChild)),
                        ),
                      );
                    }).toList()),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class CustomSwiperPlugin implements SwiperPlugin {
  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return Container(
      width: 60,
      height: 2.0,
      color: Colors.red,
    );
  }
}
