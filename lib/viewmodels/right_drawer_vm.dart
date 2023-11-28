import 'dart:convert';

import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/viewmodels/right_drawer_interractor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/orders.dart';
import '../utils/constants.dart';
import '../views/right_drawer.dart';
import 'package:http/http.dart' as http;

class RightDrawerVM extends StatefulWidget {
  final String tableName;
  final String tableId;
  final AppState appState;

  const RightDrawerVM(this.tableName, this.tableId, this.appState, {super.key});

  @override
  RightDrawerVMState createState() => RightDrawerVMState();
}

class RightDrawerVMState extends State<RightDrawerVM>
    implements RightDrawerInterractor {
  @override
  Widget build(BuildContext context) {
    return RightDrawer(
      tableName: widget.tableName,
      tableId: widget.tableId,
      appState: widget.appState,
    );
  }

  @override
  Future<OrdersP2> addOrder(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };
    final response = await http.post(
        Uri.parse("$baseUrl/resource/Table%20Order"),
        headers: headers,
        body: json.encode(body));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = OrdersP2.fromJson(jsonResponse);
      await http.post(
        Uri.parse("https://prime-verified-pug.ngrok-free.app/api/orders/"),
        headers: headers,
        body: json.encode({
          "order_id": data.dataP2?.name,
          "status_kds":"wannaStart"
        }));
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = OrdersP2.fromJson(jsonResponse);
      return data;
    }
  }

  @override
  Future<OrdersP1> retrieveTableOrderPart1(Map<String, dynamic> params) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };

    final Uri uri = Uri.parse("$baseUrl/resource/Table%20Order");

    final filters = params['filters'];
    final filtersJson = json.encode(filters);

    final Map<String, String> queryParams = {
      "fields": json.encode(params['fields']),
      "filters": filtersJson,
    };

    final response = await http.get(uri.replace(queryParameters: queryParams),
        headers: headers);
    print(response.statusCode);
    print(uri.replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = OrdersP1.fromJson(jsonResponse);
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = OrdersP1.fromJson(jsonResponse);
      return data;
    }
  }

  @override
  Future<OrdersP2> retrieveTableOrderPart2(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };
    final response = await http.get(
      Uri.parse("$baseUrl/resource/Table%20Order/$id"),
      headers: headers,
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        final data = OrdersP2.fromJson(jsonResponse);
        print("waa ${data.dataP2?.name!}");
        print(
            "waa ${data.dataP2?.entryItems!.map((entryMap) => entryMap.toJson()).toList()}");
        return data;
      } catch (e) {
        print('Error parsing JSON: $e');
        return OrdersP2();
      }
    } else {
      print('Failed to fetch data. Status Code: ${response.statusCode}');
      return OrdersP2();
    }
  }

  @override
  Future<OrdersP2> updateOrder(Map<String, dynamic> body, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };
    final response = await http.put(
        Uri.parse("$baseUrl/resource/Table%20Order/$id"),
        headers: headers,
        body: json.encode(body));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = OrdersP2.fromJson(jsonResponse);
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = OrdersP2.fromJson(jsonResponse);
      return data;
    }
  }
}
