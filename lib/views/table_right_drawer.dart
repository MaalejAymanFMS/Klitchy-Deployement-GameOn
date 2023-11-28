import 'package:flutter/material.dart';
import 'package:klitchyapp/models/orders.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/viewmodels/right_drawer_interractor.dart';
import 'package:klitchyapp/widget/custom_button.dart';
import 'package:klitchyapp/widget/right_drawer/buttom_component.dart';
import 'package:klitchyapp/widget/right_drawer/table_tag.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../config/app_colors.dart';
import '../utils/AppState.dart';
import '../utils/locator.dart';
import '../widget/entry_field.dart';
import '../widget/order_component.dart';
class TableRightDrawer extends StatefulWidget {
  final String? tableId;
  final AppState? appState;
  const TableRightDrawer({
    this.tableId,
    this.appState,
    Key? key,
  }) : super(key: key);

  @override
  State<TableRightDrawer> createState() => _TableRightDrawerState();
}


class _TableRightDrawerState extends State<TableRightDrawer> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 383.h,
      height: 887.v,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.v),
        child: Column(
          children: [
            Expanded(
              child: widget.appState!.tableTimer.isNotEmpty
                  ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "List of tables",
                      style: TextStyle(color: Colors.white),
                    ),
                    Column(
                      children: widget.appState!.tableTimer.map((tableTimer) {
                        return InkWell(
                          onTap: () {
                            // showOrderDetails(order, appState);
                          },
                          child: tableTimer,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}