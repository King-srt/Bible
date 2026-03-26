import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    final user = credential.user;
    if (user == null) {
      throw Exception('Anonymous sign-in did not return a user.');
    }
    return user;
  }

  Future<User> ensureSignedIn() async {
    final existingUser = currentUser;
    if (existingUser != null) {
      return existingUser;
    }
    return signInAnonymously();
  }

  Future<void> signOut() => _auth.signOut();
}
