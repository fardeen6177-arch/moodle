class AssignmentModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isSubmitted;
  final String? submissionText;
  final String? fileUrl;
  final double? grade;
  final double maxGrade;

  AssignmentModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isSubmitted = false,
    this.submissionText,
    this.fileUrl,
    this.grade,
    this.maxGrade = 100.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isSubmitted': isSubmitted,
      'submissionText': submissionText,
      'fileUrl': fileUrl,
      'grade': grade,
      'maxGrade': maxGrade,
    };
  }

  factory AssignmentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AssignmentModel(
      id: documentId,
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate']) 
          : DateTime.now(),
      isSubmitted: map['isSubmitted'] ?? false,
      submissionText: map['submissionText'],
      fileUrl: map['fileUrl'],
      grade: map['grade'] != null ? (map['grade'] as num).toDouble() : null,
      maxGrade: (map['maxGrade'] ?? 100.0).toDouble(),
    );
  }

  AssignmentModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isSubmitted,
    String? submissionText,
    String? fileUrl,
    double? grade,
    double? maxGrade,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      submissionText: submissionText ?? this.submissionText,
      fileUrl: fileUrl ?? this.fileUrl,
      grade: grade ?? this.grade,
      maxGrade: maxGrade ?? this.maxGrade,
    );
  }
}