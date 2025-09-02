import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    super.key,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.isPassword = false,
    this.prefixIcon,
    this.labelText,
    this.hintText,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.fillColor,
    this.maxLength,
    this.isCounterText = false,
    this.suffixIcon,
    this.titleText,
    this.validator,
    this.initValue,
    this.borderColor,
  });

  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onChanged;
  final FormFieldSetter<String>? onSubmitted;
  final bool isPassword;
  final String? titleText;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final dynamic prefixIcon;
  final bool readOnly;
  final Color? fillColor;
  final int? maxLength;
  final bool? isCounterText;
  final dynamic suffixIcon;
  final String? initValue;
  final Color? borderColor;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool _obscureText;
  bool _reachMaxLength = false;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller =
        widget.controller ??
        TextEditingController(text: widget.initValue ?? '');
    super.initState();
    if (widget.maxLength != null) {
      _reachMaxLength = _controller.text.length >= widget.maxLength!;
    }
    _obscureText = widget.isPassword;
  }

  @override
  void didUpdateWidget(covariant CustomTextFieldWidget oldWidget) {
    if (widget.initValue != oldWidget.initValue) {
      _controller.text = widget.initValue ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleText != null) ...[
          Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
            child: Text(
              widget.titleText!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: 17.spMax),
            ),
          ),
        ],
        Container(
          padding: EdgeInsets.only(
            left: 4.w,
            top: 4.h,
            bottom: 4.h,
            right: 4.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: widget.borderColor ?? AppColors.seed, width: 1),
          ),
          child: TextFormField(
            enabled: true,
            autofocus: false,
            controller: _controller,
            obscureText: _obscureText,
            textInputAction: widget.textInputAction,
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              isDense: true,
              counterText: widget.isCounterText! ? null : '',
              filled: true,
              fillColor:
                  widget.fillColor ??
                  Colors.transparent,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: 10.w,
                top: 6.h,
                bottom: 6.h,
                right: widget.isPassword ? 0 : 10.w,
              ),
              hintText: widget.hintText,
              errorMaxLines: 1000,
              labelText: widget.labelText,
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : (widget.prefixIcon is String
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: 0.w,
                              top: 12.h,
                              bottom: 12.h,
                            ),
                            child: Image.asset(
                              widget.prefixIcon,
                              fit: BoxFit.fitHeight,
                              height: 20.r,
                              width: 20.r,
                              color: AppColors.darkBackground,
                            ),
                          )
                        : Icon(
                            widget.prefixIcon,
                            size: 20.h,
                            color: AppColors.darkBackground,
                          )),
              suffixIcon: (widget.isPassword)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.isPassword) {
                            _obscureText = !_obscureText;
                            return;
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 5.h,
                          bottom: 5.h,
                          left: 10.w,
                          right: 10.w,
                        ),
                        child: widget.isPassword
                            ? Icon(
                                widget.suffixIcon != null
                                    ? (widget.suffixIcon ??
                                          Icons.remove_red_eye_outlined)
                                    : _obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye_sharp,
                                size: 20.w,
                                color: AppColors.darkBackground,
                              )
                            : null,
                      ),
                    )
                  : (widget.suffixIcon is Widget
                        ? Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: widget.suffixIcon,
                          )
                        : null),
              suffixIconConstraints: BoxConstraints(
                minHeight: 18.5.h,
                minWidth: 18.5.w,
              ),
            ),
            keyboardType: widget.keyboardType,
            onChanged: (value) {
              setState(() {
                if (widget.maxLength != null) {
                  _reachMaxLength = value.length >= widget.maxLength!;
                }
                widget.onChanged?.call(value);
              });
            },
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ],
    );
  }
}
