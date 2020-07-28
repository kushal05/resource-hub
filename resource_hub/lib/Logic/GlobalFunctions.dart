import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resourcehub/Pages/ReusableWidgets.dart';
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

class LoginResult {
  bool error;
  String loginResultData;
}

class Auth {

  GoogleAuth _googleAuth = GoogleAuth();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginType loginType;
  String email;
  String password;
  BuildContext context;

  void login() async{
    if(this.loginType == LoginType.System){
      print("You chose System login ");
      print("System Username is: ${this.email} Password is: ${this.password}");
      LoginResult loginResult = await signIn(this.email, this.password);
      if(!loginResult.error) {
        String userId = loginResult.loginResultData;
        print("Got userId from signIn $userId");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('userName', userId).then((value) {
          Navigator.of(this.context).push(
            MaterialPageRoute(
              builder: (context) {
                return Skeleton();
              },
            ),
          );
        });
      } else {
        print('Login error brother: ${loginResult.loginResultData}');
        String errorTitle = 'Login failed';
        String errorContent = 'Error';
        if(loginResult.loginResultData == 'ERROR_USER_NOT_FOUND') {
          errorContent = 'Looks like there is no user registered with this username/password combination.';
        } else if (loginResult.loginResultData == 'ERROR_INVALID_EMAIL') {
          errorContent = 'Please make sure the email is in correct format.';
        }
        showDialog(
            context: this.context,
          builder: (BuildContext context)=> errorAlertDialog(errorTitle, errorContent, this.context)
        );
      }
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
    }
  }

  Future<dynamic> signIn(String email, String password) async {
    print("In signIn $email and $password");
    LoginResult _loginResult = LoginResult();
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password).catchError((err){
          print('Something went wrong, login error: ${err.code}');
          _loginResult.loginResultData = err.code;
          _loginResult.error = true;
          return null;
    });
    if(result == null) {
      return _loginResult;
    } else {
      FirebaseUser user = result.user;
      _loginResult.loginResultData = user.uid;
      _loginResult.error = false;
      return _loginResult;
//      return user.uid;
    }
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}


