class Invoice {
  String? docstatus;
  String? title;
  String? naming_series;
  String? customer;
  String? customer_name;
  String? pos_profile;
  String? is_pos;
  String? company;
  String? currency;
  String? selling_price_list;
  String? price_list_currency;
  String? set_warehouse;
  String? update_stock;
  String? total_qty;
  String? total;
  String? net_total;
  String? apply_discount_on;
  String? additional_discount_percentage;
  String? discount_amount;
  String? grand_total;
  String? paid_amount;
  String? change_amount;
  String? account_for_change_amount;
  String? write_off_account;
  String? write_off_cost_center;
  String? customer_group;
  String? is_discounted;
  String? status;
  String? debit_to;
  String? party_account_currency;
  String? doctype;
  List<dynamic>? items;
  List<dynamic>? payments;

  Invoice({
    this.docstatus,
    this.title,
    this.naming_series,
    this.customer,
    this.customer_name,
    this.pos_profile,
    this.is_pos,
    this.company,
    this.currency,
    this.selling_price_list,
    this.price_list_currency,
    this.set_warehouse,
    this.update_stock,
    this.total_qty,
    this.total,
    this.net_total,
    this.apply_discount_on,
    this.additional_discount_percentage,
    this.discount_amount,
    this.grand_total,
    this.paid_amount,
    this.change_amount,
    this.account_for_change_amount,
    this.write_off_account,
    this.write_off_cost_center,
    this.customer_group,
    this.is_discounted,
    this.status,
    this.debit_to,
    this.party_account_currency,
    this.doctype,
    this.items,
    this.payments,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      docstatus: json['docstatus'],
      title: json['title'],
      naming_series: json['naming_series'],
      customer: json['customer'],
      customer_name: json['customer_name'],
      pos_profile: json['pos_profile'],
      is_pos: json['is_pos'],
      company: json['company'],
      currency: json['currency'],
      selling_price_list: json['selling_price_list'],
      price_list_currency: json['price_list_currency'],
      set_warehouse: json['set_warehouse'],
      update_stock: json['update_stock'],
      total_qty: json['total_qty'],
      total: json['total'],
      net_total: json['net_total'],
      apply_discount_on: json['apply_discount_on'],
      additional_discount_percentage: json['additional_discount_percentage'],
      discount_amount: json['discount_amount'],
      grand_total: json['grand_total'],
      paid_amount: json['paid_amount'],
      change_amount: json['change_amount'],
      account_for_change_amount: json['account_for_change_amount'],
      write_off_account: json['write_off_account'],
      write_off_cost_center: json['write_off_cost_center'],
      customer_group: json['customer_group'],
      is_discounted: json['is_discounted'],
      status: json['status'],
      debit_to: json['debit_to'],
      party_account_currency: json['party_account_currency'],
      doctype: json['doctype'],
      items: json['items'],
      payments: json['payments'],
    );
  }
}
