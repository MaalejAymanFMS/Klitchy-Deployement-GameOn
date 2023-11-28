import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'chair.dart';
import 'dinner_table.dart';

class TableTwo extends StatelessWidget {
  final String? id;
  final String? name;
  final double rotation;
  const TableTwo(
      {Key? key,
        this.id,
        this.name,required this.rotation,})
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
              SizedBox(height: 2.5.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chair(180),
                  SizedBox(width: 2.5.h),
                  DinnerTable(4),
                  SizedBox(width: 2.5.h),
                  Chair(0),
                ],
              ),
              SizedBox(height: 2.5.v),
            ],
          ),
        ),
      ),
    );
  }
}