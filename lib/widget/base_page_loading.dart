import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../base/base_item.dart';
import '../custom_widget/load_image.dart';
import '../global_store/state.dart';
import '../global_store/store.dart';

enum LoadType { defeat, loading, loadSuccess, loadFailure }

class LoadPageState<T> implements GlobalBaseState<LoadPageState<T>> {
  LoadType loadStatus = LoadType.loading;
  String errorMsg = '';

  @override
  LoadPageState<T> clone() {
    return LoadPageState()
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadStatus = loadStatus;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource = AppLanguageResource({});
}

abstract class PageLoad {
  late LoadType loadStatus;
  late String errorMsg;
}

abstract class BasePageState<T extends BaseItem> extends ItemListLike
    implements PageLoad {
  late List<T> list;

  @override
  Object getItemData(int index) {
    return list.elementAt(index) as dynamic;
  }

  @override
  String getItemType(int index) {
    return list.elementAt(index).type;
  }

  @override
  int get itemCount => list.length;

  @override
  ItemListLike updateItemData(int index, Object data, bool isStateCopied) {
    list[index] = data as T;
    return this;
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class EmptyListView extends StatelessWidget {
  final VoidCallback? onReload;
  final String? text;

  const EmptyListView({Key? key, this.onReload, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = GlobalStore.store.getState();
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadAssetImage(
            "box_null",
            width: 160,
            height: 160,
          ),
          Text(
            text ?? globalState.languageResource!.nullList,
            style: const TextStyle(color: Colors.black),
          ),
          Visibility(
            visible: onReload != null,
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  onPressed: onReload,
                  child: Text(globalState.languageResource!.reload),
                )),
          ),
        ],
      ),
    );
  }
}

typedef BuildBody = Widget Function(bool isLoadSuccess);

class BasePageLoadingView extends StatelessWidget {
  final LoadType loadStatus;
  final String errorMsg;
  final Function? onReload;

  final BuildBody buildBody;

  const BasePageLoadingView(
      {Key? key,
      required this.buildBody,
      required this.loadStatus,
      required this.errorMsg,
      this.onReload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loadStatus == LoadType.defeat) {
      return const SizedBox();
    }
    return loadStatus == LoadType.loading
        ? const LoadingView()
        : loadStatus == LoadType.loadFailure
            ? LoadErrorView(
                errorMsg: errorMsg,
                onReload: onReload,
              )
            : buildBody(loadStatus == LoadType.loadSuccess);
  }
}

typedef LoadSuccess = Widget Function();
typedef LoadFailure = Widget Function();

class PageDataLoadingView extends StatelessWidget {
  final LoadType loadStatus;

  ///失败原因文本
  final String? errorMsg;

  ///失败二级提示文本
  final String? tipsMsg;
  final Color errorMsgColor;

  ///失败按钮文本
  final String? reloadText;

  ///失败按钮点击回调
  final Function()? onReload;

  ///失败按钮背景颜色
  final Color? buttonColor;

  ///自定义加载进度条
  final Widget? loadingView;

  ///自定义失败图标
  final Widget? errorIcon;

  ///成功回调
  final LoadSuccess onLoadSuccess;

  ///失败回调
  final LoadFailure? onLoadFailure;

  const PageDataLoadingView({
    super.key,
    required this.onLoadSuccess,
    this.onLoadFailure,
    this.loadingView,
    required this.loadStatus,
    this.errorMsg,
    this.errorIcon,
    this.reloadText,
    this.tipsMsg,
    this.errorMsgColor = Colors.white,
    this.buttonColor = const Color(0xFF0099CC),
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    if (loadStatus == LoadType.loading) {
      return loadingView ?? const LoadingView();
    } else if (loadStatus == LoadType.defeat) {
      return const SizedBox();
    } else if (loadStatus == LoadType.loadFailure) {
      if (onLoadFailure != null) {
        return onLoadFailure!.call();
      } else {
        GlobalState globalState = GlobalStore.store.getState();
        return LoadErrorView(
          errorMsg: errorMsg ?? globalState.languageResource!.loadFailure,
          reloadText: reloadText ?? globalState.languageResource!.reload,
          errorIcon: errorIcon,
          tipsMsg: tipsMsg,
          errorMsgColor: errorMsgColor,
          buttonColor: buttonColor,
          onReload: onReload,
        );
      }
    } else {
      return onLoadSuccess();
    }
  }
}

class LoadErrorView extends StatelessWidget {
  final String errorMsg;
  final Function? onReload;
  final String? reloadText;
  final String? tipsMsg;
  final Color? errorMsgColor;
  final Color? buttonColor;
  final Widget? errorIcon;

  const LoadErrorView({
    super.key,
    required this.errorMsg,
    this.onReload,
    this.errorIcon,
    this.reloadText,
    this.tipsMsg,
    this.errorMsgColor = Colors.white,
    this.buttonColor = const Color(0xFF0099CC),
  });

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = GlobalStore.store.getState();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LoadAssetImage(
          'network_error',
          width: 180,
          height: 120,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          child: Text("Network Error",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          width: double.infinity,
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          child: Text(
              errorMsg.contains(
                      "The current device is detected to be using dual SIM cards with VPN enabled, which causes network request failures. It is recommended to disable one SIM card or the VPN before retrying.")
                  ? errorMsg
                  : "Current network is unstable. \nSuggested step-by-step inspection: \n1.If using dual SIM card+VPN, you can try turning off one card or turning off VPN \n2. If not, check the network or whether the Do Not Disturb mode is enabled.",
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CCButton(
            horizontalPadding: 30.0,
            child: const Text(
              "Network Check",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () =>
                {Navigator.of(context).pushNamed('networkCheckPage')},
          ),
          const SizedBox(
            width: 20,
          ),
          if (onReload != null)
            CCButton(
              horizontalPadding: 30.0,
              child: Text(
                reloadText ?? globalState.languageResource!.refresh,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              onPressed: () => onReload?.call(),
            )
        ])
      ],
    );
  }
}

// class LoadNewErrorView extends StatelessWidget {
//   final String title; // 新增：动态标题
//   final String message;
//   final VoidCallback onConfirm;

//   const LoadNewErrorView({
//     super.key,
//     required this.title,
//     required this.message,
//     required this.onConfirm,
//   });

//   /// 静态方法，用于弹出毛玻璃错误弹窗
//   static void show(
//     BuildContext context, {
//     String title = "Tip", // 默认标题
//     required String message,
//     required VoidCallback onConfirm,
//   }) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return ZenggeTextAlertDialog(message);
//         }).then((value) async {});
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 禁止点击背景关闭
//       builder: (ctx) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
//           child: AlertDialog(
//             backgroundColor: Colors.white.withOpacity(0.85),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),

//             // 👇 标题靠左显示
//             titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//             title: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             content: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 message,
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             actionsAlignment: MainAxisAlignment.center,
//             actions: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.orange,
//                   // shape: RoundedRectangleBorder(
//                   //   borderRadius: BorderRadius.circular(8),
//                   // ),
//                 ),
//                 onPressed: () {
//                   Navigator.of(ctx).pop(); // 关闭弹窗
//                   onConfirm();
//                 },
//                 child: const Text("OK"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 占位内容
//     return const Expanded(
//       child: SizedBox.shrink(),
//     );
//   }
// }
