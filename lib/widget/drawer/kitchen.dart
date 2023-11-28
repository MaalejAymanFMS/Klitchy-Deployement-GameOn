import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/models/kitchenOrders.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final selectedOrder = appState.selectedOrder;
        final deviceSize = MediaQuery.of(context).size;
        return Drawer(
          backgroundColor: AppColors.primaryColor,
          width: deviceSize.width * 0.3,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: deviceSize.height * 0.1,
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                  ),
                  child: Text(
                    'Order list',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (selectedOrder != null) ...[
                ListTile(
                  title: Text(
                    'Selected Order Items: ${selectedOrder.tableNumber}\n',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(94, 255, 255, 255),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedOrder.items!
                        .map(
                          (item) => Text(
                            "\n ${item.quantity} x ${item.itemName}\n ${item.notes}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ] else ...[
                const ListTile(
                  title: Text(
                    'No Order Selected  \n',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(94, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
