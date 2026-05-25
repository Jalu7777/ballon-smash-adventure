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
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: CircleAvatar(
                radius: 54,
                backgroundImage:
                    profile.photoUrl == null ? null : NetworkImage(profile.photoUrl!),
                child: profile.photoUrl == null
                    ? const Icon(Icons.person, size: 46)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                profile.displayName,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
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
