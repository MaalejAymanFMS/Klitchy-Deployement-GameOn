import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

import '../../config/app_colors.dart';

class Room extends StatelessWidget {
  final String title;
  final String id;
  final bool isSelected;

  const Room(this.title, this.id,this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.v, horizontal: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Image.asset("assets/images/logo.png"),
            ),
            SizedBox(
              width: 10.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17.fSize),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.h,
                      height: 10.v,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    Text("online",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: AppColors.secondaryTextColor, fontSize: 15.5.fSize)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 25.fSize),

          ],
        ),
      ),
    );
  }
}
