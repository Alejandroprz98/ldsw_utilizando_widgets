import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(
    String email,
    String password,
  ) async {

    final credential = await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'email': email,
        'role': 'user',
      });
    }

    return user;
  }

  Future<User?> login(
    String email,
    String password,
  ) async {

    final credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}