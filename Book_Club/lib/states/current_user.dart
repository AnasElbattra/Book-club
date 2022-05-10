import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUser extends ChangeNotifier {
  String? _uid;
  String? _email;

  String? get uid => _uid;

  String? get email => _email;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signUpUser(String email, String password) async {
    bool retVal = false;
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) retVal = true;
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> loginInUser(String email, String password) async {
    bool retVal = false;
    try {
      UserCredential _userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (_userCredential.user != null) {
        retVal = true;
        _email = _userCredential.user?.email;
        _uid = _userCredential.user?.uid;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
