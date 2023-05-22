import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutor_me/utilities/utility.dart';

class Auth{
  final FirebaseAuth auth= FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<User?> get authDifference => auth.authStateChanges();
  User get user =>auth.currentUser!;

  Future <bool> loginGoogle(BuildContext context) async {
    bool state=false;
    try{
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
      final gCredential = GoogleAuthProvider.credential( 
        accessToken: gAuth?.accessToken,
        idToken: gAuth?.idToken,
      );
      UserCredential gUserCredential = await auth.signInWithCredential(gCredential);
      User? user = gUserCredential.user;
      
      if (user!=null) {
        if (gUserCredential.additionalUserInfo!.isNewUser) {
          await firestore.collection('users').doc(user.uid).set({
             'username':user.displayName,
             'uid':user.uid,
             'pfp':user.photoURL,
          } );
        }
        state=true;
      }
    }
    on FirebaseAuthException catch(e){
      displaySnackBar(context, e.message!);
      state=false;
    }
    return state;
  }
}