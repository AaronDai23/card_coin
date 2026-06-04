import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SettingsState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  // List<Map<String, dynamic>> settingList = [
  //   {'type': 'setPinCode', 'name': languageResource.setPinCode},
  //   {'type': 'unlockPinCode', 'name': languageResource.unlockPinCode},
  //   {'type': 'deviceSetting', 'name': languageResource.deviceSetting},
  //   {'type': 'addressBook', 'name': languageResource.addressBook},
  //   {'type': 'backupData', 'name': languageResource.backUp},
  //   {'type': 'healthCheck', 'name': languageResource.healthCheck},
  //   {'type': 'assetSetting', 'name': languageResource.assetSettings},
  //   // '安全通道设置'
  // ];
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource.settings),
    ),
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      buildBody: (isLoadSuccess) {
        if (state.list.isEmpty) {
          return _buildSettingsSkeleton();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: ListView.builder(
            itemBuilder: (context, index) {
              PageCategoryItem categoryItem = state.list[index];
              return InkWell(
                onTap: () => dispatch(
                    SettingsActionCreator.onListItemClick(categoryItem)),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LoadImage(categoryItem.imageUrl ?? "",
                                width: 30,
                                height: 30,
                                holderImg: const LoadAssetImage(
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
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_right)
                          ],
                        )),
                    const Divider(
                      height: 0,
                    ),
                  ],
                ),
              );
            },
            itemCount: state.list.length,
          ),
        );
      },
    ),
  );
}

Widget _buildSettingsSkeleton() {
  return Container(
    margin: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    child: ListView.separated(
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
    ),
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
