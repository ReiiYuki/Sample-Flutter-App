class Pokemon {
  final int id;
  final String name;

  Pokemon({required this.id, required this.name});

  Pokemon.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
