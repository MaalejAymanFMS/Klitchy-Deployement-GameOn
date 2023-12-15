import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

import '../config/app_colors.dart';
class TableTimer extends StatelessWidget {
  final String? tableId;
  final String? tableName;
  final String? timer;
  const TableTimer({super.key, this.tableId, this.tableName, this.timer});

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
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(7),
                  ),
                  color: AppColors.turquoise.withOpacity(0.4)
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
                    tableName!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.fSize),
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      timer ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryTextColor),
                    ),
                    Text(
                      'Timer: 17:22',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryTextColor, fontSize: 15.fSize),
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
