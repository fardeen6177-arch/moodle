class CourseMaterial {
  final String id;
  final String title;
  final String pdfUrl;

  CourseMaterial({
    required this.id,
    required this.title,
    required this.pdfUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'pdfUrl': pdfUrl,
    };
  }

  factory CourseMaterial.fromMap(Map<String, dynamic> map) {
    return CourseMaterial(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
    );
  }
}

class CourseModel {
  final String id;
  final String title;
  final String courseCode;
  final String description;
  final String instructor;
  final double progress;

  /// Course PDFs / Lecture Notes / Resources
  final List<CourseMaterial> materials;

  CourseModel({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.description,
    required this.instructor,
    this.progress = 0.0,
    this.materials = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'courseCode': courseCode,
      'description': description,
      'instructor': instructor,
      'progress': progress,
      'materials': materials.map((e) => e.toMap()).toList(),
    };
  }

  factory CourseModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return CourseModel(
      id: documentId,
      title: map['title'] ?? '',
      courseCode: map['courseCode'] ?? '',
      description: map['description'] ?? '',
      instructor: map['instructor'] ?? '',
      progress: (map['progress'] ?? 0.0).toDouble(),
      materials: (map['materials'] as List<dynamic>?)
              ?.map(
                (e) => CourseMaterial.fromMap(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          [],
    );
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? courseCode,
    String? description,
    String? instructor,
    double? progress,
    List<CourseMaterial>? materials,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
      materials: materials ?? this.materials,
    );
  }
}