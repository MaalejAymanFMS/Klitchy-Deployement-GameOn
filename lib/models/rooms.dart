class Rooms {
  Room data;

  Rooms({required this.data});

  factory Rooms.fromJson(Map<String, dynamic>? json) {
    return Rooms(data: Room.fromJson(json?['data']));
  }
}

class Room {
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
  String? type;
  String? room;
  int? no_of_seats;
  int? minimum_seating;
  String? description;
  String? color;
  String? data_style;
  String? current_user;
  String? room_description;
  String? shape;
  String? doctype;
  List<dynamic>? status_managed;
  List<dynamic>? production_center_group;

  Room({
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
    this.type,
    this.room,
    this.no_of_seats,
    this.minimum_seating,
    this.description,
    this.color,
    this.data_style,
    this.current_user,
    this.room_description,
    this.shape,
    this.doctype,
    this.status_managed,
    this.production_center_group,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modified_by: json['modified_by'],
      parent: json['parent'],
      parentfield: json['parentfield'],
      parenttype: json['parenttype'],
      idx: json['idx'],
      docstatus: json['docstatus'],
      type: json['type'],
      room: json['room'],
      no_of_seats: json['no_of_seats'],
      minimum_seating: json['minimum_seating'],
      description: json['description'],
      color: json['color'],
      data_style: json['data_style'],
      current_user: json['current_user'],
      room_description: json['room_description'],
      shape: json['shape'],
      doctype: json['doctype'],
      status_managed: json['status_managed'],
      production_center_group: json['production_center_group'],
    );
  }
}

class ListRooms {
  List<Room>? data;

  ListRooms({this.data});

  factory ListRooms.fromJson(Map<String, dynamic>? json) {
    return ListRooms(
      data: (json?['data'] as List?)?.map((e) => Room.fromJson(e)).toList(),
    );  }
}
