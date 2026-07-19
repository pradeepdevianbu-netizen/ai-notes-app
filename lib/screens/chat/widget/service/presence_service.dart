import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class PresenceService with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _uid => _auth.currentUser?.uid;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    setOnline();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setOnline();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        setOffline();
        break;
    }
  }

  Future<void> setOnline() async {
    if (_uid == null) return;

    await _firestore.collection("users").doc(_uid).set(
      {
        "isOnline": true,
        "lastSeen": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> setOffline() async {
    if (_uid == null) return;

    await _firestore.collection("users").doc(_uid).set(
      {
        "isOnline": false,
        "lastSeen": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    setOffline();
  }
}