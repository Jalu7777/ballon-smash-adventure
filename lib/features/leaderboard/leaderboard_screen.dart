import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'leaderboard_controller.dart';

class LeaderboardScreen extends GetView<LeaderboardController> {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Obx(() {
        final entries = controller.entries;
        if (controller.isLoading.value && entries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = controller.errorMessage.value;
        if (error != null && entries.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshLeaderboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 140),
                Icon(
                  Icons.lock_outline,
                  size: 54,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        }
        if (entries.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshLeaderboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 160),
                Icon(Icons.leaderboard, size: 54),
                SizedBox(height: 12),
                Center(child: Text('No leaderboard scores yet')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshLeaderboard,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                tileColor: Colors.white,
                leading: CircleAvatar(
                  backgroundImage:
                      entry.photoUrl == null ? null : NetworkImage(entry.photoUrl!),
                  child: entry.photoUrl == null ? Text('${index + 1}') : null,
                ),
                title: Text(entry.displayName),
                subtitle: Text('Rank ${index + 1}'),
                trailing: Text(
                  '${entry.score}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
