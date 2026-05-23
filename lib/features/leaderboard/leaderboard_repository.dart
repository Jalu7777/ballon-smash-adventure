import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/firebase/firebase_guard.dart';
import 'leaderboard_entry.dart';

class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchTopPlayers({int limit = 50}) async {
    if (!isFirebaseReady) {
      return const [];
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((document) => LeaderboardEntry.fromJson(document.data()))
        .toList();
  }
}
