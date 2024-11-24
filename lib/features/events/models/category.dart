class Category {
  final String id;
  final String name;
  final String iconName;
  final bool requiresRoute; // Nouveau champ

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.requiresRoute, // Ajouter le champ ici
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      iconName: json['iconName'],
      requiresRoute: json['requiresRoute'] ?? false,
    );
  }

  @override
  String toString() {
    return 'SportCategory{id: $id, name: $name, iconName: $iconName, requiresRoute: $requiresRoute}';
  }
}
