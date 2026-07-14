import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getChatId(String otherUserId) {
    final currentUid = _auth.currentUser!.uid;

    final ids = [currentUid, otherUserId]..sort();

    return ids.join("_");
  }

  Future<void> sendMessage({
    required String otherUserId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(otherUserId);

    await _firestore.collection("chats").doc(chatId).set({
      "participants": [currentUid, otherUserId],
      "lastMessage": text,
      "lastMessageTime": FieldValue.serverTimestamp(),
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
      "senderId": currentUid,
      "text": text,
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });
  }

  Stream<QuerySnapshot> getMessages(String otherUserId) {
    final chatId = getChatId(otherUserId);

    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }
}