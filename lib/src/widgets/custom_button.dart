import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_container.dart';
import 'custom_text.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  gradient,
  glass,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final List<Color>? gradientColors;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.gradientColors,
    this.borderRadius,
    this.padding,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle();
    final effectiveTextColor = textColor ?? _getDefaultTextColor();
    final effectiveBgColor = backgroundColor ?? _getDefaultBgColor();
    final effectiveBorderColor = borderColor ?? _getDefaultBorderColor();

    Widget buttonChild = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveTextColor,
            ),
          )
        else if (icon != null)
          Icon(icon, size: _getIconSize(), color: effectiveTextColor),
        if (icon != null || isLoading) const SizedBox(width: 8),
        CustomText(
          text: text,
          style: textStyle.copyWith(color: effectiveTextColor),
        ),
      ],
    );

    Widget button;

    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: effectiveTextColor,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            elevation: 0,
            disabledBackgroundColor: effectiveBgColor.withValues(alpha: 0.5),
            disabledForegroundColor: effectiveTextColor.withValues(alpha: 0.5),
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;

      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: effectiveTextColor,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            elevation: 0,
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;

      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveTextColor,
            side: BorderSide(color: effectiveBorderColor, width: 1.5),
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;

      case ButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: effectiveTextColor,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;

      case ButtonVariant.gradient:
        button = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors ?? AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: padding ?? _getPadding(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
              ),
              elevation: 0,
              minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
            ),
            child: buttonChild,
          ),
        );
        break;

      case ButtonVariant.glass:
        button = GlassContainer(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          blur: 10,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: padding ?? _getPadding(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
              ),
              elevation: 0,
              minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
            ),
            child: buttonChild,
          ),
        );
        break;
    }

    return button;
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall;
      case ButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case ButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }

  Color _getDefaultTextColor() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.gradient:
      case ButtonVariant.glass:
        return Colors.white;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
    }
  }

  Color _getDefaultBgColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.outline:
      case ButtonVariant.text:
      case ButtonVariant.gradient:
      case ButtonVariant.glass:
        return Colors.transparent;
    }
  }

  Color _getDefaultBorderColor() {
    switch (variant) {
      case ButtonVariant.outline:
        return AppColors.primary;
      default:
        return Colors.transparent;
    }
  }
}