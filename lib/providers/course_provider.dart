import 'dart:async';
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository _courseRepository;
  StreamSubscription<List<CourseModel>>? _coursesSubscription;

  List<CourseModel> _courses = [];
  bool _isLoading = true;
  String? _errorMessage;

  CourseProvider(this._courseRepository) {
    _initCoursesStream();
  }

  // Getters
  List<CourseModel> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Subscribes to the Firestore stream and updates the UI automatically
  void _initCoursesStream() {
    _isLoading = true;
    notifyListeners();

    _coursesSubscription = _courseRepository.getAllCourses().listen(
      (coursesList) {
        _courses = coursesList;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Failed to load courses: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  /// Filters the currently loaded courses based on a search query
  List<CourseModel> searchCourses(String query) {
    if (query.isEmpty) return _courses;
    
    final lowerQuery = query.toLowerCase();
    return _courses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
             course.courseCode.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  void dispose() {
    _coursesSubscription?.cancel(); // Clean up the stream when destroyed
    super.dispose();
  }
}