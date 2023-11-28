import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/models/kitchenOrders.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/constants.dart';
import 'package:klitchyapp/views/kitchen.dart';

class CountBox extends StatefulWidget {
  final List<Order> order;
  final int orderLenght;
  final int orderInProgressLenght;
  final int orderFinishLenght;
  final String title;
  final AppState appState;
  final VoidCallback getList;

  CountBox({
    required this.order,
    required this.orderLenght,
    required this.orderInProgressLenght,
    required this.orderFinishLenght,
    required this.appState,
    required this.title,
    required this.getList,
  });

  @override
  _CountBoxState createState() => _CountBoxState();
}

class _CountBoxState extends State<CountBox> {
  @override
  Widget build(BuildContext context) {
    String countText = '';
  
    if (widget.title == "Commands") {
      countText = "${widget.orderLenght} All commands";
    } else if (widget.title == "In progress") {
      countText = "${widget.orderInProgressLenght} ${widget.title}";
    } else if (widget.title == "Done") {
      countText = "${widget.orderFinishLenght} ${widget.title}";
    }

    return ElevatedButton(
      onPressed: () {
        if (widget.title == "Commands") {
          whichBTN = "cmd";
          widget.getList(); 
        } else if (widget.title == "In progress") {
           whichBTN = "progress";
          widget.getList(); 
         
        } else if (widget.title == "Done") {
           whichBTN = "Done";
          widget.getList(); 
        }
        setState(() {}); // Trigger a rebuild to update the screen
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Container(
        width: 150.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: AppColors.tertiaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            countText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}