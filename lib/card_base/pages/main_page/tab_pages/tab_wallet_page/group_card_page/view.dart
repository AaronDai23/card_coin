import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/card_base/widgets/message_bell_widget.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    GroupCardState state, Dispatch dispatch, ViewService viewService) {
  final gradientTheme =
      Theme.of(viewService.context).extension<GradientTheme>()!;
  final adapter = viewService.buildAdapter()!;
  final languageResource = state.languageResource!;

  return Scaffold(
    appBar: AppBar(
      title: Text(languageResource.tabHolder),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(viewService.context)
              .pushNamed('cardBaseSettingsPage'),
          icon: const Icon(Icons.settings),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MessageBellWidget(
              unReadCount: state.unReadCount,
              onTap: () {
                Navigator.of(viewService.context)
                    .pushNamed('messageManagerPage');
              },
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradientTheme.primaryGradient,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: PageDataLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onReload: () {
          dispatch(GroupCardActionCreator.onShowLoading());
          dispatch(GroupCardActionCreator.onLoadData());
        },
        onLoadSuccess: () {
          if (state.isFirstLoading && state.list.isEmpty) {
            return SmartRefresher(
              enablePullUp: false,
              enablePullDown: true,
              controller: state.refreshController,
              onRefresh: () {
                state.currentPage = 1;
                dispatch(GroupCardActionCreator.onLoadData());
              },
              child: _buildSkeletonGrid(),
            );
          }

          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            controller: state.refreshController,
            onRefresh: () {
              state.currentPage = 1;
              dispatch(GroupCardActionCreator.onLoadData());
            },
            onLoading: () {
              dispatch(GroupCardActionCreator.onLoadData(isLoadMore: true));
            },
            child: adapter.itemCount != 0
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 6.0,
                      childAspectRatio: 2 / 3,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 6.0),
                    itemCount: adapter.itemCount,
                    itemBuilder: adapter.itemBuilder!,
                  )
                : const EmptyListView(),
          );
        },
      ),
    ),
  );
}

Widget _buildSkeletonGrid() {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 6.0,
      childAspectRatio: 2 / 3,
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6.0),
    itemCount: 6,
    itemBuilder: (context, index) => const _GroupCardSkeleton(),
  );
}

class _GroupCardSkeleton extends StatefulWidget {
  const _GroupCardSkeleton();

  @override
  State<_GroupCardSkeleton> createState() => _GroupCardSkeletonState();
}

class _GroupCardSkeletonState extends State<_GroupCardSkeleton>
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
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF159bfc).withOpacity(0.12),
            offset: const Offset(6.0, 6.0),
            blurRadius: 5.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2FacFD).withAlpha(220),
                    const Color(0xFF2FacFD),
                  ],
                  stops: const [0.5, 1],
                ).createShader(bounds);
              },
              child: const LoadAssetImage(
                '1/smart_card_bg',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _waveBox(width: 56, height: 14, radius: 7),
            ),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _waveBox(width: 110, height: 16, radius: 8),
                  const SizedBox(height: 10),
                  _waveBox(width: 70, height: 14, radius: 7),
                  const SizedBox(height: 8),
                  _waveBox(width: 120, height: 14, radius: 7),
                  const SizedBox(height: 8),
                  _waveBox(width: 90, height: 14, radius: 7),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 20,
              child: _waveBox(width: 60, height: 30, radius: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waveBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0x66FFFFFF),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      builder: (context, child) {
        return ShaderMask(
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
        );
      },
    );
  }
}
