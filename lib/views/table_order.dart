import 'dart:math';

import 'package:flutter/material.dart';
import 'package:klitchyapp/models/items.dart' as itm;
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/widget/items/item_categorie.dart';
import 'package:provider/provider.dart';

import '../config/app_colors.dart';
import '../models/categories.dart';
import '../utils/AppState.dart';
import '../utils/locator.dart';
import '../viewmodels/table_order_interactor.dart';
import '../widget/items/item.dart';

class TableOrder extends StatefulWidget {
  final AppState appState;
  const TableOrder({Key? key, required this.appState}) : super(key: key);

  @override
  TableOrderState createState() => TableOrderState();
}

class TableOrderState extends State<TableOrder> {
  final interactor = getIt<TableOrderInteractor>();
  List<Categorie> listCategories = [];
  List<itm.Item> listItems = [];
  bool click = false;
  int selectedCategoryIndex = -1;
  String categorieName = "";

  Future<void> fetchCategories() async {
    try {
      final categorieResponse = await interactor.retrieveCategories();
      setState(() {
        listCategories = categorieResponse.data!;
      });
    } catch (e) {
      debugPrint("catched error: $e");
    }
  }

  void fetchItems(Map<String, dynamic> params) async {
    try {
      debugPrint("$params");
      final itemResponse = await interactor.retrieveItems(params);
      if(itemResponse.data!.isNotEmpty) {
        widget.appState.clickOpenCategorie(itemResponse.data!);
        setState(() {
          click = true;
          listItems = widget.appState.categorieClicked;
        });
      } else {
        setState(() {
          click = true;
          listItems = [];
        });
      }
    } catch (e) {
      debugPrint("catched error: $e");
    }
  }

  // late AppState appState;

  @override
  void initState() {
    // appState = Provider.of<AppState>(context, listen: false);
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 1117.h,
          height: 262.v,
          decoration: const BoxDecoration(
            color: Color(0xFF0E1227),
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 267.h / 123.v),
            itemCount: listCategories.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < listCategories.length) {
                return ItemCategorie(
                  name: listCategories[index].name!,
                  color: selectedCategoryIndex == index
                      ? Colors.red
                      : Colors.lightBlueAccent,
                  numberOfItems: 14,
                  onTap: (params) {
                    fetchItems(params);
                    setState(() {
                      if (selectedCategoryIndex != index) {
                        selectedCategoryIndex = index;
                        categorieName = listCategories[index].name!;
                      }
                    });
                  },
                  isSelected: selectedCategoryIndex == index,
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find items in $categorieName",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.fSize),
              ),
              SizedBox(
                height: 10.v,
              ),
              Text(
                "${listItems.length} Variation",
                style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 20.fSize),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 1120.h,
          height: 414.v,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 274.h / 134.v,
            ),
            itemCount: listItems.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < listItems.length) {
                return Item(
                  name: listItems[index].itemName!,
                  price: listItems[index].standardRate!,
                  stock: 14,
                  image: listItems[index].image!,
                  appState: widget.appState,
                  code: listItems[index].itemCode!,
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}
