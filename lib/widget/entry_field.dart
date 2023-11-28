import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

import '../config/app_colors.dart';

class EntryField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final String? label;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obsecureText;
  final String? validatorMessage;
  final bool? mismatchPassword;
  final Function(String)? onChanged;
  final Function()? onTap;

  const EntryField({
    Key? key,
    this.hintText,
    this.initialValue,
    this.label,
    this.textAlign,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.obsecureText,
    this.validatorMessage,
    this.mismatchPassword,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 18, color: Colors.black),
          ),
        if (label != null)  SizedBox(height: 16.h),
        TextFormField(
          textAlign: textAlign ?? TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontSize: 20.fSize,
              ),
          initialValue: initialValue,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Theme.of(context).backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: hintText ?? '',
            hintStyle: const TextStyle(color: AppColors.secondaryTextColor, ),
            // Theme.of(context).textTheme.bodySmall,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 22.h,
              vertical: 35.v,
            ),
          ),
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obsecureText ?? false,
          validator: (String? value) {
            if (value!.isEmpty || mismatchPassword == true) {
              return validatorMessage;
            } else if (mismatchPassword == false &&
                !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                    .hasMatch(value)) {
              return 'At least 8 characters with (abc ABC 012 @\$!%*#?&)';
            } else if (keyboardType == TextInputType.emailAddress &&
                !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                    .hasMatch(value)) {
              return 'Please enter a valid email address.';
            } else if(value.length < 3 && keyboardType == TextInputType.text) {
              return "Field must be at least 3 characters";
            } else {
              return null;
            }
          },
          onChanged: onChanged,
          cursorColor: const Color(0xFF6948CE),
          onTap: onTap,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
