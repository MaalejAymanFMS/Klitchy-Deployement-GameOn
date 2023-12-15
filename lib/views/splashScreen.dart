import 'package:flutter/material.dart';
import 'package:klitchyapp/views/gestion_de_table.dart';
import 'package:klitchyapp/views/homePage.dart';
import 'package:klitchyapp/views/kitchen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isUserLogin = false;
  String role = "";
  late Future<bool> fetchPrefs;

  Future<bool> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserLogin = prefs.getBool("isLoggedIn")!;
      role = prefs.getString("role")!;
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchPrefs = getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isUserLogin
                ? role == "kitchen"
                    ? KitchenScreen()
                    : const GestionDeTable()
                : const HomePage()),
      );
    });

    final deviceSize = MediaQuery.of(context).size;
    print(deviceSize.width);
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Image.asset(
              '../assets/images/splashScreen.png',
              fit: BoxFit.cover,
              width: deviceSize.width,
              height: deviceSize.height,
            ),
          ],
        ),
      ),
    );
  }
}
