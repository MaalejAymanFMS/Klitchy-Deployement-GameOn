import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/utils/size_utils.dart';


class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final String? icon;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool? disabledButton;

  const CustomButton(
      {Key? key,
        this.onTap,
        this.text,
        this.icon,
        this.backgroundColor,
        this.textStyle,
        this.disabledButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabledButton != null ?
      disabledButton == true ?
      onTap : null
          : onTap,
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(color: backgroundColor != null ?
          disabledButton == false ?
          Colors.grey.withOpacity(0.2) : backgroundColor!.withOpacity(0.5)
              :
          AppColors.primaryColor
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
        backgroundColor: MaterialStateProperty.all(
            backgroundColor != null ?
            disabledButton == false ?
            Colors.grey.withOpacity(0.2) : backgroundColor!.withOpacity(0.5)
                :
            AppColors.primaryColor),
      ),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 30.h),
              child: Image.asset(
                icon!,
                scale: 2.fSize,
              ),
            ),
          if (icon != null)
            const Spacer(
              flex: 2,
            ),
          Expanded(
            flex: icon != null ? 0 : 1,
            child: Text(
              text ?? "Continue",
              // maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textStyle ??
                  Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 16.fSize,
                    color: backgroundColor !=
                        Theme.of(context).scaffoldBackgroundColor
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).cardColor,
                    fontWeight: backgroundColor !=
                        Theme.of(context).scaffoldBackgroundColor
                        ? null
                        : FontWeight.w400,
                  ),
            ),
          ),
          if (icon != null)
            const Spacer(
              flex: 3,
            ),
        ],
      ),
    );
  }
}
