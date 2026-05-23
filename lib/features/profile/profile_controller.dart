import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _imagePicker = ImagePicker();

  final profile = Rxn<PlayerProfile>();
  final isLoading = false.obs;
  final isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    profile.value = _cache.readProfile();
    refreshProfile();
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

  Future<void> updateDisplayName(String displayName) async {
    final current = profile.value;
    if (current == null || displayName.trim().isEmpty) {
      return;
    }
    final updated = current.copyWith(
      displayName: displayName.trim(),
      updatedAt: DateTime.now(),
    );
    profile.value = updated;
    await _cache.writeProfile(updated);
    await _repository.saveProfile(updated);
  }

  Future<void> pickAndUploadProfileImage() async {
    final current = profile.value;
    if (current == null) {
      return;
    }
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (image == null) {
      return;
    }
    isUploadingImage.value = true;
    try {
      final url = await _repository.uploadProfileImage(File(image.path), current.uid);
      if (url != null) {
        final updated = current.copyWith(photoUrl: url, updatedAt: DateTime.now());
        profile.value = updated;
        await _cache.writeProfile(updated);
        await _repository.saveProfile(updated);
      }
    } finally {
      isUploadingImage.value = false;
    }
  }
}
