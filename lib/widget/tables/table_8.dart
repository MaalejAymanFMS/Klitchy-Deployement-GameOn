import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

import 'chair.dart';
import 'dinner_table.dart';

class TableEight extends StatelessWidget {
  final double rotation;
  final String? id;
  final String? name;
  const TableEight(
      {Key? key,
        required this.rotation,
        this.id,
      this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(rotation / 360),
      child: SizedBox(
        width: 128.h,
        height: 70.5.v,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top row with 3 chairs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chair(270),
                  SizedBox(width: 11.h),
                  Chair(270),
                  SizedBox(width: 11.h),
                  Chair(270),
                ],
              ),
              SizedBox(height: 2.5.v),
              // Table with 1 chair on the left, 1 chair on the right
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chair(180),
                  SizedBox(width: 2.5.h),
                  DinnerTable(8),
                  SizedBox(width: 2.5.h),
                  Chair(0),
                ],
              ),
              SizedBox(height: 2.5.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chair(90),
                  SizedBox(width: 11.h),
                  Chair(90),
                  SizedBox(width: 11.h),
                  Chair(90),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}