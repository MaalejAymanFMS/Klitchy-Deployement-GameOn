import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for working with JSON data
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/models/Waiter.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/views/gestion_de_table.dart';
import 'package:klitchyapp/widget/WaitersScreeen.dart';
import 'package:klitchyapp/widget/customSwitchButton.dart';
import 'package:klitchyapp/widget/pinScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/pin_screen_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUserLogin = false;
  List<Waiter> waiters = [];


  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final headers = {
      'Authorization': 'token 1e36fdb116a0d37:cf66f1ad25b58ba',
    };
    final url =
        'https://erpnext-141144-0.cloudclusters.net/api/resource/User?fields=["first_name","email"]&filters=[["full_name", "LIKE", "%waiter%"]]';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final waiterList = data['data'] as List<dynamic>;
          setState(() {
            waiters = waiterList
                .map((waiterData) => Waiter(
                    name: waiterData['first_name'],
                    email: waiterData['email'],
                    image: 'assets/images/waiter.png'))
                .toList();
            print('API request done with status code ${response.statusCode}');
          });
        } else {
          // Handle error when the API request fails
          print('API request failed with status code ${response.statusCode}');
        }
      }
    } catch (error) {
      // Handle network or other errors
      print('Error fetching data from API: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 50.v,
            child: Image.asset(
              'assets/images/logo.png',
              width: 100.h,
              height: 100.v,
            ),
          ),
          Positioned(
            top: 200.v,
            child: CustomSwitchButton(
              initialValue: isUserLogin,
              onChanged: (bool value) {
                setState(() {
                  isUserLogin = value;
                });
              },
            ),
          ),
          Positioned(
            top: 300.v,
            child: isUserLogin ? const GestionDeTable() : const PinScreenVM(),
          ),
        ],
      ),
    );
  }
}
