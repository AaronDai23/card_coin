import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    BiometricsState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text("Biometrics Settings"),
      ),
      body: PageDataLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onReload: () {
          dispatch(BiometricsActionCreator.onShowLoading());
        },
        onLoadSuccess: () {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 人脸图标
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.face_retouching_natural,
                      color: Colors.orange,
                      size: 90,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 人脸登录标题和开关
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Face Recognition Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: state.isBiometricEnabled,
                      onChanged: (bool value) {
                        if (value == false) {
                          // 关闭人脸登录
                          dispatch(BiometricsActionCreator
                              .onUnBindBiometricStatus());
                          return;
                        } else {
                          // 开启人脸登录
                          dispatch(BiometricsActionCreator.onToggleBiometric());
                        }
                      },
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.green,
                    ),
                  ],
                ),
                const Divider(thickness: 1, height: 30),

                // 提示文字
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '1. To make it easier for you to use this app, we provide a convenient Face Recognition login option. '
                    'Your facial data is collected and verified only by your device. We do not store or process your facial information.\n\n'
                    '2. Any face data registered in your phone system can be used to log in. Please ensure that only your own face is registered.\n\n'
                    '3. If your face data changes (e.g., you re-register your face), you need to re-enable the Face Login feature.\n\n'
                    '4. This setting only applies to this device. You need to re-enable Face Login when using another device.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ));
}
