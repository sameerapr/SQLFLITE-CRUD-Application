class Student {
  final int? id;
  final String name;
  final String? course;

  Student({this.id, required this.name, this.course});

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        course: json['course'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
    };
  }
}
