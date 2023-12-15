import 'package:klitchyapp/models/kitchenOrders.dart';

abstract class KitchenInteractor {
  Future<List<Order>> fetchOrder();
  Future<void> startOrder(String id);
  Future<void> fetchInProgressOrders();
  Future<void> fetchDoneOrders();
  Future<void> updateStatusOrder(String id);
}
