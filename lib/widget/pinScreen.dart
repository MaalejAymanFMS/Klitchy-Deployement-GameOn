import 'package:flutter/material.dart';

import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/views/gestion_de_table.dart';
import 'package:klitchyapp/views/kitchen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/locator.dart';
import '../viewmodels/pin_screen_interactor.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String pin = '';
  int filledCircles = 0;
  final interactor = getIt<PinScreenInteractor>();

  void addPin(String digit) {
    setState(() {
      if (pin.length < 4) {
        pin += digit;
        filledCircles = pin.length;
      }
    });
  }

  void removePin() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
        filledCircles = pin.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Card(
        color: AppColors.tertiaryColor,
        elevation: 8.0,
        margin: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: 450.h,
          height: 570.v,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter personal PIN:',
                style: TextStyle(fontSize: 25.fSize, color: AppColors.lightColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < 4; i++)
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 40.h,
                      height: 40.v,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < filledCircles
                            ? AppColors.greenColor
                            : AppColors.lightColor.withOpacity(0.5),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.v),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 1; i <= 3; i++) keyboardButton('$i'),
                  ],
                ),
              ),
              SizedBox(height: deviceSize.height * 0.01),
              Container(
                // margin: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 4; i <= 6; i++) keyboardButton('$i'),
                  ],
                ),
              ),
              SizedBox(height: deviceSize.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 7; i <= 9; i++) keyboardButton('$i'),
                ],
              ),
              SizedBox(height: deviceSize.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i <=0; i++) keyboardButton('$i'),
                ],
              ),
              SizedBox(height: deviceSize.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print(pin);
                      // TODOO impliments services
                      final response = await interactor.retrieve(pin);
                      if (response.email!.isNotEmpty) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final email = prefs.getString("email");
                        final password = prefs.getString("password");
                        final role = prefs.getString("role");
                        Map<String, dynamic> body = {
                          "usr": email,
                          "pwd": password,
                        };
                        final login = await interactor.login(body);
                        if (login.message == "Logged In") {
                          if(role == "waiter") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GestionDeTable()));
                          } else if(role == "kitchen"){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KitchenScreen()));
                          }
                        }
                      }

                      print(pin);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightColor,
                      padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 20.v),
                    ),
                    child: Text('Confirm',
                        style: TextStyle(
                            fontSize: 20.fSize, color: AppColors.dark01Color)),
                  ),
                  SizedBox(width: 20.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightColor,
                        padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 20.v),
                    ),
                    onPressed: () {
                      removePin();
                    },
                    child: Text('Delete',
                        style: TextStyle(
                            fontSize: 20.fSize, color: AppColors.redColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget keyboardButton(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightColor,
            padding: EdgeInsets.symmetric(horizontal: 40.h, vertical: 20.v),
            textStyle: TextStyle(fontSize: 30.fSize, fontWeight: FontWeight.bold)),
        onPressed: () => addPin(label),
        child: Text(label,
            style: TextStyle(fontSize: 30.fSize, color: AppColors.dark01Color)),
      ),
    );
  }
}
