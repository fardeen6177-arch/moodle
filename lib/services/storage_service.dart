
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file using bytes (Ensures compatibility across Web, iOS, and Android)
  /// Returns the download URL of the uploaded file.
  Future<String> uploadFile({
    required String path,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final Reference ref = _storage.ref().child(path).child(fileName);
      
      // Upload the raw data
      final UploadTask uploadTask = ref.putData(fileBytes);
      
      // Wait for the upload to complete
      final TaskSnapshot snapshot = await uploadTask;
      
      // Retrieve and return the public download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file to storage: $e');
    }
  }

  /// Deletes a file from storage using its download URL
  Future<void> deleteFile(String fileUrl) async {
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file from storage: $e');
    }
  }
}