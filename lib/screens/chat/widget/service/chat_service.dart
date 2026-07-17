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

  Future<void> setTyping({
    required String otherUserId,
    required bool isTyping,
    String? replyToMessage,
    String? replyToSender,
  }) async {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(otherUserId);

    await _firestore.collection("chats").doc(chatId).set({
      "typing.$currentUid": isTyping,
    }, SetOptions(merge: true));
  }

  Stream<bool> getTypingStatus(String otherUserId) {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(otherUserId);

    return _firestore.collection("chats").doc(chatId).snapshots().map((doc) {
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;

      final typing = data["typing"] ?? {};

      return typing[otherUserId] ?? false;
    });
  }

  Future<void> sendMessage({
    required String otherUserId,
    required String text,
    Map<String, dynamic>? replyToMessage,
    String? replyToSender,
  }) async {
    if (text.trim().isEmpty) return;

    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(otherUserId);

    final chatRef = _firestore.collection("chats").doc(chatId);

    final messageRef = chatRef.collection("messages").doc();

    final batch = _firestore.batch();
    batch.set(
      chatRef,
      {
        "participants": [currentUid, otherUserId],
        "lastMessage": text.trim(),
        "lastMessageTime": FieldValue.serverTimestamp(),
        "createdAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    batch.set(messageRef, {
      "senderId": currentUid,
      "receiverId": otherUserId,
      "text": text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
      "readAt": null,
      "isDeleted": false,
      "deletedAt": null,
      "deletedFor": {},
      "replyTo": null,
      "reactions": {},
      "isEdited": false,
      "replyToMessage": replyToMessage,
      "replyToSender": replyToSender,
    });

    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
    String otherUserId,
  ) {
    final chatId = getChatId(otherUserId);

    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> markMessagesAsRead(String otherUserId) async {
    final currentUid = _auth.currentUser!.uid;

    final chatId = getChatId(otherUserId);

    final snapshot = await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("receiverId", isEqualTo: currentUid)
        .where("isRead", isEqualTo: false)
        .get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        "isRead": true,
        "readAt": FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> deleteForEveryone({
    required String otherUserId,
    required String messageId,
  }) async {
    final chatId = getChatId(otherUserId);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .update({
      "isDeleted": true,
      "text": "This message was deleted",
      "deletedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteForMe({
    required String otherUserId,
    required String messageId,
  }) async {
    final currentUid = _auth.currentUser!.uid;

    final chatId = getChatId(otherUserId);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .update({
      "deletedFor.$currentUid": true,
    });

    Future<void> markMessagesAsRead(String otherUserId) async {
      final currentUid = _auth.currentUser!.uid;

      final chatId = getChatId(otherUserId);

      final snapshot = await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .where("receiverId", isEqualTo: currentUid)
          .where("isRead", isEqualTo: false)
          .get();

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          "isRead": true,
        });
      }

      await batch.commit();
    }

    Future<void> deleteForEveryone({
      required String otherUserId,
      required String messageId,
    }) async {
      final chatId = getChatId(otherUserId);

      await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update({
        "isDeleted": true,
        "text": "This message was deleted",
        "deletedAt": FieldValue.serverTimestamp(),
      });
    }

    Future<void> deleteForMe({
      required String otherUserId,
      required String messageId,
    }) async {
      final currentUid = _auth.currentUser!.uid;

      final chatId = getChatId(otherUserId);

      await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update({
        "deletedFor.$currentUid": true,
      });
    }
  }
}
