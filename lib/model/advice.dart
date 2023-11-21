class Advice {
  final int id;
  final String body;
  Advice({required this.id, required this.body});

  factory Advice.fromJson(Map json) {
    return Advice(id: json['id'], body: json['advice']);
  }
}
