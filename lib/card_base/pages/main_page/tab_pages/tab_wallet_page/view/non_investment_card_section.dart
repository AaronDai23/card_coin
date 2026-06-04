import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/state.dart';
import 'package:card_coin/card_base/utils/color_util.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NonInvestmentCardSection1 extends StatelessWidget {
  final MyCardState state;
  final AppLanguageResource languageResource;

  const NonInvestmentCardSection1({
    Key? key,
    required this.state,
    required this.languageResource,
  }) : super(key: key);

  Color get _primaryText {
    return ColorUtil.parseHexColor(
        state.cardDetail?.pageField?.fontColor ?? '#FFFFFF');
  }

  Color get _backgroundText {
    return ColorUtil.parseHexColor(
        state.cardDetail?.pageField?.backgroundColor ?? '#0000FF');
  }

  Color get _secondaryText {
    return ColorUtil.parseHexColor(
        state.cardDetail?.pageField?.fontColor ?? '#FFFFFF');
  }

  TextStyle get _titleStyle => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _primaryText,
      );

  TextStyle get _specialStyle => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: _secondaryText,
      );

  TextStyle get _specialTitleStyle => TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: _secondaryText,
      );

  TextStyle get _valueStyle => TextStyle(
        fontSize: 16,
        color: _primaryText,
      );

  @override
  Widget build(BuildContext context) {
    final card = state.cardDetail;
    if (card == null || card.category == 'INVESTMENT') {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        _buildCardBody(card),
        _buildShapeImage(card),
      ],
    );
  }

  /// 主卡片内容
  Widget _buildCardBody(SmartCardDetail card) {
    final hasBgImage = state.pageConfig.isShowCardBackgroundImage == true &&
        (card.background?.isNotEmpty == true);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// 背景层（图片 or 纯色）
            Positioned.fill(
              child: hasBgImage
                  ? LoadImage(
                      card.background!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: _backgroundText,
                    ),
            ),

            /// 可选：图片上加一层遮罩，保证文字可读性
            if (hasBgImage)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),

            /// 内容层
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardNo(card),
                  _gap(16),
                  _buildName(card),
                  _gap(12),
                  _buildMerchantTitle(card),
                  _gap(12),
                  _buildMobile(card),
                  _gap(12),
                  _buildEmail(card),
                  _gap(12),
                  _buildAddress(card),
                  _gap(12),
                  _buildDescription(card),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 右上角装饰图（按优先级)
  /// 纵向排列（Column）

//按固定优先级顺序尝试显示：

//1️⃣ Card Logo
//2️⃣ Brand Image + Brand Name
//3️⃣ Merchant Logo + Merchant Name
//4️⃣// Shape Image + Shape

////图标（image）和文字（label）不强绑定

//有 image 就显示 image

//有 label 就显示 label

//两者互不依赖

