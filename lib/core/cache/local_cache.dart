import 'package:get_storage/get_storage.dart';

import '../../features/leaderboard/leaderboard_entry.dart';
import '../../features/profile/player_profile.dart';

class LocalCache {
  LocalCache(this._box);

  final GetStorage _box;

  static const _profileKey = 'profile';
  static const _leaderboardKey = 'leaderboard';
  static const _bestScoreKey = 'bestScore';

  PlayerProfile? readProfile() {
    final data = _box.read<Map<String, dynamic>>(_profileKey);
    return data == null ? null : PlayerProfile.fromJson(data);
  }

  Future<void> writeProfile(PlayerProfile profile) {
    return _box.write(_profileKey, profile.toJson());
  }

  int readBestScore() => _box.read<int>(_bestScoreKey) ?? 0;

  Future<void> writeBestScore(int score) => _box.write(_bestScoreKey, score);

  List<LeaderboardEntry> readLeaderboard() {
    final cached = _box.read<List<dynamic>>(_leaderboardKey) ?? const [];
    return cached
        .whereType<Map>()
        .map((item) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> writeLeaderboard(List<LeaderboardEntry> entries) {
    return _box.write(
      _leaderboardKey,
      entries.map((entry) => entry.toJson()).toList(),
    );
  }
}
