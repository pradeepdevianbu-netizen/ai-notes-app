import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PresenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> setOnline() async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection("users").doc(user.uid).update({
      "isOnline": true,
      "lastSeen": FieldValue.serverTimestamp(),
    });
  }

  Future<void> setOffline() async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection("users").doc(user.uid).update({
      "isOnline": false,
      "lastSeen": FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStatus(
    String uid,
  ) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots();
  }
}