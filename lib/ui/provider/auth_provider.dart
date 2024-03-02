// ignore_for_file: constant_identifier_names
import 'package:chatt/ui/services/navigation_services.dart';
import 'package:chatt/ui/services/snackBar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNOtFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  late User? user;
  late AuthStatus status;
  late FirebaseAuth _auth;
  static AuthProvider instance = AuthProvider();
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    status =
        user != null ? AuthStatus.Authenticated : AuthStatus.NotAuthenticated;
  }

  Future<void> loginWithE_P(String _Email, String _Password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _Email, password: _Password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      snackBarService.instance
          .LoginStatusMessage("Welcome ${user?.email}", Colors.green);
      //print('success login');
      navigationService.instance.navigatorRepalacement('home');
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      snackBarService.instance.LoginStatusMessage("Login Error", Colors.red);
      //print('faild login');
      //display Error
    }
    notifyListeners();
  }

  Future<void>? registerWithE_P(
      String _email, String _pass, Future<void> onSuccess(String _uId)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _pass);
      status = AuthStatus.Authenticated;
      user = _result.user;
      await onSuccess(user!.uid);
      snackBarService.instance.LoginStatusMessage(
          "successfully register as ${user?.email}", Colors.green);
      //update lastseen time
      //navigationService.instance.goBack();
      navigationService.instance.navigatorRepalacement('home');
    } catch (e) {
      //print(e);
      user = null;
      status = AuthStatus.Error;
      snackBarService.instance.LoginStatusMessage("Login Error", Colors.red);
    }
    notifyListeners();
  }
}
