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
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No se encontró un usuario con ese email';
      } else if (e.code == 'wrong-password') {
        return 'Contraseña incorrecta';
      }
      return 'Ocurrió un error ($e)';
    } catch (e) {
      return 'Ocurrió un error inesperado. Intentalo de nuevo';
    }
  }

  //Register with email and password
  Future<String?> registerWithEmailAndPassword(
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
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'La contraseña es muy débil';
      } else if (e.code == 'email-already-in-use') {
        return 'El email ya existe para un usuario';
      }
      return 'Ocurrió un error ($e)';
    } catch (e) {
      return 'Ocurrió un error inesperado. Intentalo de nuevo';
    }
  }

  //Update User Profile Data
  Future<String?> updateUserData(String displayName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      user?.updateDisplayName(displayName);
      return null;
    } catch (e) {
      return 'Ocurrió un error inesperado. Intentalo de nuevo';
    }
  }

  //Sing Out
  Future signOut() async {
    return await _auth.signOut();
  }
}
