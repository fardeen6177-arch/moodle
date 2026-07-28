class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final DateTime datePosted;
  final String authorName;
  final String? courseId; // Null if site-wide announcement

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.datePosted,
    required this.authorName,
    this.courseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'datePosted': datePosted.toIso8601String(),
      'authorName': authorName,
      'courseId': courseId,
    };
  }

  factory AnnouncementModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return AnnouncementModel(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      datePosted: map['datePosted'] != null
          ? DateTime.parse(map['datePosted'])
          : DateTime.now(),
      authorName: map['authorName'] ?? 'Admin',
      courseId: map['courseId'],
    );
  }

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? datePosted,
    String? authorName,
    String? courseId,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      datePosted: datePosted ?? this.datePosted,
      authorName: authorName ?? this.authorName,
      courseId: courseId ?? this.courseId,
    );
  }
}
