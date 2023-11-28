import '../models/categories.dart';
import '../models/items.dart';

abstract class TableOrderInteractor {
  Future<Categories> retrieveCategories();
  Future<Items> retrieveItems(Map<String, dynamic>? params);
}