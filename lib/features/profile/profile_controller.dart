import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/cache/local_cache.dart';
import 'player_profile.dart';
import 'profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController({
    required ProfileRepository repository,
    required LocalCache cache,
  })  : _repository = repository,
        _cache = cache;

  final ProfileRepository _repository;
  final LocalCache _cache;

  final profile = Rxn<PlayerProfile>();
  final isLoading = false.obs;
  StreamSubscription<User?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    profile.value = _cache.readProfile();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        profile.value = null;
        return;
      }

      final cached = _cache.readProfile();
      profile.value = cached?.uid == user.uid ? cached : null;
      refreshProfile();
    });
  }

  Future<void> refreshProfile() async {
    isLoading.value = true;
    try {
      final remote = await _repository.fetchCurrentProfile();
      if (remote != null) {
        profile.value = remote;
        await _cache.writeProfile(remote);
        await _cache.writeBestScore(remote.bestScore);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recordGameScore(int score) async {
    final remote = await _repository.recordScore(score);
    if (remote != null) {
      profile.value = remote;
      await _cache.writeProfile(remote);
      await _cache.writeBestScore(remote.bestScore);
    } else {
      final cached = profile.value;
      if (cached != null && score > cached.bestScore) {
        final next = cached.copyWith(bestScore: score, updatedAt: DateTime.now());
        profile.value = next;
        await _cache.writeProfile(next);
      }
      if (score > _cache.readBestScore()) {
        await _cache.writeBestScore(score);
      }
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
