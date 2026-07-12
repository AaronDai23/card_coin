import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../custom_widget/load_image.dart';
import '../../../generated/l10n.dart';
import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MemberState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Stack(
    fit: StackFit.expand,
    children: [
      const LoadAssetImage(
        'level_bg',
        fit: BoxFit.cover,
      ),
      Scaffold(
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
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            languageResource.userLevel,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
        ),
        backgroundColor: Colors.transparent,
        body: BasePageLoadingView(
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg,
          onReload: () {
            dispatch(MemberActionCreator.onShowLoading());
            dispatch(MemberActionCreator.onLoadData());
          },
          buildBody: (isSuccess) {
            return Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Swiper(
                    itemCount: state.customerLevels!.length,
                    curve: Curves.easeIn,
                    loop: false,
                    controller: state.controller,
                    onIndexChanged: (index) =>
                        dispatch(MemberActionCreator.onUpdateIndex(index)),
                    pagination: const SwiperPagination(
                        margin: EdgeInsets.only(top: 190),
                        alignment: Alignment.topCenter,
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.white,
                            activeColor: Colors.orange,
                            size: 6.0,
                            activeSize: 6.0)),
                    itemBuilder: (BuildContext context, int index) {
                      var customerLevel = state.customerLevels![index];
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 180,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                LoadImage(
                                  customerLevel.cardImageUrl ?? '',
                                  showHolder: false,
                                  fit: BoxFit.fill,
                                ),
                                if (state.currentLevel?.id! == customerLevel.id)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0)),
                                          color: Colors.white.withAlpha(80)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 4.0),
                                      child: Text(
                                        S.current.currentLevel,
                                        style: const TextStyle(fontSize: 10.0),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0, horizontal: 40.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 16.0,
                                                ),
                                                Text(
                                                  customerLevel.name ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 16.0,
                                                ),
                                                Text(
                                                    customerLevel.locked!
                                                        ? S.current.levelLocked
                                                        : S.current.levelActive,
                                                    style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.white))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 76.0,
                                            height: 76.0,
                                            child: LoadImage(
                                              customerLevel.imageUrl ?? '',
                                              showHolder: false,
                                            ),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          customerLevel.brief ?? '',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 30.0),
                            itemCount: customerLevel.privileges!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1 / 1.4,
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              var privilege = customerLevel.privileges![index];
                              return GestureDetector(
                                onTap: () => dispatch(
                                    MemberActionCreator.onShowPrivilegeDetail(
                                        privilege.privilegeId!)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 60.0,
                                        height: 60.0,
                                        child: LoadImage(
                                          (privilege.locked ?? false)
                                              ? privilege.imageInactiveUrl ?? ''
                                              : privilege.imageActiveUrl ?? '',
                                          fit: BoxFit.fill,
                                          showHolder: false,
                                        )),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      privilege.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                      maxLines: 2,
                                    )
                                  ],
                                ),
                              );
                            },
                            shrinkWrap: true,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: const Color(0xFF0E122B).withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 257,
                              height: 53.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: ExactAssetImage(
                                      'assets/images/level_cur_rank.png',
                                    ),
                                    fit: BoxFit.fill),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    state.customerLevelInfo?.docName ?? '',
                                    style: const TextStyle(
                                        color: Color(0xFF5E3308),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: 300,
                              child: SingleChildScrollView(
                                child: Theme(
                                    data: ThemeData(
                                        textTheme: const TextTheme(
                                            bodyMedium: TextStyle(
                                                color: Colors.white))),
                                    child: Html(
                                      data:
                                          state.customerLevelInfo?.docContext ??
                                              '',
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            );
          },
        ),
      )
    ],
  );
}
