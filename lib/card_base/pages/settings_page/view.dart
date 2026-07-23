import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../custom_widget/load_image.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/page_categroy_item.dart';
import 'action.dart';
import 'state.dart';

Widget _buildListSkeleton() {
  return ListView.separated(
    itemCount: 6,
    separatorBuilder: (_, __) => const Divider(height: 0),
    itemBuilder: (context, index) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            _WaveSkeletonBox(width: 30, height: 30, radius: 8),
            SizedBox(width: 10),
            _WaveSkeletonBox(width: 140, height: 16, radius: 8),
            Spacer(),
            _WaveSkeletonBox(width: 18, height: 18, radius: 9),
          ],
        ),
      );
    },
  );
}

class _WaveSkeletonBox extends StatefulWidget {
  const _WaveSkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<_WaveSkeletonBox> createState() => _WaveSkeletonBoxState();
}

class _WaveSkeletonBoxState extends State<_WaveSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.radius);
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EEF5),
          borderRadius: borderRadius,
        ),
      ),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) {
              final shift = _controller.value * 2 - 1;
              return LinearGradient(
                begin: Alignment(-1.0 + shift, 0),
                end: Alignment(1.0 + shift, 0),
                colors: const [
                  Color(0x00FFFFFF),
                  Color(0xAAFFFFFF),
                  Color(0x00FFFFFF),
                ],
                stops: const [0.2, 0.5, 0.8],
              ).createShader(rect);
            },
            child: child,
          ),
        );
      },
    );
  }
}

Widget buildView(
    SettingsState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  final fromDeepLink = (ModalRoute.of(viewService.context)?.settings.arguments
          as Map?)?['fromDeepLink'] ==
      true;
  final String currentLanguageLabel = (state.languageList.isNotEmpty &&
          state.currentIndexLan >= 0 &&
          state.currentIndexLan < state.languageList.length)
      ? (state.languageList[state.currentIndexLan].localeName ?? '')
      : (state.languageLocale?.toLanguageTag() ?? '');
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      automaticallyImplyLeading: !fromDeepLink,
      leading: fromDeepLink
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(viewService.context).pop(),
            ),
      title: Text(languageResource.settings),
      actions: [
        // TextButton(
        //     onPressed: () => dispatch(SettingsActionCreator.onWriteNtag()),
        //     child: const Text(
        //       'NTAG',
        //       style: TextStyle(color: Colors.white),
        //     )),
        TextButton(
            onPressed: () => dispatch(SettingsActionCreator.onNetworkCheck()),
            child: Text(
              languageResource.networkCheck,
              style: const TextStyle(color: Colors.white),
            ))
        // TextButton(onPressed: (){
        //   Navigator.of(viewService.context).pushNamed('encryptCheckPage');
        // }, child: Text('加密验证',style: TextStyle(color: Colors.white),))
      ],
    ),
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        dispatch(SettingsActionCreator.onShowLoading());
        dispatch(SettingsActionCreator.onLoadData());
      },
      buildBody: (isLoadSuccess) {
        var phoneNum = state.userInfo.customer?.phone ?? '';
        var id = state.userInfo.customer?.customerCode ?? '';
        if (phoneNum.length >= 8) {
          phoneNum = phoneNum.replaceRange(3, 8, '*****');
        }
        if (phoneNum.isEmpty) {
          phoneNum = languageResource.unbindPhone;
        }

        final email =
            state.userInfo.customer?.email ?? languageResource.unbindEmail;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10.0),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            dispatch(SettingsActionCreator.onEditAvatarClick()),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LoadImage(
                            state.userInfo.customer?.avatar ?? '',
                            holderImg: const LoadAssetImage(
                              'icon_me',
                              fit: BoxFit.fill,
                            ),
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "ID:$id",
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => dispatch(
                                    SettingsActionCreator.onEditNameClick()),
                                child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          state.userInfo.customer?.nickName ??
                                              '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                        )
                                      ],
                                    ))),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              phoneNum,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              email,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: state.list.isEmpty
                      ? _buildListSkeleton()
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            PageCategoryItem categoryItem = state.list[index];
                            return InkWell(
                              onTap: () => dispatch(
                                  SettingsActionCreator.onItemClick(
                                      categoryItem)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: categoryItem.code !=
                                            'CHANGE_LANGUAGE'
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              LoadImage(
                                                  categoryItem.imageUrl ?? "",
                                                  width: 30,
                                                  height: 30,
                                                  holderImg:
                                                      const LoadAssetImage(
                                                    'none',
                                                    fit: BoxFit.fill,
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                                height: 1,
                                              ),
                                              Text(
                                                categoryItem.name ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                  Icons.keyboard_arrow_right)
                                            ],
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              LoadImage(
                                                  categoryItem.imageUrl ?? "",
                                                  width: 30,
                                                  height: 30,
                                                  holderImg:
                                                      const LoadAssetImage(
                                                    'none',
                                                    fit: BoxFit.fill,
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                                height: 1,
                                              ),
                                              Text(
                                                categoryItem.name ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                              const Spacer(),
                                              Text(
                                                currentLanguageLabel,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                              const Icon(
                                                  Icons.keyboard_arrow_right)
                                            ],
                                          ),
                                  ),
                                  const Divider(
                                    height: 0,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: state.list.length,
                        ),
                )),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFF0000)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          onPressed: () =>
                              dispatch(SettingsActionCreator.onCancelAccount()),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: Center(
                                  child: Text(
                                languageResource.cancellationAccount,
                                style:
                                    const TextStyle(color: Color(0xFFFF0000)),
                              )))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFa7a8aa),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          onPressed: () =>
                              dispatch(SettingsActionCreator.onLoginOutClick()),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: Center(
                                  child: Text(
                                languageResource.logoutAccount,
                                style: const TextStyle(color: Colors.black),
                              )))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
