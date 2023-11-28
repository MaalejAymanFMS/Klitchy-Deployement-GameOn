import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/models/kitchenOrders.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/locator.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/viewmodels/kitchen_interactor.dart';
import 'package:klitchyapp/widget/current_waiter.dart';
import 'package:klitchyapp/widget/orderList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool isDone = false;
List<Order> orders = [];
List<Order> inPrgressOrders = [];
List<Order> finishedOrders = [];
String nameWaiter = "";
class KitchenScreen extends StatefulWidget {
  @override
  _KitchenScreenState createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
fetchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameWaiter = prefs.getString("full_name")!;
    });
  }
  final interactor = getIt<KitchenInteractor>();

@override
  void initState() {
    fetchPrefs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: interactor.fetchOrder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Order> orders = snapshot.data ?? [];

          return ChangeNotifierProvider<AppState>(
            create: (context) => AppState(),
            child: MaterialApp(
              home: Scaffold(
                appBar: AppBar(actions: [Row(
                  children: [
                    //AvailableWaiters(appState.numberOfTables, appState.choosenRoom["name"] ?? "choose Room"),
                    
                    CurrentWaiter(name: nameWaiter,),
                    SizedBox(width: 250.v)
                  ],
                ),
              ],
                  //toolbarHeight:
                  backgroundColor: AppColors.primaryColor,
                ),
                body: OrderList(
                  orders: orders,
              
                ),
              ),
              debugShowCheckedModeBanner: false,
            ),
          );
        }
      },
    );
  }
}
