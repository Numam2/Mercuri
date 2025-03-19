import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mercuri/Autentication/authenticate.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/home.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _auth.userChanges().listen((User? event) {
      if (event != null) {
        setState(() {
          user = event;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.userChanges(), // Listen to the authentication status
      builder: (context, AsyncSnapshot? snapshot) {
        if (loading || snapshot == null) {
          return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Loading())); // Show loading widget
        }

        final currentUser = snapshot.data;
        if (currentUser == null) {
          return const Authenticate(); // User is not logged in
        }

        return MultiProvider(providers: [
          StreamProvider<UserData?>.value(
            value: DatabaseService().userData(currentUser.uid),
            initialData: null,
          ),
        ], child: Home(currentUser.uid));

        // if (currentUser.displayName == null || currentUser.displayName == '') {
        //   return StreamProvider<UserData?>.value(
        //     initialData: null,
        //     value: DatabaseService().userProfile(currentUser.uid),
        //     child: Onboarding(),
        //   );
        // } else {
        // return StreamProvider<UserData?>.value(
        //   initialData: null,
        //   value: DatabaseService().userProfile(currentUser.uid),
        //   child: Home(),
        // );
        // }
      },
    );
  }
}
