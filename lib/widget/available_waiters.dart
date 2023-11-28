import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/widget/waiter_tag.dart';

import '../config/app_colors.dart';

class AvailableWaiters extends StatelessWidget {
  final int tablesNumber;
  final String? roomName;

  const AvailableWaiters(this.tablesNumber, this.roomName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available waiters",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.fSize),
            ),
            Text(
              "$roomName : $tablesNumber Tables",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: AppColors.secondaryTextColor, fontSize: 20.fSize),
            ),
          ],
        ),
        SizedBox(width: 825.h),
        // SizedBox(
        //   width: 200.h,
        // ),
        // const WaiterTag(AppColors.secondaryTextColor, "JK.png", "Jamel K."),
        //  SizedBox(
        //   width: 50.h,
        // ),
        // const WaiterTag(AppColors.secondaryTextColor, "SA.png", "Samira A."),
        // SizedBox(
        //   width: 50.h,
        // ),
        // const WaiterTag(AppColors.secondaryTextColor, "MH.png", "Maheb H."),
      ],
    );
  }
}
