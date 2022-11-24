class Task {
  String title;
  String description;
  int category;
  int points;
  String id;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.points,
    required this.id,
  });

  Task.fromMap(Map<String, dynamic> data, String id)
      : title = data['title'],
        description = data['description'],
        category = data['category'],
        points = data['points'],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'points': points,
    };
  }
}
