import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/models/kitchenOrders.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/constants.dart';

class OrderCard extends StatefulWidget {
  final AppState appState;
  final Order order;
  final int index;
  final List<Order> ordersList;

  const OrderCard({
    super.key,
    required this.appState,
    required this.order,
    required this.index,
    required this.ordersList,
  });

  @override
  OrderCardState createState() => OrderCardState();
}

class OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              color: whichBTN == "cmd" ? Colors.red : whichBTN == "progress"? Colors.yellow : Colors.green,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Order of table : ${widget.order.tableNumber}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: whichBTN == "cmd"
                        ? Colors.white
                        : AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.order.items!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "${widget.order.items![index].quantity} x ",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Text(
                          widget.order.items![index].itemName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
