import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/page_field_config_info.dart';
import 'package:card_coin/card_base/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NonInvestmentCardSection extends StatefulWidget {
  final SmartCardDetail card;
  final VoidCallback onTapQR;
  final PageFieldConfigInfo pageConfig;
  final String? totalBalance;
  final bool showTotalBalance;

  const NonInvestmentCardSection({
    super.key,
    required this.card,
    required this.pageConfig,
    required this.onTapQR,
    this.totalBalance,
    this.showTotalBalance = false,
  });

  @override
  State<NonInvestmentCardSection> createState() =>
      _NonInvestmentCardSectionState();
}

class _NonInvestmentCardSectionState extends State<NonInvestmentCardSection> {
  SmartCardDetail get card => widget.card;
  PageFieldConfigInfo get pageConfig => widget.pageConfig;

  /// 背景图区域的固定宽高比 1.78:1（横屏，类似人民币）
  static const double _bgAspectRatio = 1.78;

  /// 内容区域文字颜色：默认黑色，后台有配置则用配置
  Color get _contentTextColor {
    final configured = card.pageField?.fontColor;
    if (configured != null && configured.isNotEmpty) {
      return ColorUtil.parseHexColor(configured);
    }
    return const Color(0xFF333333);
  }

  /// 内容区域背景色：默认白色，后台有配置则用配置
  Color get _contentBgColor {
    final configured = card.pageField?.backgroundColor;
    if (configured != null && configured.isNotEmpty) {
      return ColorUtil.parseHexColor(configured);
    }
    return Colors.white;
  }

  /// 背景图加载失败时的兜底背景色
  Color get _fallbackBgColor =>
      ColorUtil.parseHexColor(card.pageField?.backgroundColor ?? '#0000FF');

  Color get _primaryText => _contentTextColor;

