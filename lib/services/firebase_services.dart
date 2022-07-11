import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:AquaFocus/model/app_user.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/screens/signin_screen.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final _facebookSignIn = FacebookAuth.instance;
  var userEmail = "";
  bool profileImage = false;

  signInWithEmail(String email, String pwd) {
    return _auth.signInWithEmailAndPassword(email: email, password: pwd);
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        String googleEmail = googleSignInAccount.email;
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        final UserCredential authResult =
            await _auth.signInWithCredential(authCredential);

        if (authResult.additionalUserInfo!.isNewUser) {
          AppUser appUser = AppUser(email: googleEmail, userName: "default");
          DatabaseService().addUser(appUser, user!.uid);
        }
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await _facebookSignIn.login(
        permissions: ['email', 'public_profile'],
      );
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final userData = await _facebookSignIn.getUserData();

      final UserCredential authResult =
          await _auth.signInWithCredential(facebookAuthCredential);
      final facebookEmail = userData["email"];

      if (authResult.additionalUserInfo!.isNewUser) {
        AppUser appUser = AppUser(email: facebookEmail, userName: "default");
        DatabaseService().addUser(appUser, user!.uid);
      }

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  deleteAccount(BuildContext context) async {
    bool step1 = true;
    bool step2 = false;
    bool step3 = false;
    bool step4 = false;
    while (true) {
      if (step1) {
        //delete user info in the database
        await FirebaseFirestore.instance
            .collection('tasks')
            .where('userId', isEqualTo: _auth.currentUser!.uid)
            .get()
            .then((querySnapshot) => {querySnapshot.docs.forEach((element) {element.reference.delete();})});
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .delete();

        step1 = false;
        step2 = true;
      }

      if (step2) {
        //delete user
        _auth.currentUser!.delete();
        step2 = false;
        step3 = true;
      }

      if (step3) {
        await FirebaseAuth.instance.signOut();
        step3 = false;
        step4 = true;
      }

      if (step4) {
        //go to sign up log in page
        await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignInScreen()
            ));
        step4 = false;
      }

      if (!step1 && !step2 && !step3 && !step4) {
        break;
      }
    }
  }

    signOut() async {
      await _auth.signOut();
      await _facebookSignIn.logOut();
      await _googleSignIn.signOut();
    }

}
