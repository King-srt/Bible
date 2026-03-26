import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteBookmarkService {
  RemoteBookmarkService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _bookmarkCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('bookmarks');
  }

  Future<Set<String>> getBookmarks(String uid) async {
    final snapshot = await _bookmarkCollection(uid).get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  Future<void> addBookmark({
    required String uid,
    required String storyId,
  }) async {
    await _bookmarkCollection(uid).doc(storyId).set({
      'storyId': storyId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeBookmark({
    required String uid,
    required String storyId,
  }) async {
    await _bookmarkCollection(uid).doc(storyId).delete();
  }

  Future<void> replaceBookmarks({
    required String uid,
    required Set<String> storyIds,
  }) async {
    final batch = _firestore.batch();
    final collection = _bookmarkCollection(uid);
    final existing = await collection.get();

    for (final doc in existing.docs) {
      if (!storyIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    for (final storyId in storyIds) {
      batch.set(collection.doc(storyId), {
        'storyId': storyId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
