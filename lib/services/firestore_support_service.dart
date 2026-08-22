import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSupportService {
  FirestoreSupportService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('support_requests');

  // CREATE
  Future<String> createRequest(String message) async {
    final document = await _requests.add({
      'message': message.trim(),
      'status': 'Pendiente',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return document.id;
  }

  // READ
  Stream<QuerySnapshot<Map<String, dynamic>>> readRequests() {
    return _requests.orderBy('createdAt', descending: true).snapshots();
  }

  // UPDATE
  Future<void> updateRequest(
    String id, {
    String? message,
    String? status,
  }) {
    return _requests.doc(id).update({
      if (message != null) 'message': message.trim(),
      if (status != null) 'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE
  Future<void> deleteRequest(String id) {
    return _requests.doc(id).delete();
  }
}

