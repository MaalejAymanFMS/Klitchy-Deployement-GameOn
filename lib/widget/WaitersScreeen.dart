import 'package:flutter/material.dart';
import 'package:klitchyapp/models/Waiter.dart';
import 'package:klitchyapp/widget/waiterWidget.dart';

class WaitersScreeen extends StatelessWidget {
  final List<Waiter> waiters;

  WaitersScreeen({required this.waiters});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      transformAlignment: Alignment.topLeft,
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.6,

      color: Color(0xFF060C18), 
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < waiters.length; i += 6)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int j = i; j < i + 6 && j < waiters.length; j++)
                    WaiterWidget(
                      name: waiters[j].name!,
                      email: waiters[j].email!,
                      imageAsset: waiters[j].image!,
                    ),
                ],
              ),
            SizedBox(height: 20), // Add spacing after all rows
          ],
        ),
      ),
    );
  }
}
