import 'package:flutter/material.dart';
import 'package:klitchyapp/models/orders.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_colors.dart';
import '../../utils/AppState.dart';
import '../../utils/constants.dart';
import '../order_component.dart';

class Item extends StatefulWidget {
  final String name;
  final String code;
  final double price;
  final int stock;
  final String image;
  final AppState appState;

  const Item({
    Key? key,
    required this.name,
    required this.price,
    required this.stock,
    required this.image,
    required this.appState,
    required this.code,
  }) : super(key: key);

  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {
  int numberOfItems = 0;

  void handleMinus() {
    if (numberOfItems > 0) {
      setState(() {
        numberOfItems -= 1;
      });
    }
  }

  void handlePlus() {
    if (numberOfItems < widget.stock) {
      setState(() {
        numberOfItems += 1;
      });
    }
  }

  void test() {
    int updatedNumberOfItems = 0;
    if (widget.appState.orders.isNotEmpty) {
      for (var i = 0; i < widget.appState.orders.length; i++) {
        if (widget.appState.orders[i].name == widget.name) {
          updatedNumberOfItems = widget.appState.orders[i].number;
          break;
        }
      }
    }
    setState(() {
      numberOfItems = updatedNumberOfItems;
    });
  }
  String token = "";
  fetchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token")!;
    });
  }
  @override
  void initState() {
    fetchPrefs();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    test();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final headers = {
      "Authorization": token
    };
    return GestureDetector(
      onTap: () {
        handlePlus();
        appState.addOrder(
          numberOfItems,
          OrderComponent(
            number: numberOfItems,
            name: widget.name,
            price: widget.price,
            image: widget.image,
            code: widget.code,
            status: "Attending",
          ),
        );
        appState.addEntryItem(
            numberOfItems.toDouble(),
            EntryItem(
                identifier: "identifier",
                parentfield: "entry_items",
                parenttype: "Table Order",
                item_code: widget.code,
                status: "Attending",
                notes: "",
                qty: numberOfItems.toDouble(),
                rate: widget.price,
                price_list_rate: widget.price,
                amount: numberOfItems * widget.price,
                table_description: "${appState.choosenRoom["name"]} (Table)",
                doctype: "Order Entry Item"));
      },
      child: Container(
        width: 274.h,
        height: 134.v,
        decoration: BoxDecoration(
          color: AppColors.itemsColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150.h,
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15.fSize),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 10.v,
                  ),
                  Text(
                    "${widget.price} TND",
                    style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 15.fSize),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58.h,
                    height: 58.v,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: widget.image != "null image" &&
                            widget.image.isNotEmpty
                        ? Image(
                            image: NetworkImage("$baseUrlImage${widget.image}",
                                headers: headers),
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            "assets/images/shawarma.png",
                            scale: 2.5.fSize,
                          ),
                  ),
                ],
              )
              // const Spacer(),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     SizedBox(
              //       width: 28.h,
              //       height: 28.v,
              //       child: InkWell(
              //         onTap: () {
              //           handlePlus();
              //           appState.addOrder(
              //             numberOfItems,
              //             OrderComponent(
              //               number: numberOfItems,
              //               name: widget.name,
              //               price: widget.price,
              //               image: widget.image,
              //             ),
              //           );
              //           appState.addEntryItem(numberOfItems.toDouble(), EntryItem(
              //             identifier: "identifier",
              //                 parentfield: "entry_items",
              //               parenttype: "Table Order",
              //               item_code: widget.code,
              //               status: "Attending",
              //               notes: "",
              //               qty: numberOfItems.toDouble(),
              //               rate: widget.price,
              //               price_list_rate: widget.price,
              //               amount: numberOfItems * widget.price,
              //               table_description: "${appState.choosenRoom["name"]} (Table)",
              //               doctype: "Order Entry Item"
              //           ));
              //         },
              //         child: Icon(
              //           Icons.add,
              //           color: Colors.white,
              //           size: 30.fSize,
              //         ),
              //       ),
              //     ),
              //     // Spacer(),
              //     Text(
              //       "$numberOfItems",
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.fSize),
              //     ),
              //     // Spacer(),
              //     SizedBox(
              //       width: 28.h,
              //       height: 28.v,
              //       child: InkWell(
              //         onTap: () {
              //           handleMinus();
              //           appState.deleteOrder(
              //             numberOfItems,
              //             OrderComponent(
              //               number: numberOfItems,
              //               name: widget.name,
              //               price: widget.price,
              //               image: widget.image,
              //             ),
              //           );
              //         },
              //         child: Icon(
              //           Icons.remove,
              //           color: Colors.white,
              //           size: 30.fSize,
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
