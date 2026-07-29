import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  voice,
  file,
}

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;

  final MessageType type;

  final String text;

  final String imageUrl;

  final String voiceUrl;

  final String fileUrl;

  final String fileName;

  final Duration voiceDuration;

  final bool isRead;

  final Timestamp timestamp;

  final Map<String, dynamic>? replyToMessage;

  final List<String> reactions;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.text,
    required this.imageUrl,
    required this.voiceUrl,
    required this.fileUrl,
    required this.fileName,
    required this.voiceDuration,
    required this.isRead,
    required this.timestamp,
    this.replyToMessage,
    this.reactions = const [],
  });

  factory MessageModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return MessageModel(
      id: id,

      senderId: map["senderId"] ?? "",

      receiverId: map["receiverId"] ?? "",

      type: _getType(
        map["type"] ?? "text",
      ),

      text: map["text"] ?? "",

      imageUrl: map["imageUrl"] ?? "",

      voiceUrl: map["voiceUrl"] ?? "",

      fileUrl: map["fileUrl"] ?? "",

      fileName: map["fileName"] ?? "",

      voiceDuration: Duration(
        seconds: map["voiceDuration"] ?? 0,
      ),

      isRead: map["isRead"] ?? false,

      timestamp:
          map["timestamp"] ??
          Timestamp.now(),

      replyToMessage:
          map["replyToMessage"],

      reactions: List<String>.from(
        map["reactions"] ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,

      "receiverId": receiverId,

      "type": type.name,

      "text": text,

      "imageUrl": imageUrl,

      "voiceUrl": voiceUrl,

      "fileUrl": fileUrl,

      "fileName": fileName,

      "voiceDuration":
          voiceDuration.inSeconds,

      "isRead": isRead,

      "timestamp": timestamp,

      "replyToMessage":
          replyToMessage,

      "reactions": reactions,
    };
  }

  static MessageType _getType(
    String type,
  ) {
    switch (type) {
      case "image":
        return MessageType.image;

      case "voice":
        return MessageType.voice;

      case "file":
        return MessageType.file;

      default:
        return MessageType.text;
    }
  }
}