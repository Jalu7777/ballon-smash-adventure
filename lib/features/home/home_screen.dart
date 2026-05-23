import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_controller.dart';
import '../game/game_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../profile/profile_controller.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    _DashboardTab(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_esports), label: 'Play'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Leaders'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adventure'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: authController.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: profileController.refreshProfile,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Obx(() {
                final profile = profileController.profile.value;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: profile?.photoUrl == null
                              ? null
                              : NetworkImage(profile!.photoUrl!),
                          child: profile?.photoUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.displayName ?? 'Player',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text('Best score ${profile?.bestScore ?? 0}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Get.to<void>(() => const GameScreen()),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play 45-second round'),
              ),
              const SizedBox(height: 16),
              const _StatsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Obx(() {
      final profile = controller.profile.value;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: MediaQuery.sizeOf(context).width > 520 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.7,
        children: [
          _StatCard(label: 'Best', value: '${profile?.bestScore ?? 0}'),
          _StatCard(label: 'Total', value: '${profile?.totalScore ?? 0}'),
          _StatCard(label: 'Games', value: '${profile?.gamesPlayed ?? 0}'),
        ],
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
