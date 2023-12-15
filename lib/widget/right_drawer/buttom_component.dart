import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/widget/custom_button.dart';

import '../../config/app_colors.dart';

class ButtomComponent extends StatefulWidget {
  final Function() onTap;
  final AppState appState;
  const ButtomComponent({
    super.key,
    required this.onTap,
    required this.appState,
  });

  @override
  State<ButtomComponent> createState() => _ButtomComponentState();
}

class _ButtomComponentState extends State<ButtomComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 383.h,
      height: 300.v,
      decoration: BoxDecoration(
        color: AppColors.itemsColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Subtotal",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.subtotal.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "TVA 7%",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.tva.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.total} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.v),
            child: Row(
              children: [
                InkWell(
                  onTap: widget.onTap,
                  
                  child: Container(
                    width: 191.5.h,
                    height: 100.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: AppColors.lightColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: AppColors.greenColor.withOpacity(0.8),
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          "Send to Kitchen",
                          style: TextStyle(
                              color: AppColors.greenColor.withOpacity(0.8),
                              fontSize: 20.fSize),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.appState.checkout) {
                      widget.appState.switchCheckoutOrder();
                    } else {
                      widget.appState.switchCheckout();
                    }
                  },
                  child: Container(
                    width: 191.5.h,
                    height: 100.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: AppColors.lightColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_card_outlined,
                          color: AppColors.turquoise,
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          "Payment",
                          style: TextStyle(
                              color: AppColors.turquoise, fontSize: 20.fSize),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
