import 'dart:typed_data';
import '../models/assignment_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class AssignmentRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  AssignmentRepository(this._firestoreService, this._storageService);

  /// Retrieves a continuous stream of all assignments across all courses
  Stream<List<AssignmentModel>> getAllAssignments() {
    return _firestoreService.collectionStream<AssignmentModel>(
      path: 'assignments',
      builder: (data, documentId) => AssignmentModel.fromMap(data, documentId),
    );
  }

  /// Retrieves a continuous stream of a single assignment by its ID
  Stream<AssignmentModel> getAssignmentById(String assignmentId) {
    return _firestoreService.documentStream<AssignmentModel>(
      path: 'assignments/$assignmentId',
      builder: (data, documentId) {
        if (data == null) {
          throw Exception('Assignment not found');
        }
        return AssignmentModel.fromMap(data, documentId);
      },
    );
  }

  /// Submits an assignment, uploading an attachment to Storage if provided
  Future<void> submitAssignment({
    required String assignmentId,
    required String submissionText,
    String? fileName,
    Uint8List? fileBytes,
  }) async {
    String? fileUrl;

    try {
      // 1. Upload the attachment to Firebase Storage if bytes are provided
      if (fileName != null && fileBytes != null) {
        final path = 'submissions/$assignmentId';
        fileUrl = await _storageService.uploadFile(
          path: path,
          fileName: fileName,
          fileBytes: fileBytes,
        );
      }

      // 2. Update the assignment document in Firestore with the submission data
      final Map<String, dynamic> updateData = {
        'isSubmitted': true,
      };
      
      if (submissionText.isNotEmpty) {
        updateData['submissionText'] = submissionText;
      }
      
      if (fileUrl != null) {
        updateData['fileUrl'] = fileUrl;
      }

      await _firestoreService.updateDocument(
        path: 'assignments/$assignmentId',
        data: updateData,
      );
    } catch (e) {
      throw Exception('Failed to submit assignment: $e');
    }
  }
}