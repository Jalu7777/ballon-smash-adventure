import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import 'theme.dart';

class BalloonSmashAdventureApp extends StatelessWidget {
  const BalloonSmashAdventureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Balloon Smash Adventure',
      theme: buildAppTheme(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends GetView<AuthController> {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInitializing.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return controller.user.value == null
          ? const LoginScreen()
          : const HomeScreen();
    });
  }
}
