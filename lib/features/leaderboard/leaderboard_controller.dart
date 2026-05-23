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

  @override
  void onInit() {
    super.onInit();
    entries.assignAll(_cache.readLeaderboard());
    refreshLeaderboard();
  }

  Future<void> refreshLeaderboard() async {
    isLoading.value = true;
    try {
      final remote = await _repository.fetchTopPlayers();
      if (remote.isNotEmpty) {
        entries.assignAll(remote);
        await _cache.writeLeaderboard(remote);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
