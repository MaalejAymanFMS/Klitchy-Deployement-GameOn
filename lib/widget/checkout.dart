import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:http/http.dart' as http;
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/views/gestion_de_table.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  final AppState appState;

  const CheckoutScreen({Key? key, required this.appState}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double totalAmount = 0.0;
  double change = 0.0;
  bool isTapCommar = false;

  String totalAmountGivenString = "";
  double totalAmountGiven = 0.0;

  //previous amounts
  String previousAmountCashString = "";
  double previousAmountCash = 0.0;
  String previousAmountChequeString = "";
  double previousAmountCheque = 0.0;
  String previousAmountWireTransferString = "";
  double previousAmountWireTransfer = 0.0;
  //

  String amountGivenString = "";
  double amountGiven = 0.0;

  String amountGivenCashString = "";
  double amountGivenCash = 0.0;
  double totalAmountGivenCash = 0.0;

  String amountGivenChequeString = "";
  double amountGivenCheque = 0.0;
  double totalAmountGivenCheque = 0.0;

  String amountGivenWireTransferString = "";
  double amountGivenWireTransfer = 0.0;
  double totalAmountGivenWireTransfer = 0.0;

  bool payWithCash = true;
  bool payWithCheque = false;
  bool payWithWireTransfer = false;

  bool changePreviousAmount = false;

  Future<int> payment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        'https://erpnext-155835-0.cloudclusters.net/api/resource/Table%20Order/${prefs.getString("orderId")}';

    final payload = json.encode({"status": "Invoiced"});
    print(prefs.getString("orderId"));
    final token = prefs.getString("token");
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        print('Table Order status updated successfully');
        print("response.statusCode" + response.statusCode.toString());
        createInvoice();
        printTicket();
        return response.statusCode;
      } else {
        print(
            'Failed to update Table Order status. Status code: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      print('Error: $e');
      return -1;
    }
  }

  void createInvoice() async {
    print("createInvoice");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const String url =
        'https://erpnext-155835-0.cloudclusters.net/api/resource/POS%20Invoice';
    try {
      final token = prefs.getString("token");
      for (var item in widget.appState.entryItems) {
        if (item.status == "Sent") {
          widget.appState.updateEntryItemDocType(
              item.item_code!, "POS Invoice Item", "Stores - GP");
        }
      }

      Map<String, dynamic> body = {
        "docstatus": 1,
        "title": "default ",
        "naming_series": "ACC-PSINV-.YYYY.-",
        "customer": "default",
        "customer_name": "default ",
        "pos_profile": "caissier",
        "is_pos": 1,
        "company": "The Game Production",
        "currency": "TND",
        "selling_price_list": "Standard Selling",
        "price_list_currency": "TND",
        "set_warehouse": "Stores - GP",
        "update_stock": 1,
        "total_qty": 2.0,
        "total": widget.appState.total,
        "net_total": widget.appState.subtotal,
        "apply_discount_on": "Grand Total",
        "additional_discount_percentage": widget.appState.discount,
        "discount_amount": 0.0,
        "grand_total": widget.appState.total,
        "paid_amount": 30.0,
        "change_amount": 5.0,
        "account_for_change_amount": "Cash - GP",
        "write_off_account": "Sales - GP",
        "write_off_cost_center": "Main - GP",
        "customer_group": "Individual",
        "is_discounted": 0,
        "status": "Consolidated",
        "debit_to": "Debtors - GP",
        "party_account_currency": "TND",
        "doctype": "POS Invoice",
        "items": widget.appState.entryItems
            .map((entryMap) => entryMap.toJson())
            .toList(),
        "payments": [
          //this is the payment using the cash method
          {
            "parentfield": "payments", //static
            "parenttype": "POS Invoice", //static
            "docstatus": 1, //static
            "default": 1, //static
            "mode_of_payment": "Cash", //your payment method
            "amount": amountGivenCash, //the amount paid using the method
            "account": "Cash - GP",
            "type": "Cash",
            "doctype": "Sales Invoice Payment" //static
          },
          //this is the payment using the check methode
          {
            "parentfield": "payments",
            "parenttype": "POS Invoice",
            "docstatus": 1,
            "mode_of_payment": "Cheque",
            "amount": amountGivenCheque,
            "account": "BIAT - GP",
            "type": "Cash",
            "doctype": "Sales Invoice Payment"
          },
          {
            //this is the payment with credit card method
            "parentfield": "payments",
            "parenttype": "POS Invoice",
            "docstatus": 1,
            "mode_of_payment": "Wire Transfer",
            "amount": amountGivenWireTransfer,
            "account": "BIAT - GP",
            "type": "Bank",
            "doctype": "Sales Invoice Payment"
          }
        ]
      };
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token'
          },
          body: jsonEncode(body));
      print(" ${response.statusCode}");
      if (response.statusCode == 200) {
        print(" ${response.body}");
      } else {
        print(
            'Failed to update Table Order status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void printTicket() async {
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

  Future<void> _launchUrl(Uri url, String token) async {
    print("token: $token");
    if (!await launchUrl(url,
        webViewConfiguration:
            WebViewConfiguration(headers: {'Authorization': token}))) {
      throw Exception('Could not launch $url');
    }
  }

  void onNumberKeyPressed(String number) {
    setState(() {
      if (number == ".") {
        isTapCommar = true;
      }
      if (payWithCash) {
        amountGivenCashString += number;
        amountGivenCash = double.parse(amountGivenCashString);
        amountGiven = amountGivenCash;
        amountGivenString = amountGiven.toString();
        previousAmountCash = amountGiven;
        previousAmountCashString = amountGivenString;
        changePreviousAmount = true;
      } else if (payWithCheque) {
        amountGivenChequeString += number;
        amountGivenCheque = double.parse(amountGivenChequeString);
        amountGiven = amountGivenCheque;
        amountGivenString = amountGiven.toString();
        previousAmountCheque = amountGiven;
        previousAmountChequeString = amountGivenString;
        changePreviousAmount = true;
      } else if (payWithWireTransfer) {
        amountGivenWireTransferString += number;
        amountGivenWireTransfer = double.parse(amountGivenWireTransferString);
        amountGiven = amountGivenWireTransfer;
        amountGivenString = amountGiven.toString();
        previousAmountWireTransfer = amountGiven;
        previousAmountWireTransferString = amountGivenString;
        changePreviousAmount = true;
      }
      totalAmountGiven =
          amountGivenCash + amountGivenCheque + amountGivenWireTransfer;
      totalAmountGivenString = totalAmountGiven.toString();
    });
    print(amountGivenString);
    print(amountGivenCashString);
    print(amountGivenChequeString);
    print(amountGivenWireTransferString);
  }

  void clearAmountGiven() {
    setState(() {
      isTapCommar = false;
      amountGiven = 0.0;
      amountGivenCash = 0.0;
      amountGivenCheque = 0.0;
      amountGivenWireTransfer = 0.0;
      amountGivenString = "";
      amountGivenCashString = "";
      amountGivenChequeString = "";
      amountGivenWireTransferString = "";
      totalAmountGiven = 0.0;
      totalAmountGivenString = "";

      previousAmountCash = 0.0;
      previousAmountCheque = 0.0;
      previousAmountWireTransfer = 0.0;
      previousAmountCashString = "";
      previousAmountChequeString = "";
      previousAmountWireTransferString = "";
    });
  }

  bool isVisible = true;
  @override
  void initState() {
    totalAmount = widget.appState.total;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return TapRegion(
      onTapOutside: (tap) {
        setState(() {
          isVisible = !isVisible;
        });
      },
      child: Stack(
        children: [
          Visibility(
            visible: isVisible,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: deviceSize.height * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: deviceSize.width * 0.1,
                              //height: deviceSize.height * 0.4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 100.h,
                                    height: 100.v,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: payWithCash
                                            ? Color.fromARGB(255, 237, 227, 227)
                                            : Color.fromARGB(255, 36, 39, 54),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => {
                                        setState(() {
                                          if (!payWithCash) {
                                            if (changePreviousAmount) {
                                              amountGivenCheque =
                                                  previousAmountCash;
                                              amountGivenChequeString =
                                                  previousAmountCashString;
                                              changePreviousAmount = false;
                                            }
                                            amountGiven = 0;
                                            amountGivenString = "";
                                            amountGivenCash = 0;
                                            amountGivenCashString = "";
                                            totalAmountGiven =
                                                amountGivenCheque +
                                                    amountGivenWireTransfer;
                                          }
                                          payWithCash = true;
                                          payWithCheque = false;
                                          payWithWireTransfer = false;
                                        }),
                                        print(
                                            "payed with cash: $amountGivenCashString"),
                                        print("total amount given cash: " +
                                            totalAmountGivenCash.toString()),
                                        print(
                                            "payed with cheque: $amountGivenChequeString"),
                                        print("total amount given cheque: " +
                                            totalAmountGivenCheque.toString()),
                                        print(
                                            "payed with wire transfer: $amountGivenWireTransferString"),
                                        print(
                                            "total amount given wire transfer: " +
                                                totalAmountGivenWireTransfer
                                                    .toString()),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 22, 26, 52),
                                        minimumSize: Size(112.h, 77.v),
                                        padding: EdgeInsets.all(16.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      child: Image.asset(
                                        'assets/images/cash.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100.h,
                                    height: 100.v,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: payWithCheque
                                            ? const Color.fromARGB(
                                                255, 237, 227, 227)
                                            : const Color.fromARGB(
                                                255, 36, 39, 54),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => {
                                        setState(() {
                                          if (!payWithCheque) {
                                            if (changePreviousAmount) {
                                              amountGivenCheque =
                                                  previousAmountCheque;
                                              amountGivenChequeString =
                                                  previousAmountChequeString;
                                              changePreviousAmount = false;
                                            }

                                            amountGiven = 0;
                                            amountGivenString = "";
                                            amountGivenCheque = 0;
                                            amountGivenChequeString = "";
                                            totalAmountGiven = amountGivenCash +
                                                amountGivenWireTransfer;
                                          }
                                          payWithCash = false;
                                          payWithCheque = true;
                                          payWithWireTransfer = false;
                                        }),
                                        print(
                                            "payed with cash: $amountGivenCashString"),
                                        print("total amount given cash: " +
                                            totalAmountGivenCash.toString()),
                                        print(
                                            "payed with cheque: $amountGivenChequeString"),
                                        print("total amount given cheque: " +
                                            totalAmountGivenCheque.toString()),
                                        print(
                                            "payed with wire transfer: $amountGivenWireTransferString"),
                                        print(
                                            "total amount given wire transfer: " +
                                                totalAmountGivenWireTransfer
                                                    .toString()),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 22, 26, 52),
                                        minimumSize: Size(112.h, 77.v),
                                        padding: const EdgeInsets.all(16.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      child: Image.asset(
                                        'assets/images/cheque.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100.h,
                                    height: 100.v,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: payWithWireTransfer
                                            ? const Color.fromARGB(
                                                255, 237, 227, 227)
                                            : const Color.fromARGB(
                                                255, 36, 39, 54),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => {
                                        setState(() {
                                          if (!payWithWireTransfer) {
                                            if (changePreviousAmount) {
                                              amountGivenWireTransfer =
                                                  previousAmountWireTransfer;
                                              amountGivenWireTransferString =
                                                  previousAmountWireTransferString;
                                              changePreviousAmount = false;
                                            }
                                            amountGiven = 0;
                                            amountGivenString = "";
                                            amountGivenWireTransfer = 0;
                                            amountGivenWireTransferString = "";
                                            totalAmountGiven = amountGivenCash +
                                                amountGivenCheque;
                                          }
                                          payWithCash = false;
                                          payWithCheque = false;
                                          payWithWireTransfer = true;
                                        }),
                                        print(
                                            "payed with cash: $amountGivenCashString"),
                                        print("total amount given cash: " +
                                            totalAmountGivenCash.toString()),
                                        print(
                                            "payed with cheque: $amountGivenChequeString"),
                                        print("total amount given cheque: " +
                                            totalAmountGivenCheque.toString()),
                                        print(
                                            "payed with wire transfer: $amountGivenWireTransferString"),
                                        print(
                                            "total amount given wire transfer: " +
                                                totalAmountGivenWireTransfer
                                                    .toString()),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 22, 26, 52),
                                        minimumSize: Size(112.h, 77.v),
                                        padding: const EdgeInsets.all(16.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      child: Image.asset(
                                        'assets/images/wire.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 134, 137, 154),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 237, 227, 227),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(10),
                              width: 460.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Due: ${totalAmount.toStringAsFixed(3)} TND',
                                    style: const TextStyle(
                                      fontSize: 28.0,
                                      fontFamily: 'Poopins',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Divider(
                                    height: 10,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  SizedBox(
                                    height: deviceSize.height * 0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Cash',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Poopins',
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              'Cheque',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Poopins',
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              'Wire Transfer',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Poopins',
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.01,
                                        ),
                                        const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ':',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Poopins',
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              ':',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Poopins',
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              ':',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Poopins',
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.01,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${previousAmountCash.toStringAsFixed(3)} TND',
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: 'Poopins',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                '${previousAmountCheque.toStringAsFixed(3)} TND',
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: 'Poopins',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                '${previousAmountWireTransfer.toStringAsFixed(3)} TND',
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: 'Poopins',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceSize.height * 0.01,
                                  ),
                                  const Divider(
                                    height: 10,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  SizedBox(
                                    height: deviceSize.height * 0.01,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          'Total Given :',
                                          style: TextStyle(
                                            fontSize: 26.0,
                                            fontFamily: 'Poopins',
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.01,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${totalAmountGiven.toStringAsFixed(3)} TND',
                                            style: const TextStyle(
                                              fontSize: 26.0,
                                              fontFamily: 'Poopins',
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceSize.height * 0.01,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Enter amount:',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'Poopins',
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${amountGiven.toStringAsFixed(3)}',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 38.0,
                                              fontFamily: 'Poopins',
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        const Text(
                                          'TND',
                                          style: TextStyle(
                                            fontSize: 38.0,
                                            fontFamily: 'Poopins',
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.1,
                      height: deviceSize.height * 0.01,
                    ),
                    Container(
                      color: const Color.fromARGB(255, 22, 26, 52),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                onNumberKeyPressed("1"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryTextColor,
                                              minimumSize: Size(112.h, 77.v),
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              shape:
                                                  const RoundedRectangleBorder(),
                                            ),
                                            child: const Text(
                                              '1',
                                              style: TextStyle(
                                                  color: AppColors.dark01Color,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                              width: deviceSize.width * 0.011),
                                          ElevatedButton(
                                            onPressed: () =>
                                                onNumberKeyPressed("2"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryTextColor,
                                              minimumSize: Size(112.h, 77.v),
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              shape:
                                                  const RoundedRectangleBorder(),
                                            ),
                                            child: const Text(
                                              '2',
                                              style: TextStyle(
                                                  color: AppColors.dark01Color,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                onNumberKeyPressed("5"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryTextColor,
                                              minimumSize: Size(112.h, 77.v),
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              shape:
                                                  const RoundedRectangleBorder(),
                                            ),
                                            child: const Text(
                                              '5',
                                              style: TextStyle(
                                                  color: AppColors.dark01Color,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                              width: deviceSize.width * 0.011),
                                          ElevatedButton(
                                            onPressed: () =>
                                                onNumberKeyPressed("10"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryTextColor,
                                              minimumSize: Size(112.h, 77.v),
                                              padding: EdgeInsets.all(16.0),
                                              shape: RoundedRectangleBorder(),
                                            ),
                                            child: const Text(
                                              '10',
                                              style: TextStyle(
                                                  color: AppColors.dark01Color,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                onNumberKeyPressed("20"),
                                            child: Text(
                                              '20',
                                              style: TextStyle(
                                                  color: AppColors.dark01Color,
                                                  fontSize: 25),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryTextColor,
                                              minimumSize: Size(112.h, 77.v),
                                              padding: EdgeInsets.all(16.0),
                                              shape: RoundedRectangleBorder(),
                                            ),
                                          ),
                                          SizedBox(
                                              width: deviceSize.width * 0.011),
                                          ElevatedButton(
                                            onPressed: () =>
                                                onNumberKeyPressed("50"),
                                            child: Text(
                                              '50',
                                              style: TextStyle(
                                                  color: AppColors.dark01Color,
                                                  fontSize: 25),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondaryTextColor,
                                              minimumSize: Size(112.h, 77.v),
                                              padding: EdgeInsets.all(16.0),
                                              shape: RoundedRectangleBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => clearAmountGiven(),
                                child: Container(
                                  height: 77.v,
                                  width: 235.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.redColor,
                                    border: Border.all(width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: AppColors.dark01Color,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //  SizedBox(width: deviceSize.width * 0.03),
                          Container(
                            //height: deviceSize.height * 0.4,
                            // width: deviceSize.width * 0.27,
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              // Keypad background color
                              borderRadius: BorderRadius.circular(10.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.2),
                              //     blurRadius: 6.0,
                              //     spreadRadius: 2.0,
                              //   ),
                              // ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("1"),
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("2"),
                                        child: Text(
                                          '2',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("3"),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("4"),
                                        child: Text(
                                          '4',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("5"),
                                        child: Text(
                                          '5',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("6"),
                                        child: Text(
                                          '6',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("7"),
                                        child: Text(
                                          '7',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.01),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("8"),
                                        child: Text(
                                          '8',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("9"),
                                        child: Text(
                                          '9',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (!isTapCommar) {
                                            onNumberKeyPressed(".");
                                            isTapCommar = true;
                                          }
                                        },
                                        child: Text(
                                          ',',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              // AppColors.secondaryTextColor,
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.01),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("0"),
                                        child: Text(
                                          '0',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onNumberKeyPressed("00"),
                                        child: Text(
                                          '00',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.secondaryTextColor,
                                          minimumSize: Size(
                                              deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: deviceSize.height * 0.3,
                            width: deviceSize.width * 0.07,
                            child: InkWell(
                              onTap: () async {
                                print("DONE CLICKED");
                                print("total amount given: " +
                                    totalAmountGiven.toString());
                                print("amount given cash: " +
                                    amountGivenCash.toString());
                                print("amount given cheque: " +
                                    amountGivenCheque.toString());
                                print("amount given wire transfer: " +
                                    amountGivenWireTransfer.toString());
                                print("total amount: " +
                                    totalAmountGiven.toString());
                                change = totalAmountGiven - totalAmount;
                                if (change >= 0) {
                                  if (await payment() == 200) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Change: ${change.toStringAsFixed(3)} TND'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                widget.appState
                                                    .switchCheckoutOrder();
                                                widget.appState.switchRoom();
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('payment faild'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text('Insufficient amount given'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  border: Border.all(width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: AppColors.dark01Color,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberKey extends StatelessWidget {
  final int number;
  final VoidCallback onPressed;

  NumberKey(this.number, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        number.toString(),
        style: TextStyle(fontSize: 24.0),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(60.0, 60.0),
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}
