
class Task {
  final String id;
  final String title;
  bool isDone;

  Task({
  required this.id,
  required this.title,
  required this.isDone,
  });

  Map<String, dynamic> toJSON() {
    var format = {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
    return format;
  }
}