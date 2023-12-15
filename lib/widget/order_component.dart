import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../config/app_colors.dart';
class OrderComponent extends StatelessWidget {
  int number;
  final String name;
  final double price;
  final String image;
  String? note;
  final String code;
  final String status;
  OrderComponent({Key? key, required this.number, required this.name, required this.price, required this.image, this.note, required this.code, required this.status}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, order, child) {
        return
        Padding(
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
                  child: Icon(status == "Sent" ? Icons.soup_kitchen_rounded : Icons.shopping_cart_outlined, color: Colors.white, size: 30.fSize,),
                ),
                SizedBox(width: 30.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.h,
                      child: Text(
                        "$number X $name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.fSize),
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      note ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "${totalPrice()} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.fSize),
                ),
              ],
            ),
          ),
        )
        ;
      }
    );
  }

  double totalPrice() {
    return price * number;
  }
}
