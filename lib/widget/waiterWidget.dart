import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/views/gestion_de_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';
import 'package:http/http.dart' as http;

class CustomKeyboardButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  CustomKeyboardButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        minimumSize: Size(50, 50),
      ),
    );
  }
}

class WaiterWidget extends StatefulWidget {
  final String name;
  final String imageAsset;
  final String email;

  WaiterWidget(
      {required this.name, required this.imageAsset, required this.email});

  @override
  _WaiterWidgetState createState() => _WaiterWidgetState();
}

String emailBody = "";
String PasswordBody = "";
int? statusCode;
Future<int> login(emailBody, PasswordBody) async {
  final url =
  Uri.parse('https://erpnext-141144-0.cloudclusters.net/api/method/login');

  // Create the request body
  final Map<String, String> requestBody = {
    "usr": emailBody,
    "pwd": PasswordBody,
  };

  // Send the POST request
  final response = await http.post(
    url,
    headers: {
      // Add any headers if needed
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body: jsonEncode(requestBody), // Encode the body as JSON
  );

  if (response.statusCode == 200) {
    // Request was successful, handle the response here
    statusCode = response.statusCode;
    return response.statusCode;
  } else {
    // Request failed, handle the error here
    print('Error: ${response.statusCode}');
    statusCode = response.statusCode;
    return response.statusCode;
  }
}

Future<void> showBadPasswordAlert(BuildContext context, String msg, String title) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
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

class _WaiterWidgetState extends State<WaiterWidget> {
  TextEditingController _textEditingController = TextEditingController();
  String _inputText = '';
  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                'Enter your password ${widget.name}',
                style: TextStyle(color: AppColors.whiteColor),
              ),
              backgroundColor: AppColors.primaryColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VirtualKeyboard(
                    height: 350,
                    textColor: Colors.white,
                    fontSize: 20,
                    type: VirtualKeyboardType.Alphanumeric,
                    textController: _textEditingController,
                  ),
                  Text(
                    _textEditingController.text,
                    style: TextStyle(color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                      SizedBox(width: 15),
                      CustomKeyboardButton(
                        text: 'Login',
                        onPressed: () async {
                          emailBody = widget.email;
                          PasswordBody = _textEditingController.text;
                          final int result;
                          print(PasswordBody);
                          result = await login(emailBody, PasswordBody);
                          if (result == 200) {
                            final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                            prefs.setString('usr', emailBody);
                            prefs.setString('pwd', PasswordBody);

                            print(prefs.getString('usr'));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GestionDeTable()));
                          } else if (result == 401) {
                            _textEditingController.text = "";
                            showBadPasswordAlert(context,"wrong password",'Bad Password');
                          } else {
                            showBadPasswordAlert(context,"Sorry there is a problem",'OOPS');

                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          Image.asset(
            widget.imageAsset,
            width: 100,
            height: 100,
          ),
          SizedBox(height: 10),
          Text(
            widget.name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}