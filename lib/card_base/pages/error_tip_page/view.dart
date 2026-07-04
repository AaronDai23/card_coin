import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
    ErrorTipState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Error  Tip'),
      backgroundColor: const Color(0xFFF58A1F),
      foregroundColor: Colors.white,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 错误图标
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Color(0xFFF58A1F),
            ),
            const SizedBox(height: 20),
            // 错误信息
            Text(
              state.errorMessage!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // 返回按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 返回上一页
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(viewService.context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                  child: const Text('Back'),
                ),
                const SizedBox(width: 20),
                // // 返回首页
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushNamedAndRemoveUntil(
                //       viewService.context,
                //       state.returnRoute!,
                //       (route) => false,
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFFF58A1F),
                //   ),
                //   child: const Text('Home'),
                // ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
