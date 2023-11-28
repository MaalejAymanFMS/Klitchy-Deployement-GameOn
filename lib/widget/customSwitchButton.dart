import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/utils/size_utils.dart';

class CustomSwitchButton extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool initialValue;

  CustomSwitchButton({
    required this.onChanged,
    required this.initialValue,
  });

  @override
  _CustomSwitchButtonState createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: Container(
        width: 200.h,
        height: 50.v,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: <Widget>[
            // Expanded(
            //   child: Container(
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       color: _value
            //           ? AppColors.blueColor
            //           : AppColors.dark01Color, // Background color when selected
            //       borderRadius: BorderRadius.circular(2.0),
            //     ),
            //     child: Text(
            //       'USER LOGIN',
            //       style: TextStyle(
            //         color: AppColors.lightColor,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !_value
                      ? AppColors.blueColor
                      : AppColors
                          .dark01Color, // Background color when not selected
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Text(
                  'PIN LOGIN',
                  style: TextStyle(
                    color: AppColors.lightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
