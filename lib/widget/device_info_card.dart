import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:flutter/material.dart';

import '../custom_widget/load_image.dart';

class DeviceInfoCard extends StatefulWidget {
  final CardDetail cardDetail;
  final String? nickname;
  final VoidCallback? editNameClick;
  final EdgeInsetsGeometry margin;
  final bool enableEdit;

  const DeviceInfoCard(
      {super.key,
      required this.cardDetail,
      this.nickname,
      this.editNameClick,
      this.enableEdit = true,
      this.margin =
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0)});

  @override
  State<StatefulWidget> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends State<DeviceInfoCard> {
  bool showCardNo = false;

  @override
  Widget build(BuildContext context) {
    String cardNo = widget.cardDetail.cardNo ?? '';

    if (!showCardNo && cardNo.isNotEmpty) {
      cardNo = List.generate(
          cardNo.length, (index) => (index + 1) % 4 == 0 ? '* ' : '*').join('');
    } else {
      cardNo = List.generate(
              cardNo.length,
              (index) =>
                  (index + 1) % 4 == 0 ? '${cardNo[index]} ' : cardNo[index])
          .join('');
    }
    return Card(
      margin: widget.margin,
      color: AppThemeConfig.appBarBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoadImage(
                  widget.cardDetail.shape?.imageUrl ?? '',
                  fit: BoxFit.contain,
                  width: 50,
                  height: 50,
                ),
                LoadAssetImage(
                  AppConfig.of(context).appInternalId == AppType.bestWish
                      ? '1/app_logo'
                      : '2/app_logo',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            if (widget.nickname?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(
                  onTap: widget.enableEdit ? widget.editNameClick : null,
                  child: Row(
                    children: [
                      Text(
                        "Nickname：${widget.nickname!}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (widget.enableEdit)
                        const Icon(
                          Icons.border_color,
                          color: Colors.white,
                          size: 12,
                        )
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Type：${widget.cardDetail.shape!.name}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Version：${widget.cardDetail.applet!.name}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 4,
            ),
            const Spacer(),
            if (cardNo.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    cardNo,
                    style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 5,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                      onTap: () => setState(() {
                            showCardNo = !showCardNo;
                          }),
                      child: LoadAssetImage(
                        showCardNo ? 'eyes1' : 'eyes0',
                        width: 20,
                        height: 20,
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }
}
