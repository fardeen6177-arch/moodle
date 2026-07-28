class CourseModel {
  final String id;
  final String title;
  final String courseCode;
  final String description;
  final String instructor;
  final double progress; // 0.0 to 1.0

  CourseModel({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.description,
    required this.instructor,
    this.progress = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'courseCode': courseCode,
      'description': description,
      'instructor': instructor,
      'progress': progress,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CourseModel(
      id: documentId,
      title: map['title'] ?? '',
      courseCode: map['courseCode'] ?? '',
      description: map['description'] ?? '',
      instructor: map['instructor'] ?? '',
      progress: (map['progress'] ?? 0.0).toDouble(),
    );
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? courseCode,
    String? description,
    String? instructor,
    double? progress,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
    );
  }
}