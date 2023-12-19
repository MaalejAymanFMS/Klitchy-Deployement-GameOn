import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/size_utils.dart';

import '../config/app_colors.dart';
class TableTimer extends StatefulWidget {
  final String? tableId;
  final String? tableName;
  final String? timer;
  const TableTimer({super.key, this.tableId, this.tableName, this.timer});

  @override
  State<TableTimer> createState() => _TableTimerState();
}

class _TableTimerState extends State<TableTimer> {
  DateTime now = DateTime.now();



  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 379.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58.h,
              height: 58.v,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                  color: Colors.red,
              ),
              child: const Icon(Icons.table_bar_outlined, color: Colors.white,),
            ),
            SizedBox(width: 30.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200.h,
                  child: Text(
                    widget.tableName!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12.fSize),
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    Text(
                     "${now.hour}:${now.minute}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
