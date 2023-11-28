class OrdersP1 {
  List<OrderP1>? dataP1;

  OrdersP1({this.dataP1});

  factory OrdersP1.fromJson(Map<String, dynamic>? json) {
    return OrdersP1(
      dataP1: (json?['data'] as List?)?.map((e) => OrderP1.fromJson(e)).toList(),
    );
  }
}

class OrderP1 {
  String? name;
  String? table;
  String? tableDescription;
  OrderP1({this.name, this.table, this.tableDescription});
  factory OrderP1.fromJson(Map<String, dynamic>? json) {
    return OrderP1(
      name: json?['name'],
      table: json?['table'],
      tableDescription:json?['table_description'],
    );

  }
}
class OrdersP2 {
  OrderP2? dataP2;

  OrdersP2({this.dataP2});

  factory OrdersP2.fromJson(Map<String, dynamic>? json) {
    return OrdersP2(
      dataP2: OrderP2.fromJson(json?['data']),
    );
  }
}
class OrderP2 {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modified_by;
  int? idx;
  int? docstatus;
  String? table;
  String? tableDescription;
  String? room;
  String? roomDescription;
  String? namingSeries;
  String? status;
  String? customer;
  int? dinners;
  double? discount;
  double? tax;
  double? amount;
  String? posProfile;
  String? sellingPriceList;
  String? company;
  String? customerName;
  String? doctype;
  List<EntryItem>? entryItems;

  OrderP2({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modified_by,
    this.idx,
    this.docstatus,
    this.table,
    this.tableDescription,
    this.room,
    this.roomDescription,
    this.namingSeries,
    this.status,
    this.customer,
    this.dinners,
    this.discount,
    this.tax,
    this.amount,
    this.posProfile,
    this.sellingPriceList,
    this.company,
    this.customerName,
    this.doctype,
    this.entryItems,
  });

  factory OrderP2.fromJson(Map<String, dynamic>? json) {
    return OrderP2(
      name: json?['name'],
      owner: json?['owner'],
      creation: json?['creation'],
      modified: json?['modified'],
      modified_by: json?['modified_by'],
      idx: json?['idx'],
      docstatus: json?['docstatus'],
      table: json?['table'],
      tableDescription: json?['table_description'],
      room: json?['room'],
      roomDescription: json?['room_description'],
      namingSeries: json?['naming_series'],
      status: json?['status'],
      customer: json?['customer'],
      dinners: json?['dinners'],
      discount: json?['discount'],
      tax: json?['tax'],
      amount: json?['amount'],
      posProfile: json?['pos_profile'],
      sellingPriceList: json?['selling_price_list'],
      company: json?['company'],
      customerName: json?['customer_name'],
      doctype: json?['doctype'],
      entryItems: (json?['entry_items'] as List?)
          ?.map((e) => EntryItem.fromJson(e))
          .toList() ?? [],
    );
  }
}

class   EntryItem {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modified_by;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? item_code;
  String? item_group;
  String? item_name;
  String? status;
  String? notes;
  double? qty;
  double? rate;
  double? valuation_rate;
  double? amount;
  double? price_list_rate;
  double? discount_percentage;
  String? identifier;
  // Map<String, dynamic>? item_tax_rate;
  String? table_description;
  double? discount_amount;
  double? tax_amount;
  String? ordered_time;
  int? has_batch_no;
  String? batch_no;
  int? has_serial_no;
  String? serial_no;
  String? doctype;
  String? warehouse;

  EntryItem({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modified_by,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.idx,
    this.docstatus,
    this.item_code,
    this.item_group,
    this.item_name,
    this.status,
    this.notes,
    this.qty,
    this.rate,
    this.valuation_rate,
    this.amount,
    this.price_list_rate,
    this.discount_percentage,
    this.identifier,
    // this.item_tax_rate,
    this.table_description,
    this.discount_amount,
    this.tax_amount,
    this.ordered_time,
    this.has_batch_no,
    this.batch_no,
    this.has_serial_no,
    this.serial_no,
    this.doctype,
    this.warehouse,
  });

  factory EntryItem.fromJson(Map<String, dynamic>? json) {
    return EntryItem(
      name: json?['name'],
      owner: json?['owner'],
      creation: json?['creation'],
      modified: json?['modified'],
      modified_by: json?['modified_by'],
      parent: json?['parent'],
      parentfield: json?['parentfield'],
      parenttype: json?['parenttype'],
      idx: json?['idx'],
      docstatus: json?['docstatus'],
      item_code: json?['item_code'],
      item_group: json?['item_group'],
      item_name: json?['item_name'],
      status: json?['status'],
      notes: json?['notes'],
      qty: json?['qty'],
      rate: json?['rate'],
      valuation_rate: json?['valuation_rate'],
      amount: json?['amount'],
      price_list_rate: json?['price_list_rate'],
      discount_percentage: json?['discount_percentage'],
      identifier: json?['identifier'],
      // item_tax_rate: json?['item_tax_rate'],
      table_description: json?['table_description'],
      discount_amount: json?['discount_amount'],
      tax_amount: json?['tax_amount'],
      ordered_time: json?['ordered_time'],
      has_batch_no: json?['has_batch_no'],
      batch_no: json?['batch_no'],
      has_serial_no: json?['has_serial_no'],
      serial_no: json?['serial_no'],
      doctype: json?['doctype'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modified_by,
      'parent': parent,
      'parentfield': parentfield,
      'parenttype': parenttype,
      'idx': idx,
      'docstatus': docstatus,
      'item_code': item_code,
      'item_group': item_group,
      'item_name': item_name,
      'status': status,
      'notes': notes,
      'qty': qty,
      'rate': rate,
      'valuation_rate': valuation_rate,
      'amount': amount,
      'price_list_rate': price_list_rate,
      'discount_percentage': discount_percentage,
      'identifier': identifier,
      'table_description': table_description,
      'discount_amount': discount_amount,
      'tax_amount': tax_amount,
      'ordered_time': ordered_time,
      'has_batch_no': has_batch_no,
      'batch_no': batch_no,
      'has_serial_no': has_serial_no,
      'serial_no': serial_no,
      'doctype': doctype,
      'warehouse': warehouse,
    };
  }
}