import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final Widget? child;
  final TextStyle? style;
  final IconData? icon;
  final Color? iconColor;
  final Alignment alignment;
  final double iconSpacing;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final bool? softWrap;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;
  final bool isGradient;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;

  const CustomText({
    super.key,
    this.text,
    this.child,
    this.style,
    this.icon,
    this.iconColor,
    this.alignment = Alignment.centerLeft,
    this.iconSpacing = 8.0,
    this.textAlign,
    this.textOverflow,
    this.textDirection,
    this.softWrap,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.isGradient = false,
    this.gradientColors,
    this.onTap,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    if (child != null) {
      contentWidget = child!;
      if (style != null) {
        contentWidget = DefaultTextStyle.merge(
          style: style!,
          child: contentWidget,
        );
      }
    } else {
      contentWidget = Text(
        text!,
        style: style ?? AppTextStyles.bodyMedium,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: textOverflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
        textDirection: textDirection,
        softWrap: softWrap,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
        strutStyle: strutStyle,
      );
    }

    if (isGradient && text != null) {
      contentWidget = ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: gradientColors ?? AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: contentWidget,
      );
    }

    if (onTap != null) {
      contentWidget = GestureDetector(
        onTap: onTap,
        child: contentWidget,
      );
    }

    if (icon != null) {
      return Align(
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor ?? style?.color ?? AppColors.primary),
            SizedBox(width: iconSpacing),
            contentWidget,
          ],
        ),
      );
    }

    return Align(alignment: alignment, child: contentWidget);
  }
}

// Predefined text styles for quick use
class AppText {
  static Widget displayLarge(String text, {TextAlign? textAlign}) => CustomText(
    text: text,
    style: AppTextStyles.displayLarge,
    textAlign: textAlign,
  );

  static Widget displayMedium(String text, {TextAlign? textAlign}) =>
      CustomText(
        text: text,
        style: AppTextStyles.displayMedium,
        textAlign: textAlign,
      );

  static Widget headlineLarge(String text, {TextAlign? textAlign}) =>
      CustomText(
        text: text,
        style: AppTextStyles.headlineLarge,
        textAlign: textAlign,
      );

  static Widget titleLarge(String text, {TextAlign? textAlign}) => CustomText(
    text: text,
    style: AppTextStyles.titleLarge,
    textAlign: textAlign,
  );

  static Widget titleMedium(String text, {TextAlign? textAlign}) => CustomText(
    text: text,
    style: AppTextStyles.titleMedium,
    textAlign: textAlign,
  );

  static Widget bodyLarge(String text, {TextAlign? textAlign}) => CustomText(
    text: text,
    style: AppTextStyles.bodyLarge,
    textAlign: textAlign,
  );

  static Widget bodyMedium(String text, {TextAlign? textAlign}) => CustomText(
    text: text,
    style: AppTextStyles.bodyMedium,
    textAlign: textAlign,
  );

  static Widget caption(String text, {TextAlign? textAlign}) => CustomText(
    text: text,
    style: AppTextStyles.caption,
    textAlign: textAlign,
  );

  static Widget fromWidget(Widget child, {TextStyle? style}) => CustomText(
    style: style,
    child: child,
  );
}