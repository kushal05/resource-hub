import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resourcehub/Pages/Skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Globals.dart';

class GoogleAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Google SignIn function
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    userName = authResult.additionalUserInfo.profile['name'];

    print("Profile details: ${authResult.additionalUserInfo.profile}");

    return 'signInWithGoogle succeeded: $user';
  }

  //Google Signout Function
  void signOutGoogle() async{
    await googleSignIn.signOut();
    print("User Sign Out");
  }
}

enum LoginType {
  System, Google
}

class Auth {
  GoogleAuth _googleAuth = GoogleAuth();

  LoginType loginType;
  String username;
  String password;
  BuildContext context;

  void login(){
    if(this.loginType == LoginType.System){
      print("You chose System login ");
      print("System Username is: ${this.username} Password is: ${this.password}");
    }
    if(this.loginType == LoginType.Google){
      _googleAuth.signInWithGoogle().then((dynamic) async {
        SharedPreferences pref =
        await SharedPreferences.getInstance();
        pref.setString('userName', userName).then((value) {
          Navigator.of(this.context).push(
            MaterialPageRoute(
              builder: (context) {
                return Skeleton();
              },
            ),
          );
        });
      });
    } else {
      print("Else Username is: ${this.username} Password is: ${this.password}");
    }
  }
}

