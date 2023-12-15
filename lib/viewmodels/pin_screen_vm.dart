import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klitchyapp/models/user.dart';
import 'package:klitchyapp/viewmodels/pin_screen_interactor.dart';
import 'package:klitchyapp/widget/pinScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
class PinScreenVM extends StatefulWidget {
  const PinScreenVM({super.key});

  @override
  State<PinScreenVM> createState() => PinScreenVMState();
}

class PinScreenVMState extends State<PinScreenVM> implements PinScreenInteractor{

  @override
  Widget build(BuildContext context) {
    return PinScreen();
  }

  @override
  Future<User> retrieve(String pin) async {
    final response = await http
         .get(Uri.parse("https://prime-verified-pug.ngrok-free.app/user/get_user_by_pin/$pin")
        ,headers: {
          "Access-Control-Allow-Origin":"*"
        });
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = User.fromJson(jsonResponse);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data.token!);
      prefs.setString('email', data.email!);
      prefs.setString('password', data.password!);
      prefs.setString('role', data.role!);
      debugPrint(prefs.getString("email"));
      debugPrint(prefs.getString("password"));
      debugPrint(prefs.getString("role"));
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = User.fromJson(jsonResponse);
      return data;
    }

  }


  @override
  Future<Login> login(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",

    };
    final response = await http
        .post(Uri.parse("$baseUrl/method/login"),
        headers: headers, body: json.encode(body));
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = Login.fromJson(jsonResponse);
      prefs.setBool("isLoggedIn", true);
      prefs.setString("full_name", data.fullName!);
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = Login.fromJson(jsonResponse);
      return data;
    }

  }

}
