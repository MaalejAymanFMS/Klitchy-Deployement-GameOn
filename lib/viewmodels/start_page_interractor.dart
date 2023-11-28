import '../models/tables.dart';

abstract class StartPageInterractor {
  Future<AddTable> addTable(Map<String, dynamic> body);
  Future<AddTable> updateTable(Map<String, dynamic> body, String id);
  Future<ListTables> retrieveListOfTables(Map<String, dynamic> params);
  Future<DeleteTable> deleteTable(String id);
}