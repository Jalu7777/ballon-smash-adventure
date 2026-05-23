import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/firebase/firebase_guard.dart';

class AuthRepository {
  Stream<User?> authStateChanges() {
    if (!isFirebaseReady) {
      return Stream<User?>.value(null);
    }
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    final account = await GoogleSignIn.instance.authenticate();
    final auth = account.authentication;
    final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (!isFirebaseReady) {
      return;
    }
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
