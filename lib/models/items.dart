class Items {
  List<Item>? data;

  Items({this.data});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      data: (json['data'] as List?)?.map((e) => Item.fromJson(e)).toList(),
    );
  }
}

class Item {
  String? itemName;
  String? image;
  double? standardRate;
  String itemCode;

  Item({this.itemName, this.image, this.standardRate, required this.itemCode});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'] ?? 'null name',
      image: json['image'] ?? 'null image',
      standardRate: json['standard_rate']?.toDouble() ?? 0.0,
      itemCode: json['item_code'] ?? "item_code",
    );
  }
}




