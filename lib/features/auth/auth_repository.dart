import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/app_config.dart';
import '../../core/firebase/firebase_guard.dart';

class AuthRepository {
  AuthRepository()
      : _googleSignIn = GoogleSignIn(
          scopes: const ['email', 'profile'],
          serverClientId: AppConfig.googleServerClientId,
        );

  final GoogleSignIn _googleSignIn;

  Stream<User?> authStateChanges() {
    if (!isFirebaseReady) {
      return Stream<User?>.value(null);
    }
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-cancelled',
        message: 'Google sign-in was cancelled.',
      );
    }
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (!isFirebaseReady) {
      return;
    }
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
