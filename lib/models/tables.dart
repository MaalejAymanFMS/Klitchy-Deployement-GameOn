class ListTables {
  List<Table>? data;

  ListTables({this.data});

  factory ListTables.fromJson(Map<String, dynamic>? json) {
    return ListTables(
      data: (json?['data'] as List?)?.map((e) => Table.fromJson(e)).toList(),
    );
  }
}

class AddTable {
  Table? data;

  AddTable({this.data});

  factory AddTable.fromJson(Map<String, dynamic>? json) {
    return AddTable(data: Table.fromJson(json?['data']));
  }
}

class Table {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentField;
  String? parentType;
  int? idx;
  int? docStatus;
  String? type;
  String? room;
  int? noOfSeats;
  int? minimumSeating;
  String? description;
  String? color;
  String? dataStyle;
  String? currentUser;
  String? roomDescription;
  String? shape;
  String? doctype;
  List<dynamic>? statusManaged;
  List<dynamic>? productionCenterGroup;

  Table({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.parent,
    this.parentField,
    this.parentType,
    this.idx,
    this.docStatus,
    this.type,
    this.room,
    this.noOfSeats,
    this.minimumSeating,
    this.description,
    this.color,
    this.dataStyle,
    this.currentUser,
    this.roomDescription,
    this.shape,
    this.doctype,
    this.statusManaged,
    this.productionCenterGroup,
  });

  factory Table.fromJson(Map<String, dynamic>? json) {
    return Table(
      name: json?['name'],
      owner: json?['owner'],
      creation: json?['creation'],
      modified: json?['modified'],
      modifiedBy: json?['modified_by'],
      parent: json?['parent'],
      parentField: json?['parentfield'],
      parentType: json?['parenttype'],
      idx: json?['idx'],
      docStatus: json?['docstatus'],
      type: json?['type'],
      room: json?['room'],
      noOfSeats: json?['no_of_seats'],
      minimumSeating: json?['minimum_seating'],
      description: json?['description'],
      color: json?['color'],
      dataStyle: json?['data_style'],
      currentUser: json?['current_user'],
      roomDescription: json?['room_description'],
      shape: json?['shape'],
      doctype: json?['doctype'],
      statusManaged: json?['status_managed'],
      productionCenterGroup: json?['production_center_group'],
    );
  }
}

class DeleteTable {
  String? message;
  DeleteTable({this.message});

  factory DeleteTable.fromJson(Map<String, dynamic>? json) {
    return DeleteTable(
      message: json?["message"],
    );
  }
}
