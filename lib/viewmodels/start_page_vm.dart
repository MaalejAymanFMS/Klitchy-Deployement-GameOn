import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klitchyapp/models/tables.dart' as tb;
import 'package:klitchyapp/viewmodels/start_page_interractor.dart';
import 'package:http/http.dart' as http;
import 'package:klitchyapp/views/StartPageUI.dart';
import 'package:klitchyapp/widget/waiterWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/AppState.dart';
import '../utils/constants.dart';

class StartPageVM extends StatefulWidget {
  final String name;
  final String id;
  final AppState appState;
  final bool room;

  const StartPageVM(
      {Key? key,
      required this.name,
      required this.id,
      required this.appState,
      required this.room})
      : super(key: key);

  @override
  StartPageVMState createState() => StartPageVMState();
}

class StartPageVMState extends State<StartPageVM>
    implements StartPageInterractor {
  @override
  Widget build(BuildContext context) {
    return StartPageUI(
      name: widget.name,
      id: widget.id,
      appState: widget.appState,
      room: widget.room,
    );
  }

  @override
  Future<tb.AddTable> addTable(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };
    final response = await http.post(
        Uri.parse("$baseUrl/resource/Restaurant%20Object"),
        headers: headers,
        body: json.encode(body));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = tb.AddTable.fromJson(jsonResponse);
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = tb.AddTable.fromJson(jsonResponse);
      return data;
    }
  }

  @override
  Future<tb.ListTables> retrieveListOfTables(
      Map<String, dynamic> params) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };

    final Uri uri = Uri.parse("$baseUrl/resource/Restaurant%20Object");

    final filters = params['filters'];
    final filtersJson = json.encode(filters);

    final Map<String, String> queryParams = {
      "fields": json.encode(params['fields']),
      "filters": filtersJson,
      "limit_page_length": "None"
    };

    final response = await http.get(uri.replace(queryParameters: queryParams),
        headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = tb.ListTables.fromJson(jsonResponse);
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = tb.ListTables.fromJson(jsonResponse);
      return data;
    }
  }

  @override
  Future<tb.DeleteTable> deleteTable(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };
    final response = await http.delete(
        Uri.parse("$baseUrl/resource/Restaurant%20Object/$id"),
        headers: headers);
    if (response.statusCode == 202) {
      final jsonResponse = json.decode(response.body);
      final data = tb.DeleteTable.fromJson(jsonResponse);
      return data;
    } else if (statusCode == 417) {
      return tb.DeleteTable(message: "You can't delete this table");
    } else {
      return tb.DeleteTable(message: "Server error");
    }
  }

  @override
  Future<tb.AddTable> updateTable(Map<String, dynamic> body, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json; charset=utf-8",
      "Authorization": "$token"
    };
    final response = await http.put(
        Uri.parse("$baseUrl/resource/Restaurant%20Object/$id"),
        headers: headers,
        body: json.encode(body));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = tb.AddTable.fromJson(jsonResponse);
      return data;
    } else {
      final jsonResponse = json.decode(response.body);
      final data = tb.AddTable.fromJson(jsonResponse);
      return data;
    }
  }
}
