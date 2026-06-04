import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// *@filename load_image.dart
/// *@Description: 图片加载（支持本地与网络图片）
class LoadImage extends StatelessWidget {
  const LoadImage(this.image,
      {Key? key,
      this.width,
      this.height,
      this.fit,
      this.format = "png",
      this.holderImg,
      this.package,
      this.showHolder = true,
      this.color})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String format;
  final Widget? holderImg;
  final String? package;
  final bool showHolder;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image == "null") {
      return Visibility(
          visible: showHolder,
          child: LoadAssetImage(
            'none',
            color: color,
            height: height,
            width: width,
            fit: fit,
            format: format,
            package: package,
          ));
    } else {
      if (image.startsWith("http")) {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => holderImg ?? const SizedBox(),
          errorWidget: (context, url, error) => holderImg ?? const SizedBox(),
          // color: color,
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return LoadAssetImage(
          image.isNotEmpty ? image : 'none',
          height: height,
          width: width,
          fit: fit,
          format: format,
          package: package,
        );
      }
    }
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.format = 'png',
    this.color,
    this.package,
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String format;
  final Color? color;
  final String? package;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$image.$format',
      fit: fit,
      width: width,
      height: height,
      color: color,
      package: package,
    );
  }
}
