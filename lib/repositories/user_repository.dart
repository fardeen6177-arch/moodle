import 'dart:typed_data';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  UserRepository(this._firestoreService, this._storageService);

  /// Retrieves a continuous stream of the user's profile
  Stream<UserModel> getUserProfile(String uid) {
    return _firestoreService.documentStream<UserModel>(
      path: 'users/$uid',
      builder: (data, documentId) {
        if (data == null) {
          throw Exception('User profile not found');
        }
        return UserModel.fromMap(data, documentId);
      },
    );
  }

  /// Updates the user's profile information in Firestore
  Future<void> updateUserProfile(UserModel user) async {
    await _firestoreService.updateDocument(
      path: 'users/${user.id}',
      data: user.toMap(),
    );
  }

  /// Uploads a new profile picture to Storage and updates the Firestore profile document
  Future<void> updateProfilePicture({
    required String uid,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final path = 'profile_pictures/$uid';
      
      // Upload the image and get the new URL
      final downloadUrl = await _storageService.uploadFile(
        path: path,
        fileName: fileName,
        fileBytes: fileBytes,
      );

      // Update the user's document with the new image URL
      await _firestoreService.updateDocument(
        path: 'users/$uid',
        data: {'profileImageUrl': downloadUrl},
      );
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}