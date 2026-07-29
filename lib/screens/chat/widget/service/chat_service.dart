import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  /// Generate Chat ID
  String getChatId(String otherUserId) {
    final currentUserId = _auth.currentUser!.uid;

    if (currentUserId.hashCode <= otherUserId.hashCode) {
      return "${currentUserId}_$otherUserId";
    }

    return "${otherUserId}_$currentUserId";
  }

  /// Stream Messages
  Stream<QuerySnapshot> getMessages(
    String otherUserId,
  ) {
    final chatId = getChatId(otherUserId);

    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy(
          "timestamp",
          descending: false,
        )
        .snapshots();
  }

  /// Send Text Message
  Future<void> sendMessage({
    required String receiverId,
    required String text,
    Map<String, dynamic>? replyMessage,
  }) async {
    final senderId = _auth.currentUser!.uid;

    final chatId = getChatId(receiverId);

    final messageRef = _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc();

    final message = {
      "id": messageRef.id,
      "senderId": senderId,
      "receiverId": receiverId,
      "type": "text",
      "text": text,
      "imageUrl": "",
      "voiceUrl": "",
      "fileUrl": "",
      "fileName": "",
      "voiceDuration": 0,
      "replyToMessage": replyMessage,
      "reactions": [],
      "isRead": false,
      "timestamp": FieldValue.serverTimestamp(),
    };

    await messageRef.set(message);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .set({
      "participants": [
        senderId,
        receiverId,
      ],
      "lastMessage": text,
      "lastMessageType": "text",
      "lastMessageTime":
          FieldValue.serverTimestamp(),
      "createdAt":
          FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Send Image Message
  Future<void> sendImageMessage({
    required String receiverId,
    required String imageUrl,
    Map<String, dynamic>? replyMessage,
  }) async {
    final senderId = _auth.currentUser!.uid;

    final chatId = getChatId(receiverId);

    final messageRef = _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc();

    final message = {
      "id": messageRef.id,
      "senderId": senderId,
      "receiverId": receiverId,
      "type": "image",
      "text": "",
      "imageUrl": imageUrl,
      "voiceUrl": "",
      "fileUrl": "",
      "fileName": "",
      "voiceDuration": 0,
      "replyToMessage": replyMessage,
      "reactions": [],
      "isRead": false,
      "timestamp": FieldValue.serverTimestamp(),
    };

    await messageRef.set(message);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .set({
      "participants": [
        senderId,
        receiverId,
      ],
      "lastMessage": "📷 Photo",
      "lastMessageType": "image",
      "lastMessageTime":
          FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
    /// Send Voice Message
  Future<void> sendVoiceMessage({
    required String receiverId,
    required String voiceUrl,
    required int duration,
    Map<String, dynamic>? replyMessage,
  }) async {
    final senderId = _auth.currentUser!.uid;

    final chatId = getChatId(receiverId);

    final messageRef = _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc();

    final message = {
      "id": messageRef.id,
      "senderId": senderId,
      "receiverId": receiverId,
      "type": "voice",
      "text": "",
      "imageUrl": "",
      "voiceUrl": voiceUrl,
      "voiceDuration": duration,
      "fileUrl": "",
      "fileName": "",
      "replyToMessage": replyMessage,
      "reactions": [],
      "isRead": false,
      "timestamp": FieldValue.serverTimestamp(),
    };

    await messageRef.set(message);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .set({
      "participants": [
        senderId,
        receiverId,
      ],
      "lastMessage": "🎤 Voice message",
      "lastMessageType": "voice",
      "lastMessageTime":
          FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Delete Message
  Future<void> deleteMessage(
    String otherUserId,
    String messageId,
  ) async {
    final chatId = getChatId(otherUserId);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  /// Read Receipt
  Future<void> markAsRead({
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
      "isRead": true,
    });
  }

  /// Typing Status
  Future<void> setTyping(
    String otherUserId,
    bool typing,
  ) async {
    final currentUserId = _auth.currentUser!.uid;

    await _firestore
        .collection("typing")
        .doc(otherUserId)
        .set({
      currentUserId: typing,
    }, SetOptions(merge: true));
  }

  /// Listen Typing Status
  Stream<bool> getTypingStatus(
    String otherUserId,
  ) {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection("typing")
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return false;

      final data = snapshot.data();

      return data?[otherUserId] ?? false;
    });
  }

  /// Edit Message
}