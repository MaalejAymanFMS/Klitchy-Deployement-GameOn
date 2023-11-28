import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

import 'chair.dart';
import 'dinner_table.dart';

class TableSix extends StatelessWidget {
  final double rotation;
  final String? id;
  final String? name;
  const TableSix(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DinnerTable(8),
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