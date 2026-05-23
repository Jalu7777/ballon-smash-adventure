import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final profile = controller.profile.value;
        if (controller.isLoading.value && profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (profile == null) {
          return const Center(child: Text('Profile unavailable'));
        }
        final nameController = TextEditingController(text: profile.displayName);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundImage:
                        profile.photoUrl == null ? null : NetworkImage(profile.photoUrl!),
                    child: profile.photoUrl == null
                        ? const Icon(Icons.person, size: 46)
                        : null,
                  ),
                  IconButton.filled(
                    tooltip: 'Upload image',
                    onPressed: controller.isUploadingImage.value
                        ? null
                        : controller.pickAndUploadProfileImage,
                    icon: controller.isUploadingImage.value
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Display name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: controller.updateDisplayName,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => controller.updateDisplayName(nameController.text),
              icon: const Icon(Icons.save),
              label: const Text('Save profile'),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.mail),
              title: const Text('Email'),
              subtitle: Text(profile.email ?? 'Not provided'),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Best score'),
              subtitle: Text('${profile.bestScore}'),
            ),
            ListTile(
              leading: const Icon(Icons.sports_score),
              title: const Text('Games played'),
              subtitle: Text('${profile.gamesPlayed}'),
            ),
          ],
        );
      }),
    );
  }
}
