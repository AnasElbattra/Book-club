import 'package:book_club/models/authModel.dart';
import 'package:book_club/models/userModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //
  // Future<String> signOut() async {
  //   String retVal = "error";
  //
  //   try {
  //     await _auth.signOut();
  //     retVal = "success";
  //   } catch (e) {
  //     print(e);
  //   }
  //   return retVal;
  // }

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error";
    try {
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      UserModel _user = UserModel(
        uid: _userCredential.user?.uid,
        email: _userCredential.user?.email,
        fullName: fullName.trim(),
        accountCreated: Timestamp.now(),
        notifToken: await _fcm.getToken(),
      );
      String _returnString = await DBFuture().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication? _googleAuth = await _googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth?.idToken, accessToken: _googleAuth?.accessToken);
     UserCredential _userCredential = await _auth.signInWithCredential(credential);
      if (_userCredential.additionalUserInfo?.isNewUser??true) {
        UserModel _user = UserModel(
          uid: _userCredential.user?.uid,
          email: _userCredential.user?.email,
          fullName: _userCredential.user?.displayName,
          accountCreated: Timestamp.now(),
          notifToken: await _fcm.getToken(),
        );
        String _returnString = await DBFuture().createUser(_user);
        if (_returnString == "success") {
          retVal = "success";
        }
      }
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message!;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
