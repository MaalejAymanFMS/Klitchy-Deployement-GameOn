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

//TODOO add payement methos

class CheckoutScreen extends StatefulWidget {
  final AppState appState;

  const CheckoutScreen({Key? key, required this.appState}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double totalAmount = 0.0;
  double amountGiven = 0.0;
  String amountGivenString = "";
  double change = 0.0;
  bool isTapCommar = false;

  Future<int> payment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        'https://erpnext-141144-0.cloudclusters.net/api/resource/Table%20Order/${prefs.getString("orderId")}';

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
        'https://erpnext-141144-0.cloudclusters.net/api/resource/POS%20Invoice';
    try {
      final token = prefs.getString("token");
      for (var item in widget.appState.entryItems) {
        if (item.status == "Sent") {
          widget.appState.updateEntryItemDocType(
              item.item_code!, "POS Invoice Item", "Stores - JP");
        }
      }
      Map<String, dynamic> body = {
        "docstatus": 1,
        "modified_by": prefs.getString("email"), //tetbaddel bel waiter
        "naming_series": "ACC-PSINV-.YYYY.-",
        "customer": "default",
        "customer_name": "default ",
        "pos_profile": "caissier",
        "is_pos": 1,
        "is_return": 0,
        "update_billed_amount_in_sales_order": 0,
        "company": "Jumpark",
        "posting_date": DateTime.now().year.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString(),
        "posting_time": DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
        "set_posting_time": 0,
        "due_date": DateTime.now().year.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString(),
        "territory": "Rest Of The World",
        "shipping_address_name": "",
        "currency": "TND",
        "conversion_rate": 1.0,
        "selling_price_list": "Standard Selling",
        "price_list_currency": "TND",
        "plc_conversion_rate": 1.0,
        "ignore_pricing_rule": 0,
        "set_warehouse": "Stores - JP",
        "update_stock": 1,
        "total": widget.appState.total,
        "net_total": widget.appState.subtotal,
        "apply_discount_on": "Grand Total",
        "additional_discount_percentage": widget.appState.discount,
        "grand_total": widget.appState.total,
        "paid_amount": amountGiven,
        "change_amount": change,
        "account_for_change_amount": "Cash - JP",
        "write_off_account": "Sales - JP",
        "write_off_cost_center": "Main - JP",
        "language": "fr",
        "customer_group": "Individual",
        "status": "Paid",
        "debit_to": "Debtors - JP",
        "party_account_currency": "TND",
        "is_opening": "No",
        "c_form_applicable": "No",
        "doctype": "POS Invoice",
        "items": widget.appState.entryItems
            .map((entryMap) => entryMap.toJson())
            .toList(),
        "payments": [
          {
            "owner": prefs.getString("email"),
            "modified_by": prefs.getString("email"),
            "parentfield": "payments",
            "parenttype": "POS Invoice",
            "idx": 1,
            "docstatus": 1,
            "default": 0,
            "mode_of_payment": "Cash",
            "amount": widget.appState.total, //tetbaddel
            "account": "Cash - JP",
            "type": "Cash",
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
        'https://erpnext-141144-0.cloudclusters.net/api/method/frappe.utils.print_format.download_pdf?doctype=Table%20Order&name=$orderId&no_letterhead=1&letterhead=No%20Letterhead&settings=%7B%7D&format=Order%20Account&_lang=en';
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
      amountGivenString += number;
      amountGiven = double.parse(amountGivenString);
    });
    print(amountGivenString);
  }

  void clearAmountGiven() {
    setState(() {
      isTapCommar = false;
      amountGiven = 0.0;
      amountGivenString = "";
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
                        padding: EdgeInsets.all(10),
                        color: Color.fromARGB(255, 22, 26, 52),
                        child: Column(
                          children: [
                            Container(
                              width: 460.h,
                              height: 86.v,
                              color: Color.fromARGB(255, 134, 137, 154),
                              child: Center(
                                child: Text(
                                  'Total Amount: ${totalAmount.toStringAsFixed(3)} TND',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFf1eaff), // Font color
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            Container(
                              width: deviceSize.width * 0.24,
                              height: deviceSize.height * 0.08,
                              color: Color.fromARGB(255, 134, 137, 154),
                              child: Center(
                                child: Text(
                                  'Amount Given: ${amountGiven.toStringAsFixed(3)} TND',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Color(0xFFf1eaff), // Font color
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.1,
                    ),
                    Container(
                      color: Color.fromARGB(255, 22, 26, 52),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => onNumberKeyPressed("1"),
                                            child: Text(
                                              '1',
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
                                          SizedBox(width: deviceSize.width * 0.011),
                                          ElevatedButton(
                                            onPressed: () => onNumberKeyPressed("2"),
                                            child: Text(
                                              '2',
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
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => onNumberKeyPressed("5"),
                                            child: Text(
                                              '5',
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
                                          SizedBox(width: deviceSize.width * 0.011),
                                          ElevatedButton(
                                            onPressed: () => onNumberKeyPressed("10"),
                                            child: Text(
                                              '10',
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
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => onNumberKeyPressed("20"),
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
                                          SizedBox(width: deviceSize.width * 0.011),
                                          ElevatedButton(
                                            onPressed: () => onNumberKeyPressed("50"),
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
                                        onPressed: () => onNumberKeyPressed("1"),
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("2"),
                                        child: Text(
                                          '2',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("3"),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
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
                                        onPressed: () => onNumberKeyPressed("4"),
                                        child: Text(
                                          '4',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("5"),
                                        child: Text(
                                          '5',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("6"),
                                        child: Text(
                                          '6',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
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
                                        onPressed: () => onNumberKeyPressed("7"),
                                        child: Text(
                                          '7',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.01),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("8"),
                                        child: Text(
                                          '8',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("9"),
                                        child: Text(
                                          '9',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
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
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.01),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("0"),
                                        child: Text(
                                          '0',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
                                              deviceSize.height * 0.067),
                                          padding: EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(),
                                        ),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.011),
                                      ElevatedButton(
                                        onPressed: () => onNumberKeyPressed("00"),
                                        child: Text(
                                          '00',
                                          style: TextStyle(
                                              color: AppColors.dark01Color,
                                              fontSize: 25),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          AppColors.secondaryTextColor,
                                          minimumSize: Size(deviceSize.width * 0.072,
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
                                change = amountGiven - totalAmount;
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
                                                widget.appState.switchCheckoutOrder();
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
                                        title: Text('Insufficient amount given'),
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
