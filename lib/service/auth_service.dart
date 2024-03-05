import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:setup/service/database_service.dart';

import '../helper/helper_function.dart';

class AuthService {
  final FirebaseAuth firebaseApp = FirebaseAuth.instance;

  // login
  Future loginWithEmailAndPassword(String email,String password) async {
    try {
      User user =  (await firebaseApp.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null) {
        return true;
      }
    } on FirebaseAuthException catch(e) {
      print("+++Login+++++${e.toString()}+++++++++++++++++++++++");
      return e.message;
    }
  }



  // register
  Future registerUserWithEmailAndPassword(String fullName,String email,String password) async {
    try {
      User user =  (await firebaseApp.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null) {
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch(e) {
      print("++++++++${e.toString()}+++++++++++++++++++++++");
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseApp.signOut();
    } catch(e) {
      return null;
    }
  }
}