//不是只显示一个，而是按优先级依次往下排
//没有任何可显示内容时，整个角标不显示
  Widget _buildShapeImage(SmartCardDetail card) {
    final items = _buildCornerItems(card);

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    /// 最多 4 个 item（2 列 × 2 行）
    final limitedItems = items.take(4).toList();

    /// 每列 2 个
    final columns = <List<_CornerItem>>[
      limitedItems.take(2).toList(),
      if (limitedItems.length > 2) limitedItems.skip(2).take(2).toList(),
    ];

    return Positioned(
      top: 16,
      right: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl, // 👉 从右往左
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns.map((colItems) {
          return Padding(
            padding: const EdgeInsets.only(left: 2), // 列间距
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: colItems.map((item) => _buildCornerItem(item)).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCornerItem(_CornerItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2), // 项目间距
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.imageUrl?.isNotEmpty == true)
            LoadImage(
              item.imageUrl!,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          if (item.label?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SizedBox(
                width: 70, // ⭐ 关键：给固定或最大宽度
                child: Text(
                  _limitText(item.label!, maxLength: 80),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 10,
                    color: _primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _limitText(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength);
  }

  List<_CornerItem> _buildCornerItems(SmartCardDetail card) {
    final config = state.pageConfig;
    final List<_CornerItem> items = [];

    void addItem({String? imageUrl, String? label}) {
      final item = _CornerItem(imageUrl: imageUrl, label: label);
      if (!item.isEmpty) {
        items.add(item);
      }
    }

    /// 1️⃣ Card Logo
    if (config.isShowCardLogo == true) {
      addItem(imageUrl: card.logo);
    }

    /// 2️⃣ Brand Image + Brand Name
    if (config.isShowCardBrandImage == true || config.isShowCardBrand == true) {
      addItem(
        imageUrl: config.isShowCardBrandImage == true ? card.brandImage : null,
        label: config.isShowCardBrand == true ? card.brandName : null,
      );
    }

    /// 3️⃣ Merchant Logo + Merchant Name
    if (config.isShowCardMerchantLogo == true ||
        config.isShowCardMerchantName == true) {
      addItem(
        imageUrl:
            config.isShowCardMerchantLogo == true ? card.merchant?.logo : null,
        label:
            config.isShowCardMerchantName == true ? card.merchant?.name : null,
      );
    }

    /// 4️⃣ Shape Image + Shape
    if (config.isShowCardShapeImage == true || config.isShowCardShape == true) {
      addItem(
        imageUrl:
            config.isShowCardShapeImage == true ? card.shape?.imageUrl : null,
        label: config.isShowCardShape == true ? card.shape?.name : null,
      );
    }

    return items;
  }

  Widget _buildCardNo(SmartCardDetail card) {
    if ((card.cardNo?.isNotEmpty ?? false) &&
        state.pageConfig.isShowCardNo == true) {
      return Text(card.cardNo!, style: _titleStyle);
    }
    return const SizedBox.shrink();
  }

  Widget _buildName(SmartCardDetail card) {
    if (state.pageConfig.isShowPostCardName != true) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            card.contact?.isNotEmpty == true
                ? card.contact!
                : languageResource.yourRemark,
            style: _specialStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantTitle(SmartCardDetail card) {
    if (state.pageConfig.isShowCardMerchantTitle != true) {
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

  Widget _buildMobile(SmartCardDetail card) {
    if (state.pageConfig.isShowPostCardMobile != true) {
      return const SizedBox.shrink();
    }

    final showIcon = state.pageConfig.isShowPostCardIcon ?? false;

    return Row(
      children: [
        if (showIcon) ...[
          Icon(Icons.phone, size: 16, color: _secondaryText),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(card.mobile ?? '-', style: _valueStyle)),
      ],
    );
  }

  Widget _buildEmail(SmartCardDetail card) {
    if (state.pageConfig.isShowPostCardEmail != true) {
      return const SizedBox.shrink();
    }

    final showIcon = state.pageConfig.isShowPostCardIcon ?? false;

    return Row(
      children: [
        if (showIcon) ...[
          Icon(Icons.email, size: 16, color: _secondaryText),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(card.email ?? '-', style: _valueStyle)),
      ],
    );
  }

  Widget _buildAddress(SmartCardDetail card) {
    if (state.pageConfig.isShowPostCardAddress != true) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.pageConfig.isShowPostCardIcon == true) ...[
          Icon(Icons.location_on_outlined, size: 16, color: _secondaryText),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            card.address ?? '-',
            style: _valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(SmartCardDetail card) {
    if (state.pageConfig.isShowCardDescription != true ||
        card.description?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    return Html(
      data: card.description!,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(16),
          color: const Color(0xFF1F1F1F),
          lineHeight: LineHeight.number(1.6),
        ),
        "p": Style(margin: Margins.only(bottom: 12)),
        "li": Style(margin: Margins.only(bottom: 8)),
      },
    );
  }

  Widget _gap(double h) => SizedBox(height: h);
}

class _CornerItem {
  final String? imageUrl;
  final String? label;

  _CornerItem({this.imageUrl, this.label});

  bool get isEmpty =>
      (imageUrl == null || imageUrl!.isEmpty) &&
      (label == null || label!.isEmpty);
}
