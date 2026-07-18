import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class PresenceService with WidgetsBindingObserver {
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _setOnline();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOnline();
    } else {
      _setOffline();
    }
  }

  Future<void> _setOnline() async {
    if (_uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .set({
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _setOffline() async {
    if (_uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .set({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}