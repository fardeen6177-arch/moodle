import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/assignment_model.dart';
import '../repositories/assignment_repository.dart';

class AssignmentProvider extends ChangeNotifier {
  final AssignmentRepository _assignmentRepository;
  StreamSubscription<List<AssignmentModel>>? _assignmentsSubscription;

  List<AssignmentModel> _assignments = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  AssignmentProvider(this._assignmentRepository) {
    _initAssignmentsStream();
  }

  // Getters
  List<AssignmentModel> get assignments => _assignments;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  /// Subscribes to the Firestore stream and updates the UI automatically
  void _initAssignmentsStream() {
    _isLoading = true;
    notifyListeners();

    _assignmentsSubscription = _assignmentRepository.getAllAssignments().listen(
      (assignmentsList) {
        _assignments = assignmentsList;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Failed to load assignments: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  /// Helper to get assignments specific to a single course
  List<AssignmentModel> getAssignmentsForCourse(String courseId) {
    return _assignments.where((a) => a.courseId == courseId).toList();
  }

  /// Submits an assignment and manages the loading state for the UI
  Future<bool> submitAssignment({
    required String assignmentId,
    required String submissionText,
    String? fileName,
    Uint8List? fileBytes,
  }) async {
    try {
      _isSubmitting = true;
      _errorMessage = null;
      notifyListeners();

      await _assignmentRepository.submitAssignment(
        assignmentId: assignmentId,
        submissionText: submissionText,
        fileName: fileName,
        fileBytes: fileBytes,
      );

      _isSubmitting = false;
      notifyListeners();
      return true; // Success
    } catch (e) {
      _isSubmitting = false;
      _errorMessage = 'Failed to submit assignment: ${e.toString()}';
      notifyListeners();
      return false; // Failed
    }
  }

  @override
  void dispose() {
    _assignmentsSubscription?.cancel();
    super.dispose();
  }
}