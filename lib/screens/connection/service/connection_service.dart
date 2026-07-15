import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Check already connected
  Future<bool> checkRequest(String otherUserId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return false;

    final snapshot = await _firestore
        .collection("connections")
        .where(
          Filter.or(
            Filter.and(
              Filter("user1", isEqualTo: currentUser.uid),
              Filter("user2", isEqualTo: otherUserId),
            ),
            Filter.and(
              Filter("user1", isEqualTo: otherUserId),
              Filter("user2", isEqualTo: currentUser.uid),
            ),
          ),
        )
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Send Request
  Future<bool> sendConnectionRequest(String receiverId) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) return false;

      if (currentUser.uid == receiverId) {
        return false;
      }

      final existingRequest = await _firestore
          .collection("connection_requests")
          .where(
            Filter.or(
              Filter.and(
                Filter("senderId", isEqualTo: currentUser.uid),
                Filter("receiverId", isEqualTo: receiverId),
              ),
              Filter.and(
                Filter("senderId", isEqualTo: receiverId),
                Filter("receiverId", isEqualTo: currentUser.uid),
              ),
            ),
          )
          .limit(1)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        final doc = existingRequest.docs.first;
        final status = doc["status"];

        if (status == "pending" || status == "accepted") {
          return false;
        }

        await doc.reference.delete();
      }

      await _firestore.collection("connection_requests").add({
        "senderId": currentUser.uid,
        "receiverId": receiverId,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Connection Status Stream
  Stream<String> getConnectionStatusStream(String otherUserId) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.value("connect");
    }

    return _firestore
        .collection("connection_requests")
        .where(
          Filter.or(
            Filter.and(
              Filter("senderId", isEqualTo: currentUser.uid),
              Filter("receiverId", isEqualTo: otherUserId),
            ),
            Filter.and(
              Filter("senderId", isEqualTo: otherUserId),
              Filter("receiverId", isEqualTo: currentUser.uid),
            ),
          ),
        )
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return "connect";
      }

      final data = snapshot.docs.first.data();

      final status = data["status"];
      final senderId = data["senderId"];

      if (status == "accepted") {
        return "connected";
      }

      if (status == "pending") {
        return senderId == currentUser.uid ? "requested" : "received";
      }

      return "connect";
    });
  }

  /// Cancel Request
  Future<void> cancelRequest(String receiverId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection("connection_requests")
        .where("senderId", isEqualTo: currentUser.uid)
        .where("receiverId", isEqualTo: receiverId)
        .where("status", isEqualTo: "pending")
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Accept Request
  Future<void> acceptRequest(
    String requestId,
    String senderId,
  ) async {
    final currentUser = _auth.currentUser!;

    await _firestore.collection("connection_requests").doc(requestId).update({
      "status": "accepted",
    });

    await _firestore.collection("connections").add({
      "user1": senderId,
      "user2": currentUser.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Reject Request
  Future<void> rejectRequest(String requestId) async {
    await _firestore.collection("connection_requests").doc(requestId).update({
      "status": "rejected",
    });
  }

  /// Disconnect
  Future<void> disconnect(String otherUserId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    final requestSnapshot = await _firestore
        .collection("connection_requests")
        .where("status", isEqualTo: "accepted")
        .get();

    for (final doc in requestSnapshot.docs) {
      final data = doc.data();

      if ((data["senderId"] == currentUser.uid &&
              data["receiverId"] == otherUserId) ||
          (data["senderId"] == otherUserId &&
              data["receiverId"] == currentUser.uid)) {
        await doc.reference.delete();
      }
    }

    final connectionSnapshot = await _firestore.collection("connections").get();

    for (final doc in connectionSnapshot.docs) {
      final data = doc.data();

      if ((data["user1"] == currentUser.uid && data["user2"] == otherUserId) ||
          (data["user1"] == otherUserId && data["user2"] == currentUser.uid)) {
        await doc.reference.delete();
      }
    }
  }
}
