import 'package:firebase_auth/firebase_auth.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String name;

  //create user object based on firebase user
  AppUser _userFromFirebaseUser(User? user) {
    // ignore: unnecessary_null_comparison
    if (user != null) {
      return AppUser(uid: user.uid);
    } else {
      return AppUser(uid: '');
    }
  }

  //Get UID for Firestore collection calls
  Future<String?> getcurrentUID() async {
    return (_auth.currentUser)?.uid;
  }

  //Auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    //Search Name
    List<String> caseNameSearchList = [];
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      caseNameSearchList.add(temp);
    }
    //Search email
    List<String> caseemailSearchList = [];
    String temp2 = "";
    for (int i = 0; i < email.length; i++) {
      temp2 = temp2 + email[i];
      caseemailSearchList.add(temp2);
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await value.user!.updateDisplayName(name);
        await DatabaseService().createUser(value.user!.uid, name, email,
            caseNameSearchList, caseemailSearchList);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es muy débil');
      } else if (e.code == 'email-already-in-use') {
        print('El email ya existe para un usuario');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Update User Profile Data
  Future updateUserData(String displayName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      user?.updateDisplayName(displayName);
    } catch (e) {
      print(e);
    }
  }

  //Sing Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
