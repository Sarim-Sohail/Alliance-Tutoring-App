class Degree {
  final int userId;
  final int id;
  final String title;

  const Degree({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}