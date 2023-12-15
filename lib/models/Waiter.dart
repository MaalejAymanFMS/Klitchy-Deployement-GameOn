class Waiter {
  final String? name;
  final String? image;
  final String? email;

  Waiter({required this.name, required this.image, required this.email });
  factory Waiter.fromJson(Map<String, dynamic> json) {
    return Waiter(
      name: json['first_name'] ?? 'null name',
      image: json['image'] ?? 'null image',
      email: json['email'] ?? "gameprod@game.tn",
    );
  }
}

class Waiters {
  List<Waiter>? data;
  Waiters({this.data});
  factory Waiters.fromJson(Map<String, dynamic> json) {
    return Waiters(
      data: (json['data'] as List?)?.map((e) => Waiter.fromJson(e)).toList(),
    );
  }
}