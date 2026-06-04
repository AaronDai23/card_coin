import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CheckCardState state, Dispatch dispatch, ViewService viewService) {
  int count = 0;
  int failCount = 0;
  int totalCount = 21;
  int docount = 0;

  bool isStart = false;
  int startCount = 0;
  for (var element in state.checkList) {
    if (element.status != HealthStatus.none &&
        element.status != HealthStatus.process) {
      count++;
    }
    if (element.status == HealthStatus.none) {
      startCount++;
    }

    if (element.status == HealthStatus.failed ||
        element.status == HealthStatus.unHealth) {
      failCount++;
    }
    if (element.status == HealthStatus.unHealth ||
        element.status == HealthStatus.health) {
      docount++;
    }
  }
  if (startCount == 21) {
    isStart = false;
  } else {
    isStart = true;
  }
  double sucvalue = (totalCount - failCount) / totalCount;
  // double value = count / totalCount;
  var languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource.healthCheck),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(viewService.context).pop(),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(languageResource.checkCardTips),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: state.showScanTip && (docount != totalCount)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        languageResource.tryScan,
                        style:
                            const TextStyle(fontSize: 20.0, color: Colors.grey),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(0),
                        child: LoadAssetImage(
                          'nac_card1',
                          width: 150,
                          height: 100,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (_, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth * 0.3,
                            height: constraints.maxWidth * 0.3,
                            child: CircularProgressIndicator(
                              strokeWidth: 6,
                              value: isStart ? sucvalue : 0,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 9, 91, 12)),
                            ),
                          );
                        },
                      ),
                      Text(
                        '${double.parse(((isStart ? sucvalue : 0) * 100).toStringAsFixed(0))}%',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 14, 72, 16),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
          ),
          Text(
            failCount > 0
                ? languageResource.getCheckTotalFailTip("$failCount")
                : languageResource.getCheckTotalTip,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(
            height: 10,
          ),
          // 自定义条形进度条，带半圆两端
          LinearProgressBar(
            maxSteps: totalCount,
            progressType:
                LinearProgressBar.progressTypeLinear, // Use Linear progress
            currentStep: count,
            progressColor: const Color(0xff002dfc),
            backgroundColor: Colors.grey[200]!,
            // borderRadius: BorderRadius.circular(10), //  NEW
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$count/$totalCount',
            style: const TextStyle(
              color: Color(0xff002dfc),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          // 去除阴影，仅保留分割线的表格
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final taskItem = state.checkList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 1.0),
                  elevation: 0, // 去掉阴影
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${index + 1}. ${taskItem.name}",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(width: 12),
                        taskItem.status == HealthStatus.process
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator())
                            : Expanded(
                                flex: 3,
                                child: Text(
                                  taskItem.result == null
                                      ? ''
                                      : taskItem.result!.isEmpty
                                          ? languageResource.empty
                                          : taskItem.result!,
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  style: TextStyle(
                                      color:
                                          taskItem.status == HealthStatus.health
                                              ? Colors.green
                                              : Colors.red),
                                ),
                              )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300], // 设置分隔线颜色
                thickness: 1, // 设置分隔线的厚度
                height: 0, // 去除分隔线的高度，直接让两条目贴合
              ),
              itemCount: state.checkList.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: CCButton(
              verticalPadding: 15,
              color: count < totalCount && count > 0
                  ? const Color.fromRGBO(158, 158, 158, 1)
                  : Colors.black,
              child: Center(
                  child: (count < totalCount && count > 0)
                      ? Text(
                          languageResource.checking,
                        )
                      : state.showScanTip
                          ? const Text('Stop')
                          : Text(
                              languageResource.startCheck,
                            )),
              onPressed: () {
                if (count < totalCount && count > 0) {
                  return;
                }
                if (state.showScanTip) {
                  dispatch(CheckCardActionCreator.onReSetAction());
                } else {
                  dispatch(CheckCardActionCreator.onStartAction());
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class LinearProgressPainter extends CustomPainter {
  final double value; // 进度值 (0.0 到 1.0)
  final Color progressColor; // 进度条的颜色
  final Color backgroundColor; // 背景条的颜色

  LinearProgressPainter({
    required this.value,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 10.0; // 半圆的半径
    final progressWidth = size.width * value; // 计算进度的宽度

    final backgroundPaint = Paint()
      ..color = backgroundColor // 设置背景色
      ..strokeWidth = 20
      ..style = PaintingStyle.fill;

    final progressPaint = Paint()
      ..color = progressColor // 设置进度色
      ..strokeWidth = 20
      ..style = PaintingStyle.fill;

    // 绘制背景条形
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, 20), const Radius.circular(radius)),
      backgroundPaint,
    );

    // 绘制进度条
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, progressWidth, 20),
          const Radius.circular(radius)),
      progressPaint,
    );

    // 绘制两端的半圆
    backgroundPaint.color = backgroundColor;
    canvas.drawCircle(const Offset(0, 10), radius, backgroundPaint); // 左端背景半圆
    canvas.drawCircle(
        Offset(progressWidth, 10), radius, backgroundPaint); // 右端背景半圆

    // 绘制进度条两端的半圆
    progressPaint.color = progressColor;
    canvas.drawCircle(const Offset(0, 10), radius, progressPaint); // 左端进度半圆
    canvas.drawCircle(
        Offset(progressWidth, 10), radius, progressPaint); // 右端进度半圆
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // 如果进度值不变，则不需要重新绘制
  }
}
