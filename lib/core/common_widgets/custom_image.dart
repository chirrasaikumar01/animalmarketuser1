import 'package:animal_market/core/color_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? baseUrl;
  final String placeholderAsset;
  final String? errorAsset;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double radius;

  const CustomImage({
    super.key,
    this.imageUrl,
    required this.placeholderAsset,
    this.errorAsset,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.baseUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageUrl != ""
          ? CachedNetworkImage(
              imageUrl: "$baseUrl$imageUrl",
              placeholder: (context, url) => SizedBox(
                height: height,
                width: width,
                child: Shimmer.fromColors(
                  baseColor: ColorConstant.white,
                  highlightColor: ColorConstant.grayCl,
                  child: Container(
                    height: height ?? 200,
                    width: width ?? 100,
                    color: ColorConstant.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                errorAsset!,
                fit: fit,
                height: height ?? 200,
                width: width,
              ),
              fit: fit,
              height: height,
              width: width,
            )
          : Image.asset(
              placeholderAsset,
              height: height ?? 200,
              width: width,
              fit: fit,
            ),
    );
  }
}
