import 'package:flutter/material.dart';
import 'package:mercuri/Autentication/login.dart';
import 'package:mercuri/Autentication/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Center(
              child: (showSignIn)
                  ? Login(toggleView: toggleView)
                  : Register(toggleView: toggleView),
            ),
          )),
    );
  }
}
