import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../leaderboard/leaderboard_controller.dart';
import '../profile/profile_controller.dart';
import 'balloon_smash_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BalloonSmashGame _game;
  int _score = 0;
  bool _isEnded = false;

  @override
  void initState() {
    super.initState();
    _game = _buildGame();
  }

  BalloonSmashGame _buildGame() {
    return BalloonSmashGame(
      onScoreChanged: (score) {
        if (mounted) {
          setState(() => _score = score);
        }
      },
      onGameEnded: (score) async {
        if (!mounted) {
          return;
        }
        setState(() {
          _score = score;
          _isEnded = true;
        });
        await Get.find<ProfileController>().recordGameScore(score);
        await Get.find<LeaderboardController>().refreshLeaderboard();
      },
    );
  }

  void _restart() {
    setState(() {
      _score = 0;
      _isEnded = false;
      _game = _buildGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: _game)),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton.filledTonal(
                  tooltip: 'Close',
                  onPressed: () => Get.back<void>(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
          if (_isEnded)
            ColoredBox(
              color: Colors.black.withValues(alpha: 0.38),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Round complete', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text('Score $_score', style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _restart,
                          icon: const Icon(Icons.replay),
                          label: const Text('Play again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
