library right_drawer;

import 'package:flutter/material.dart';
import 'package:klitchyapp/models/orders.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/viewmodels/right_drawer_interractor.dart';
import 'package:klitchyapp/widget/custom_button.dart';
import 'package:klitchyapp/widget/right_drawer/buttom_component.dart';
import 'package:klitchyapp/widget/right_drawer/table_tag.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../config/app_colors.dart';
import '../utils/AppState.dart';
import '../utils/locator.dart';
import '../widget/entry_field.dart';
import '../widget/order_component.dart';

class RightDrawer extends StatefulWidget {
  final String tableName;
  final String tableId;
  final AppState appState;

  const RightDrawer({
    required this.tableName,
    required this.tableId,
    required this.appState,
    Key? key,
  }) : super(key: key);

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  final TextEditingController orderNote = TextEditingController();
  final interactor = getIt<RightDrawerInterractor>();
  List<EntryItem> orders = [];
  String orderId = "";
  bool isUpdating = false;

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.appState.deleteAllOrders();
    Map<String, dynamic> params = {
      "fields": ["name", "table", "table_description"],
      "filters": [
        ["table_description", "LIKE", (widget.tableId)],
        ["status", "LIKE", "Attending"],
      ]
    };
    var orderP1 = await interactor.retrieveTableOrderPart1(params);
    if (orderP1.dataP1!.isNotEmpty) {
      var orderP2 =
          await interactor.retrieveTableOrderPart2(orderP1.dataP1![0].name!);
      if (orderP2.dataP2!.entryItems!.isNotEmpty) {
        setState(() {
          orderId = orderP1.dataP1![0].name!;
        });
        prefs.setString("orderId", orderId);
        orders = orderP2.dataP2!.entryItems!;
        for (var order in orders) {
          widget.appState.addOrder(
            order.qty as int,
            OrderComponent(
              number: order.qty!.toInt(),
              name: order.item_name!,
              price: order.rate ?? 0,
              image: "",
              note: order.notes,
              code: order.item_code!,
              status: order.status!,
            ),
          );
          widget.appState.addEntryItem(
              order.qty!,
              EntryItem(
                  name: order.name,
                  owner: order.owner,
                  item_name: order.item_name,
                  item_group: order.item_group,
                  creation: order.creation,
                  identifier: "identifier",
                  parentfield: "entry_items",
                  parenttype: "Table Order",
                  item_code: order.item_code!,
                  status: order.status!,
                  notes: "",
                  qty: order.qty!,
                  rate: order.rate,
                  price_list_rate: order.rate,
                  amount: order.qty! * order.rate!,
                  table_description:
                      "${widget.appState.choosenRoom["name"]} (Table)",
                  doctype: "Order Entry Item"));
        }
        print(widget.appState.entryItems
            .map((entryMap) => entryMap.toJson())
            .toList());
      }
    }
  }

  Future<void> addOrders() async {
    for (var item in widget.appState.entryItems) {
      widget.appState.updateEntryItemStatus(item.item_code!, "Sent");
    }
    Map<String, dynamic> body = {
      "room": widget.appState.choosenRoom["id"],
      "table": widget.tableName,
      "table_description": widget.tableId,
      "room_description": widget.appState.choosenRoom["name"],
      "naming_series": "OR-.YYYY.-",
      "status": "Attending",
      "customer": "Defult Customer",
      "pos_profile": "Caissier",
      "selling_price_list": "Standard Selling",
      "company": "Jumpark",
      "doctype": "Table Order",
      "amount": widget.appState.total,
      "tax": widget.appState.tva,
      "entry_items": widget.appState.entryItems
          .map((entryMap) => entryMap.toJson())
          .toList(),
    };
    await interactor.addOrder(body);
  }

  Future<void> updateOrder() async {
    for (var item in widget.appState.entryItems) {
      widget.appState.updateEntryItemStatus(item.item_code!, "Sent");
    }
    Map<String, dynamic> body = {
      "amount": widget.appState.total,
      "tax": widget.appState.tva,
      "discount": widget.appState.discount,
      "entry_items": widget.appState.entryItems
          .map((entryMap) => entryMap.toJson())
          .toList(),
    };
    await interactor.updateOrder(body, orderId);

  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.h,
      height: 900.v,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.v),
        child: Column(
          children: [
            TableTag(widget.appState, widget.tableName,
                orderId.isEmpty ? addOrders : updateOrder),
            Expanded(
              child: widget.appState.orders.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Items",
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.fSize),
                          ),
                          Column(
                            children: widget.appState.orders.map((order) {
                              return InkWell(
                                onTap: () {
                                  if (widget.appState.enabledNotes) {
                                    showOrderDetails(order, widget.appState);
                                  }
                                  if (widget.appState.enabledDelete) {
                                    widget.appState
                                        .deleteOrder(order.number, order);
                                    print("order number ${order.number}");
                                    // widget.appState.addEntryItem(order.number.toDouble(), EntryItem(
                                    //     identifier: "identifier",
                                    //     parentfield: "entry_items",
                                    //     parenttype: "Table Order",
                                    //     item_code: order.code,
                                    //     status: "Attending",
                                    //     notes: "",
                                    //     qty: order.number.toDouble(),
                                    //     rate: order.price / order.number,
                                    //     price_list_rate: order.price,
                                    //     amount: order.price,
                                    //     table_description: "${widget.appState.choosenRoom["name"]} (Table)",
                                    //     doctype: "Order Entry Item"));
                                  }
                                },
                                child: order,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
            ButtomComponent(

              onTap: () async {

                if (orderId.isEmpty) {
                  await addOrders();
                  await fetchOrders();
                } else {
                  await updateOrder();
                  await fetchOrders();
                }


              }
              //orderId.isEmpty ? addOrders : updateOrder
              ,
              appState: widget.appState,
            ),
          ],
        ),
      ),
    );
  }

  void showOrderDetails(OrderComponent order, AppState appState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(order.name),
          content: SizedBox(
            height: 570.v,
            child: Column(
              children: [
                EntryField(
                  label: "Note",
                  hintText: "note",
                  controller: orderNote,
                ),
                SizedBox(
                  height: 50.v,
                ),
                CustomButton(
                  text: "add note",
                  onTap: () {
                    appState.updateOrderNote(order.name, orderNote.text);
                    orderNote.clear();
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
                      type: VirtualKeyboardType.Alphanumeric,
                      textController: orderNote),
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
                orderNote.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
