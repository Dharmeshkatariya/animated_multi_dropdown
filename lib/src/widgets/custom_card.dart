import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_container.dart';
import 'custom_text.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final bool isGlass;
  final bool isGradient;
  final List<Color>? gradientColors;
  final bool hasShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.isGlass = false,
    this.isGradient = false,
    this.gradientColors,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || leading != null || trailing != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                if (leading != null) leading!,
                if (leading != null) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        CustomText(
                          text: title!,
                          style: AppTextStyles.titleMedium,
                        ),
                      if (subtitle != null)
                        CustomText(
                          text: subtitle!,
                          style: AppTextStyles.caption,
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        child,
      ],
    );

    if (isGradient && gradientColors != null) {
      return GradientContainer(
        colors: gradientColors!,
        padding: padding ?? const EdgeInsets.all(20),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: content,
      );
    }

    if (isGlass) {
      return GlassContainer(
        padding: padding ?? const EdgeInsets.all(20),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: content,
      );
    }

    return CustomContainer(
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      color: Colors.white,
      boxShadow: hasShadow ? AppShadows.medium : null,
      onTap: onTap,
      child: content,
    );
  }
}
