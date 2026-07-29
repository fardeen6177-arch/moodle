import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves a continuous stream of a collection
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = _db.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((doc) => builder(doc.data(), doc.id))
        .toList());
  }

  /// Retrieves a continuous stream of a single document
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) {
    final reference = _db.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  /// Fetches a collection once (Future instead of Stream)
  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) async {
    final reference = _db.collection(path);
    final snapshot = await reference.get();
    return snapshot.docs
        .map((doc) => builder(doc.data(), doc.id))
        .toList();
  }

  /// Adds a new document with an auto-generated ID
  Future<String> addDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = _db.collection(path);
    final documentReference = await reference.add(data);
    return documentReference.id;
  }

  /// Creates or updates a document at a specific path with a specific ID
  Future<void> setDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = _db.doc(path);
    await reference.set(data, SetOptions(merge: true));
  }

  /// Updates specific fields in an existing document
  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = _db.doc(path);
    await reference.update(data);
  }

  /// Deletes a document
  Future<void> deleteDocument({required String path}) async {
    final reference = _db.doc(path);
    await reference.delete();
  }
}