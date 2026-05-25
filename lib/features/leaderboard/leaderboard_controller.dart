import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../core/cache/local_cache.dart';
import 'leaderboard_entry.dart';
import 'leaderboard_repository.dart';

class LeaderboardController extends GetxController {
  LeaderboardController({
    required LeaderboardRepository repository,
    required LocalCache cache,
  })  : _repository = repository,
        _cache = cache;

  final LeaderboardRepository _repository;
  final LocalCache _cache;

  final entries = <LeaderboardEntry>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    entries.assignAll(_cache.readLeaderboard());
    refreshLeaderboard();
  }

  Future<void> refreshLeaderboard() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final remote = await _repository.fetchTopPlayers();
      if (remote.isNotEmpty) {
        entries.assignAll(remote);
        await _cache.writeLeaderboard(remote);
      }
    } on FirebaseException catch (error) {
      errorMessage.value = error.code == 'permission-denied'
          ? 'Leaderboard access is blocked by Firestore rules.'
          : error.message ?? 'Unable to load leaderboard.';
    } catch (_) {
      errorMessage.value = 'Unable to load leaderboard.';
    } finally {
      isLoading.value = false;
    }
  }
}
