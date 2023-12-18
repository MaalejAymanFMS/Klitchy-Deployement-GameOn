import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/widget/custom_button.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
  void printTicket2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString("orderId");
    String url =
        'https://erpnext-155835-0.cloudclusters.net/api/method/frappe.utils.print_format.download_pdf?doctype=Table%20Order&name=$orderId&no_letterhead=1&letterhead=No%20Letterhead&settings=%7B%7D&format=ticket%20restau&_lang=en';
    try {
      final token = prefs.getString("token");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
      );
      if (response.statusCode == 200) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async {
            // Use the alias
            return response.bodyBytes; // Pass the response body directly
          },
        );
      } else {
        print(
            'Failed to update Table Order status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 383.h,
      height: 310.v,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
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
                      color:  Colors.black,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.subtotal.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
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
                      color:  Colors.black,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.tva.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
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
                      color:  Colors.black,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.total.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:  Colors.black,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.v),
            child: Row(
              children: [
                InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    width: 180.h,
                    height: 100.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.red ,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          "Send to Kitchen",
                          style: TextStyle(
                              color: Colors.white ,
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
                        color:  Colors.red,
                        border: Border.all(
                          color:  Colors.red,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_card_outlined,
                          color: Colors.white,
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          "Payment",
                          style: TextStyle(
                              color: Colors.white, fontSize: 20.fSize),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.v),
            child: Row(
              children: [
                InkWell(
                  onTap:() {
                    printTicket2();
                  },
                  child: Container(
                    width: 351.h,
                    height: 50.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.red ,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print,
                          color: Colors.white,
                          size: 30.fSize,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Print Ticket",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.fSize),
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
