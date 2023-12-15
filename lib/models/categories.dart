class Categories {
  List<Categorie>? data;

  Categories({this.data});

  factory Categories.fromJson(Map<String, dynamic>? json) {
    return Categories(
      data: (json?['data'] as List?)?.map((e) => Categorie.fromJson(e)).toList(),
    );
  }
}
class Categorie {
  String? name;
  Categorie({this.name});
  factory Categorie.fromJson(Map<String, dynamic>? json) {
    return Categorie(

        name: json?['name'],
    );

  }
}