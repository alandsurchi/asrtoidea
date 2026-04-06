import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_export.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      if (this.endsWith('.svg')) {
        return ImageType.networkSvg;
      }
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, networkSvg, file, unknown }

class CustomImageView extends StatelessWidget {
  const CustomImageView({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder,
  });

  ///[imagePath] is required parameter for showing image
  final String? imagePath;

  /// Resolved image path — falls back to imgImageNotFound if null/empty
  String get _resolvedPath =>
      (imagePath == null || imagePath!.isEmpty)
          ? ImageConstant.imgImageNotFound
          : imagePath!;

  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final String? placeHolder;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    Widget childWidget = _buildCircleImage();
    
    if (onTap != null) {
      childWidget = InkWell(
        onTap: onTap,
        child: childWidget,
      );
    }
    
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: childWidget,
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    switch (_resolvedPath.imageType) {
      case ImageType.svg:
        return Container(
          height: height,
          width: width,
          child: SvgPicture.asset(
            _resolvedPath,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: this.color != null
                ? ColorFilter.mode(
                    this.color ?? appTheme.transparentCustom,
                    BlendMode.srcIn,
                  )
                : null,
          ),
        );
      case ImageType.file:
        return Image.file(
          File(_resolvedPath),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      case ImageType.networkSvg:
        return SvgPicture.network(
          _resolvedPath,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          colorFilter: this.color != null
              ? ColorFilter.mode(
                  this.color ?? appTheme.transparentCustom,
                  BlendMode.srcIn,
                )
              : null,
        );
      case ImageType.network:
        return CachedNetworkImage(
          height: height,
          width: width,
          fit: fit,
          imageUrl: _resolvedPath,
          color: color,
          placeholder: (context, url) => Container(
            height: 30,
            width: 30,
            child: LinearProgressIndicator(
              color: appTheme.grey200,
              backgroundColor: appTheme.grey100,
            ),
          ),
          errorWidget: (context, url, error) => _RasterPlaceholder(
            height: height,
            width: width,
            fit: fit,
          ),
        );
      case ImageType.png:
      default:
        return Image.asset(
          _resolvedPath,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return _RasterPlaceholder(
              height: height,
              width: width,
              fit: fit,
            );
          },
        );
    }
  }
}

class _RasterPlaceholder extends StatelessWidget {
  const _RasterPlaceholder({
    this.height,
    this.width,
    this.fit,
  });

  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final w = width == double.infinity ? null : width;
    return SizedBox(
      height: height,
      width: w,
      child: Container(
        alignment: Alignment.center,
        color: const Color(0xFFE8E8EE),
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 28,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
