import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> sendConnectionRequest(String receiverId) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) return false;

      if (currentUser.uid == receiverId) {
        return false;
      }

      final existingRequest = await _firestore
          .collection("connection_requests")
          .where("senderId", isEqualTo: currentUser.uid)
          .where("receiverId", isEqualTo: receiverId)
          .where("status", isEqualTo: "pending")
          .limit(1)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        return false;
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
    Future<String> getConnectionStatus(String otherUserId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return "connect";

    // Check request sent by current user
    final sentRequest = await _firestore
        .collection("connection_requests")
        .where("senderId", isEqualTo: currentUser.uid)
        .where("receiverId", isEqualTo: otherUserId)
        .limit(1)
        .get();

    if (sentRequest.docs.isNotEmpty) {
      final status = sentRequest.docs.first["status"];

      if (status == "pending") {
        return "requested";
      }

      if (status == "accepted") {
        return "connected";
      }
    }

    // Check request received from other user
    final receivedRequest = await _firestore
        .collection("connection_requests")
        .where("senderId", isEqualTo: otherUserId)
        .where("receiverId", isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    if (receivedRequest.docs.isNotEmpty) {
      final status = receivedRequest.docs.first["status"];

      if (status == "pending") {
        return "received";
      }

      if (status == "accepted") {
        return "connected";
      }
    }

    return "connect";
  }

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
    Stream<String> getConnectionStatusStream(String otherUserId) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.value("connect");
    }

    return _firestore
        .collection("connection_requests")
        .snapshots()
        .map((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();

        final senderId = data["senderId"];
        final receiverId = data["receiverId"];
        final status = data["status"];

        // Current user sent request
        if (senderId == currentUser.uid &&
            receiverId == otherUserId) {
          if (status == "pending") return "requested";
          if (status == "accepted") return "connected";
        }

        // Other user sent request
        if (senderId == otherUserId &&
            receiverId == currentUser.uid) {
          if (status == "pending") return "received";
          if (status == "accepted") return "connected";
        }
      }

      return "connect";
    });
  }

  Future<void> acceptRequest(
    String requestId,
    String senderId,
  ) async {
    final currentUser = _auth.currentUser!;

    await _firestore
        .collection("connection_requests")
        .doc(requestId)
        .update({
      "status": "accepted",
    });

    await _firestore.collection("connections").add({
      "user1": senderId,
      "user2": currentUser.uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectRequest(String requestId) async {
    await _firestore
        .collection("connection_requests")
        .doc(requestId)
        .update({
      "status": "rejected",
    });
  }
}