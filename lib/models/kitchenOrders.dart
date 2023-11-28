class Order {
  final String? status;
  final String? name;
  final String? tableNumber;
  final List<EntryItem>? items;

  Order({
    this.status,
    this.name,
    this.tableNumber,
    this.items,
  });
}

class EntryItem {
  String itemName;
  double amount;
  int quantity;
  String notes;

  EntryItem({
    required this.itemName,
    required this.amount,
    required this.quantity,
    required this.notes,
  });
}