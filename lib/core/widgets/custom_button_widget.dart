import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_weather_app/core/theme/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String title;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final Widget? child;
  final Color? borderColor;
  final EdgeInsets? padding;

  const CustomButtonWidget({
    super.key,
    this.backgroundColor,
    this.textColor,
    required this.title,
    required this.onPressed,
    this.borderRadius,
    this.height,
    this.width,
    this.gradient,
    this.child,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 45.h,
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 12.r)),
          color: backgroundColor ?? AppColors.seed,
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 1),
          gradient: backgroundColor == null ? LinearGradient(
            colors: [
              AppColors.seed,
              AppColors.seed.withOpacity(0.4),
            ],
          ) : null,
        ),
        child:
            child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontSize: 18.spMax),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
