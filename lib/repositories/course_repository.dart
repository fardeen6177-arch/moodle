import '../models/course_model.dart';
import '../services/firestore_service.dart';

class CourseRepository {
  final FirestoreService _firestoreService;

  CourseRepository(this._firestoreService);

  /// Retrieves a continuous stream of all available courses
  Stream<List<CourseModel>> getAllCourses() {
    return _firestoreService.collectionStream<CourseModel>(
      path: 'courses',
      builder: (data, documentId) => CourseModel.fromMap(data, documentId),
    );
  }

  /// Retrieves a continuous stream of a single course by its ID
  Stream<CourseModel> getCourseById(String courseId) {
    return _firestoreService.documentStream<CourseModel>(
      path: 'courses/$courseId',
      builder: (data, documentId) {
        if (data == null) {
          throw Exception('Course not found');
        }
        return CourseModel.fromMap(data, documentId);
      },
    );
  }

  /// Searches for courses based on a text query
  Future<List<CourseModel>> searchCourses(String query) async {
    // In a production app, you might use Algolia or Firebase Extensions for full-text search.
    // For this clone, we fetch the courses and filter locally to meet the "Global Search" requirement.
    final allCourses = await _firestoreService.getCollection<CourseModel>(
      path: 'courses',
      builder: (data, documentId) => CourseModel.fromMap(data, documentId),
    );

    final lowercaseQuery = query.toLowerCase();
    return allCourses.where((course) {
      return course.title.toLowerCase().contains(lowercaseQuery) ||
             course.courseCode.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}