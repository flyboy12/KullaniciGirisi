import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_up/model/usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ServiceProvider extends ChangeNotifier {
  UserModel? _loggedInUser;
  UserModel get loggedInUser => _loggedInUser!;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  bool? _isGoogleAccount = false;
  bool get isGoogleAccount => _isGoogleAccount!;

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("users");

  Future changeGoogleAccount(bool b) async {
    _isGoogleAccount = b;
    notifyListeners();
  }

  addUserCloud(String userName, String imageUrl) async {
    User? _currentUser = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel(
        uid: _currentUser!.uid,
        email: _currentUser.email,
        imageUrl: imageUrl,
        userName: userName);
    await collectionRef.doc(_currentUser.uid).set(userModel.toMap());
  }

  Future<bool> isUserCloud() async {
    final _checkUser;
    User? _currentUser = FirebaseAuth.instance.currentUser;

    final _result =
        await collectionRef.where("uid", isEqualTo: _currentUser!.uid).get();
    if (_result.docs.isEmpty) {
      _checkUser = true;
    } else {
      _checkUser = false;
    }
    return _checkUser;
  }

  Future facebookLogin() async {
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      final userData = await FacebookAuth.instance.getUserData();

      await isUserCloud()
          ? await addUserCloud(
              userData['name'],
              userData['picture']['data']['url'],
            )
          : await getUserData();
    } on Exception catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future getUserData() async {
    User? _currentUser = FirebaseAuth.instance.currentUser;

    try {
      await collectionRef.doc(_currentUser!.uid).get().then((value) {
        _loggedInUser = UserModel.fromMap(value.data());
      });
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? _user = FirebaseAuth.instance.currentUser;
      await isUserCloud()
          ? await addUserCloud(_user!.displayName!, _user.photoURL!)
          : await getUserData();

      print(credential);
    } catch (e) {
      throw e.toString();
    }

    notifyListeners();
  }

  Future logout() async {
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }
}
