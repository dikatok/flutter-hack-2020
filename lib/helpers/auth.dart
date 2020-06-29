import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> signIn() async {
  final FirebaseUser user = (await _auth.signInAnonymously()).user;
  return user;
}

Future<void> signOut() async {
  _auth.signOut();
}

Future<FirebaseUser> getCurrentUser() async {
  return _auth.currentUser();
}
