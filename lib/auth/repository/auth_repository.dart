import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final DatabaseReference _database;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    DatabaseReference? database,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _database = database ?? FirebaseDatabase.instance.ref();

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create a user node in Realtime Database (optional, for profile)
      if (userCredential.user != null) {
        await _database.child('users/${userCredential.user!.uid}').set({
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
