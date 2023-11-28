import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../config/app_colors.dart';
import '../../models/orders.dart';
import '../custom_button.dart';
import '../entry_field.dart';

class TableTag extends StatefulWidget {
  final AppState appState;
  final String? tableName;
  final Function()? delete;

  const TableTag(this.appState, this.tableName, this.delete, {super.key});

  @override
  State<TableTag> createState() => _TableTagState();
}

class _TableTagState extends State<TableTag> {
  Color editColor = Colors.transparent;
  Color deleteColor = Colors.transparent;
  String nameWaiter = "";
  final TextEditingController orderDiscount = TextEditingController();


  fetchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameWaiter = prefs.getString("full_name")!;
    });
  }

  @override
  void initState() {
    fetchPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 383.h,
      height: 94.v,
      decoration: BoxDecoration(
        color: AppColors.itemsColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1.h,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 140.1.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Table ${widget.tableName ?? "2"}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.fSize),
                        ),
                        SizedBox(
                          height: 10.v,
                        ),
                        Text(
                          nameWaiter,
                          style: TextStyle(
                              color: AppColors.secondaryTextColor,
                              fontSize: 15.fSize),
                        )
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.secondaryTextColor,
                  size: 30.fSize,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              widget.appState.enableDiscount();
              setState(() {
                if (widget.appState.enabledDiscount) {
                  showOrderDiscount(widget.appState);
                }
              });
            },
            child: Container(
                width: 64.h,
                height: 94.v,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1.h,
                  ),
                  color: widget.appState.enableColorDiscount,
                ),
              child: Center(child: Text("%", style: TextStyle(color: Colors.white, fontSize: 20.fSize),))
              // Image.asset(
              //   "assets/images/tag.png",
              //   color: Colors.white,
              //   scale: 2.2.fSize,
              // ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.appState.enableNotes();
              setState(() {
                if (widget.appState.enabledNotes) {
                  editColor = AppColors.redColor;
                } else {
                  editColor = Colors.transparent;
                }
              });
            },
            child: Container(
              width: 64.h,
              height: 94.v,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 1.h,
                ),
                color: widget.appState.enableColorNotes,
              ),
              child: Image.asset(
                "assets/images/modify.png",
                color: Colors.white,
                scale: 2.2.fSize,
              ),
            ),
          ),
          InkWell(
            onTap: () {

              widget.appState.enableDelete();
              setState(() {
                if (widget.appState.enabledDelete) {
                  widget.appState.addDiscount("-1");
                  deleteColor = AppColors.redColor;

                } else {
                  deleteColor = Colors.transparent;

                  widget.appState.deleteEntryItems();
                  // for (var order in widget.appState.orders) {
                  //   widget.appState.addEntryItem(
                  //       order.number.toDouble(),
                  //       EntryItem(
                  //           identifier: "identifier",
                  //           parentfield: "entry_items",
                  //           parenttype: "Table Order",
                  //           item_code: order.code,
                  //           status: "Attending",
                  //           notes: "",
                  //           qty: order.number.toDouble(),
                  //           rate: order.price,
                  //           price_list_rate: order.price,
                  //           amount: order.price * order.number,
                  //           table_description:
                  //               "${widget.appState.choosenRoom["name"]} (Table)",
                  //           doctype: "Order Entry Item"));
                  // }
                  widget.delete!();
                }
              });
            },
            child: Container(
              width: 64.h,
              height: 94.v,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 1.h,
                ),
                color: widget.appState.enableColorDelete,
              ),
              child: Image.asset(
                "assets/images/trash.png",
                color: Colors.white,
                scale: 2.2.fSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void showOrderDiscount(AppState appState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Discount"),
          content: SizedBox(
            height: 570.v,
            width: 500.h,
            child: Column(
              children: [
                EntryField(
                  label: "Discount %:",
                  hintText: "0.0%",
                  controller: orderDiscount,
                ),
                SizedBox(
                  height: 50.v,
                ),
                CustomButton(
                  text: "confirm discount",
                  onTap: () {
                    appState.addDiscount(orderDiscount.text);
                    widget.delete!();
                    widget.appState.enableDiscount();
                    orderDiscount.clear();
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.blueGrey,
                ),
                SizedBox(
                  height: 20.v,
                ),
                const Spacer(),
                Container(
                  color: AppColors.itemsColor,
                  child: VirtualKeyboard(
                      height: 300.v,
                      textColor: Colors.white,
                      type: VirtualKeyboardType.Numeric,
                      textController: orderDiscount),
                ),
                SizedBox(
                  height: 20.v,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                    color: AppColors.redColor,
                    fontSize: 20.fSize,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                orderDiscount.clear();
                widget.appState.enableDiscount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
