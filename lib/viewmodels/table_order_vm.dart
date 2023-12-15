import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klitchyapp/models/categories.dart';
import 'package:klitchyapp/models/items.dart';
import 'package:klitchyapp/viewmodels/table_order_interactor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../views/table_order.dart';
import 'package:http/http.dart' as http;

class TablOrderPage extends StatefulWidget {
  const TablOrderPage({Key? key}) : super(key: key);

  @override
  TablOrderPageState createState() => TablOrderPageState();
}

class TablOrderPageState extends State<TablOrderPage>
    implements TableOrderInteractor {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  @override
  Future<Categories> retrieveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/resource/Item%20Group"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = Categories.fromJson(jsonResponse);
        return data;
      } else {
        return Categories();
      }
    } catch (e) {
      return Categories();
    }
  }

  @override
  Future<Items> retrieveItems(Map<String, dynamic>? params) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };

    final Uri uri = Uri.parse("$baseUrl/resource/Item");

    final filters = params?['filters'];
    final filtersJson = json.encode(filters);
    final limit = params?['limit_page_length'];
    final limitJson = json.encode(limit);

    final Map<String, String> queryParams = {
      "fields": json.encode(params?['fields']),
      "filters": filtersJson,
      "limit_page_length": limitJson
    };

    final response = await http.get(uri.replace(queryParameters: queryParams),
        headers: headers);
    print(response.statusCode);
    print(uri.replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = Items.fromJson(jsonResponse);
      return data;
    } else {
      return Items();
    }
  }
}
