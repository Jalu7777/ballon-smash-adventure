import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'auth_repository.dart';

class AuthController extends GetxController {
  AuthController(this._repository);

  final AuthRepository _repository;
  final user = Rxn<User>();
  final isInitializing = true.obs;
  final isSigningIn = false.obs;
  final errorMessage = RxnString();
  StreamSubscription<User?>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.authStateChanges().listen((currentUser) {
      user.value = currentUser;
      isInitializing.value = false;
    });
  }

  Future<void> signInWithGoogle() async {
    isSigningIn.value = true;
    errorMessage.value = null;
    try {
      await _repository.signInWithGoogle();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> signOut() => _repository.signOut();

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
