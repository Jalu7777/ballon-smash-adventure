import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/cache/local_cache.dart';
import '../core/firebase/firebase_options.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/auth_repository.dart';
import '../features/leaderboard/leaderboard_controller.dart';
import '../features/leaderboard/leaderboard_repository.dart';
import '../features/profile/profile_controller.dart';
import '../features/profile/profile_repository.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  if (DefaultFirebaseOptions.isConfigured) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    debugPrint(
      'Firebase is not configured. Run flutterfire configure and update '
      'lib/core/firebase/firebase_options.dart.',
    );
  }

  await GoogleSignIn.instance.initialize();

  Get
    ..put(LocalCache(GetStorage()), permanent: true)
    ..put(AuthRepository(), permanent: true)
    ..put(ProfileRepository(), permanent: true)
    ..put(LeaderboardRepository(), permanent: true)
    ..put(AuthController(Get.find<AuthRepository>()), permanent: true)
    ..put(
      ProfileController(
        repository: Get.find<ProfileRepository>(),
        cache: Get.find<LocalCache>(),
      ),
      permanent: true,
    )
    ..put(
      LeaderboardController(
        repository: Get.find<LeaderboardRepository>(),
        cache: Get.find<LocalCache>(),
      ),
      permanent: true,
    );
}
