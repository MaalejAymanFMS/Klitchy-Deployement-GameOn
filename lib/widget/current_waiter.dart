import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_colors.dart';
import '../views/homePage.dart';

class CurrentWaiter extends StatelessWidget {
  final String name;
  const CurrentWaiter({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAdaptiveDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.only(
              left: MediaQuery.of(context)
                  .size
                  .width -
                  450.h,
              right: 230.h,
              top: 80.v,
              bottom: MediaQuery.of(context)
                  .size
                  .height - 140.v
            ),
            alignment: Alignment.bottomRight,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: 300.h,
              height: 100.v,
              child: Center(
                child: ListTile(
                  dense: true,
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove("isLoggedIn");
                    prefs.remove("token");
                    prefs.remove("email");
                    prefs.remove("password");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                  },
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 17.fSize, fontWeight: FontWeight.bold)
                  ),
                  trailing: Icon(Icons.logout, size: 30.fSize, color: AppColors.redColor,),
                ),
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 220.h,
        height: 50.v,
        child: Row(
          children: [
            CircleAvatar(
              child: Image.asset("assets/images/waiter.png"),
            ),
            SizedBox(
              width: 19.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.fSize),
                ),
                Row(
                  children: [
                    Container(
                      width: 10.h,
                      height: 10.v,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    Text("Active Now",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: AppColors.secondaryTextColor, fontSize: 15.fSize)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.logout, size: 25.fSize, color: AppColors.redColor,),
          ],
        ),
      ),
    );
  }
}