  TextStyle get _titleStyle => TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: _contentTextColor);

  TextStyle get _valueStyle =>
      TextStyle(fontSize: 16, color: _contentTextColor);

  TextStyle get _specialTitleStyle => TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: _contentTextColor,
      );

  @override
  Widget build(BuildContext context) {
    return _buildCardBody();
  }

  Widget _buildCardBody() {
    final hasBgImage = pageConfig.isShowCardBackgroundImage == true &&
        card.background?.isNotEmpty == true;
    final cornerItems = _buildCornerIconItems();

    final contentWidgets = [
      _buildTotalBalance(),
      _buildName(),
      _buildMerchantTitle(),
      _buildMobile(),
      _buildEmail(),
      _buildAddress(),
      _buildDescription(),
    ];

    final visibleContentWidgets =
        contentWidgets.where((w) => !_isShrinkSizedBox(w)).toList();
    final isSingleLineContent = visibleContentWidgets.length <= 1;
    final isOnlyCardNoVisible = _isOnlyCardNoVisible();
    final double contentBottomPadding =
        isOnlyCardNoVisible ? 8 : (isSingleLineContent ? 12 : 20);
    final double contentItemSpacing =
        isOnlyCardNoVisible ? 4 : (isSingleLineContent ? 8 : 12);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final bgImageHeight = cardWidth / _bgAspectRatio;
        const double radius = 20.0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasBgImage) ...[
                  /// 🔹 背景图：fitWidth 完整显示，无裁剪
                  Image.network(
                    card.background!,
                    width: cardWidth,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: cardWidth,
                        height: bgImageHeight,
                        color: _fallbackBgColor,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: cardWidth,
                        height: bgImageHeight,
                        color: _fallbackBgColor,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),

                  /// 🔹 凹过渡区（高度 radius，不覆盖上方图片）
                  /// 底层：同一张图片 bottom 对齐，只露出底部 radius 像素
                  /// 顶层：内容背景色 + 顶部圆角，"耳朵"处露出底层图片
                  SizedBox(
                    width: cardWidth,
                    height: radius,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Image.network(
                            card.background!,
                            width: cardWidth,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          width: cardWidth,
                          height: radius,
                          decoration: BoxDecoration(
                            color: _contentBgColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              topRight: Radius.circular(radius),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                /// 🔹 内容区域
                Container(
                  width: cardWidth,
                  color: _contentBgColor,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, contentBottomPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: _withSpacing(
                              contentWidgets,
                              spacing: contentItemSpacing,
                            ),
                          ),
                        ),
                      ),
                      if (cornerItems.isNotEmpty) const SizedBox(width: 12),
                      _buildCornerColumn(
                        items: cornerItems,
                        isOnlyCardNoVisible: isOnlyCardNoVisible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 右上角纵向图标区域（参与布局）
  Widget _buildCornerColumn({
    List<_CornerItem>? items,
    bool isOnlyCardNoVisible = false,
  }) {
    final displayItems = items ?? _buildCornerIconItems();
    if (displayItems.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isOnlyCardNoVisible
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      children: displayItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isOnlyCardNoVisible
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              if (item.imageUrl?.isNotEmpty == true)
                Image.network(item.imageUrl!,
                    width: 30, height: 30, fit: BoxFit.contain),
              if (item.label?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SizedBox(
                    width: 60,
                    child: Text(
                      item.label!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: isOnlyCardNoVisible
                          ? TextAlign.right
                          : TextAlign.center,
                      style: TextStyle(fontSize: 10, color: _contentTextColor),
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _isShrinkSizedBox(Widget widget) {
    return widget is SizedBox && widget.width == 0 && widget.height == 0;
  }

  /// Total Balance 行
  Widget _buildTotalBalance() {
    if (!widget.showTotalBalance ||
        widget.totalBalance == null ||
        widget.totalBalance!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Balance',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _contentTextColor),
        ),
        const SizedBox(height: 4),
        Text(
          '\$ ${widget.totalBalance}',
          style: _titleStyle,
        ),
      ],
    );
  }

  List<Widget> _withSpacing(List<Widget> children, {double spacing = 12}) {
    final List<Widget> result = [];
    for (final child in children) {
      if (child is SizedBox && child.width == 0 && child.height == 0) continue;
      result.add(child);
      result.add(SizedBox(height: spacing));
    }
    if (result.isNotEmpty) {
      result.removeLast(); // 移除最后一个间距
    }
    return result;
  }

  List<_CornerItem> _buildCornerIconItems() {
    final List<_CornerItem> items = [];

    void addItem({String? imageUrl, String? label}) {
      if (imageUrl?.isNotEmpty != true && label?.isNotEmpty != true) return;
      items.add(_CornerItem(imageUrl: imageUrl, label: label));
    }

    /// 1️⃣ Card Logo
    if (pageConfig.isShowCardLogo == true) {
      addItem(imageUrl: card.logo);
    }

    /// 2️⃣ Brand
    if (pageConfig.isShowCardBrandImage == true ||
        pageConfig.isShowCardBrand == true) {
      addItem(
        imageUrl:
            pageConfig.isShowCardBrandImage == true ? card.brandImage : null,
        label: pageConfig.isShowCardBrand == true ? card.brandName : null,
      );
    }

    /// 3️⃣ Merchant
    if (pageConfig.isShowCardMerchantLogo == true ||
        pageConfig.isShowCardMerchantName == true) {
      addItem(
        imageUrl: pageConfig.isShowCardMerchantLogo == true
            ? card.merchant?.logo
            : null,
        label: pageConfig.isShowCardMerchantName == true
            ? card.merchant?.name
            : null,
      );
    }

    /// 4️⃣ Shape
    if (pageConfig.isShowCardShapeImage == true ||
        pageConfig.isShowCardShape == true) {
      addItem(
        imageUrl: pageConfig.isShowCardShapeImage == true
            ? card.shape?.imageUrl
            : null,
        label: pageConfig.isShowCardShape == true ? card.shape?.name : null,
      );
    }

    return items;
  }

  Widget _buildCardNo() {
    if (pageConfig.isShowCardNo == true && card.cardNo?.isNotEmpty == true) {
      final style = _isOnlyCardNoVisible()
          ? _titleStyle.copyWith(fontSize: 18, height: 1.1)
          : _titleStyle;
      return Text(card.cardNo!, style: style, maxLines: 2);
    }
    return const SizedBox.shrink();
  }

  bool _isOnlyCardNoVisible() {
    return false;
  }

  Widget _buildMerchantTitle() {
    if (pageConfig.isShowCardMerchantTitle != true ||
        card.merchant == null ||
        card.merchant!.title == null ||
        card.merchant!.title!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            card.merchant?.title?.isNotEmpty == true
                ? card.merchant!.title!
                : "-",
            style: _specialTitleStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    if (pageConfig.isShowPostCardName != true ||
        card.contact == null ||
        card.contact!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      card.contact?.isNotEmpty == true ? card.contact! : "--",
      style: _valueStyle,
    );
  }

  Widget _buildMobile() {
    if (pageConfig.isShowPostCardMobile != true ||
        card.mobile == null ||
        card.mobile!.isEmpty) {
      return const SizedBox.shrink();
    }

    // final showIcon = pageConfig.isShowPostCardIcon ?? false;

    return Row(
      children: [
        // if (showIcon) ...[
        Image(
          image: const AssetImage('assets/images/card_wifi_calling_icon.png'),
          height: 16,
          width: 16,
          color: _primaryText, // 想要的颜色
          colorBlendMode: BlendMode.srcIn, // 用颜色替换原始像素
        ),
        const SizedBox(width: 8),
        // ],
        Expanded(child: Text(card.mobile ?? '-', style: _valueStyle)),
      ],
    );
  }

  Widget _buildEmail() {
    if (pageConfig.isShowPostCardEmail != true ||
        card.email == null ||
        card.email!.isEmpty) {
      return const SizedBox.shrink();
    }

    // final showIcon = pageConfig.isShowPostCardIcon ?? false;

    return Row(
      children: [
        // if (showIcon) ...[
        Image(
          image: const AssetImage('assets/images/card_mail_icon.png'),
          height: 16,
          width: 16,
          color: _primaryText, // 想要的颜色
          colorBlendMode: BlendMode.srcIn, // 用颜色替换原始像素
        ),
        const SizedBox(width: 8),
        // ],
        Expanded(child: Text(card.email ?? '-', style: _valueStyle)),
      ],
    );
  }

  // Widget _buildQR() {
  //   if (pageConfig.isShowvCard != true) {
  //     return const SizedBox.shrink();
  //   }

  //   final showIcon = pageConfig.isShowvCard ?? false;
  //   print("_buildQRshowIcon:$showIcon");
  //   return Row(
  //     children: [
  //       if (showIcon) ...[
  //         GestureDetector(
  //           onTap: () {
  //             // 点击回调
  //             print('icon tapped');
  //             onTapQR();
  //           },
  //           child: Image(
  //             image: const AssetImage('assets/images/qr_code1.png'),
  //             height: 25,
  //             width: 25,
  //             color: _primaryText,
  //             colorBlendMode: BlendMode.srcIn,
  //           ),
  //         ),
  //       ],
  //     ],
  //   );
  // }

  Widget _buildAddress() {
    if (pageConfig.isShowPostCardAddress != true ||
        card.address == null ||
        card.address!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (pageConfig.isShowPostCardIcon == true) ...[
        Image(
          image: const AssetImage('assets/images/card_address_icon.png'),
          height: 16,
          width: 16,
          color: _primaryText, // 想要的颜色
          colorBlendMode: BlendMode.srcIn, // 用颜色替换原始像素
        ),
        const SizedBox(width: 8),
        // ],
        Expanded(
          child: Text(
            card.address ?? '-',
            style: _valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    if (pageConfig.isShowCardDescription != true ||
        card.description == null ||
        card.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Html(
      data: card.description!,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: _primaryText,
          fontSize: FontSize(16),
        ),
      },
    );
  }
}

class _CornerItem {
  final String? imageUrl;
  final String? label;

  _CornerItem({this.imageUrl, this.label});
}
