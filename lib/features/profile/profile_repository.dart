import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/firebase/firebase_guard.dart';
import 'player_profile.dart';

class ProfileRepository {
  CollectionReference<Map<String, dynamic>> get _players =>
      FirebaseFirestore.instance.collection('players');

  Future<PlayerProfile?> fetchCurrentProfile() async {
    if (!isFirebaseReady || FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final document = await _players.doc(user.uid).get();
    if (document.exists && document.data() != null) {
      return PlayerProfile.fromJson(document.data()!);
    }
    final profile = PlayerProfile(
      uid: user.uid,
      displayName: user.displayName ?? 'Player',
      email: user.email,
      photoUrl: user.photoURL,
      updatedAt: DateTime.now(),
    );
    await saveProfile(profile);
    return profile;
  }

  Future<void> saveProfile(PlayerProfile profile) async {
    if (!isFirebaseReady) {
      return;
    }
    await _players.doc(profile.uid).set(profile.toJson(), SetOptions(merge: true));
  }

  Future<PlayerProfile?> recordScore(int score) async {
    if (!isFirebaseReady || FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    final user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final playerRef = _players.doc(user.uid);
      final leaderboardRef =
          FirebaseFirestore.instance.collection('leaderboard').doc(user.uid);
      final snapshot = await transaction.get(playerRef);
      final current = snapshot.exists && snapshot.data() != null
          ? PlayerProfile.fromJson(snapshot.data()!)
          : PlayerProfile(
              uid: user.uid,
              displayName: user.displayName ?? 'Player',
              email: user.email,
              photoUrl: user.photoURL,
            );
      final next = current.copyWith(
        bestScore: score > current.bestScore ? score : current.bestScore,
        totalScore: current.totalScore + score,
        gamesPlayed: current.gamesPlayed + 1,
        updatedAt: DateTime.now(),
      );
      transaction.set(playerRef, next.toJson(), SetOptions(merge: true));
      transaction.set(
        leaderboardRef,
        {
          'uid': next.uid,
          'displayName': next.displayName,
          'photoUrl': next.photoUrl,
          'score': next.bestScore,
          'updatedAt': next.updatedAt?.toIso8601String(),
        },
        SetOptions(merge: true),
      );
      return next;
    });
  }

}
