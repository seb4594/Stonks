import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String get userId => _firebaseAuth.currentUser.uid;

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return authResult.user;
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Signed IN');
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      print('error');
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
