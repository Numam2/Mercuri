import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Backend/auth_service.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({required this.toggleView, super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _repeatPasswordNode = FocusNode();

  //Text field state
  String email = "";
  String password = "";
  String repeatPassword = "";
  String error = "";
  bool loading = false;

  bool showPass1 = false;
  bool showPass2 = false;

  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    Color fontColor = theme.isDarkMode ? Colors.white : Colors.black;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ////// Logo
          SizedBox(
              height: 175,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mercuri',
                    style: GoogleFonts.eczar(fontSize: 35, color: fontColor),
                  ),
                ],
              )),
          // Image(
          //     image: AssetImage('images/Denario Logo.png'), height: 175)),

          ///Email input
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: fontColor, fontSize: 14),
            validator: (val) =>
                !(emailValid.hasMatch(val!)) ? "Add a valid email" : null,
            cursorColor: Colors.grey,
            focusNode: _emailNode,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: const Text('email'),
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
              errorStyle: TextStyle(
                  color: theme.isDarkMode ? Colors.grey : Colors.redAccent[700],
                  fontSize: 12),
            ),
            onFieldSubmitted: (term) {
              _emailNode.unfocus();
              FocusScope.of(context).requestFocus(_passwordNode);
            },
            onChanged: (val) {
              setState(() => email = val);
            },
          ),

          ///Password input
          const SizedBox(height: 25),
          TextFormField(
            style: TextStyle(color: fontColor, fontSize: 14),
            validator: (val) => val!.length < 6
                ? "Password must have at least 6 characters"
                : null,
            cursorColor: Colors.grey,
            focusNode: _passwordNode,
            decoration: InputDecoration(
              label: const Text('password'),
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPass1 = !showPass1;
                    });
                  },
                  icon: (showPass1)
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          size: 18,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                          size: 18,
                        )),
              errorStyle: TextStyle(
                  color: theme.isDarkMode ? Colors.grey : Colors.redAccent[700],
                  fontSize: 12),
            ),
            obscureText: (showPass1) ? false : true,
            onChanged: (val) {
              setState(() => password = val);
            },
          ),

          ///Repeat Password input
          const SizedBox(height: 25),
          TextFormField(
            style: TextStyle(color: fontColor, fontSize: 14),
            validator: (val) =>
                (val != password) ? "Passwords do not match" : null,
            cursorColor: Colors.grey,
            focusNode: _repeatPasswordNode,
            decoration: InputDecoration(
              label: const Text('re-enter password'),
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPass2 = !showPass2;
                    });
                  },
                  icon: (showPass2)
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          size: 18,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                          size: 18,
                        )),
              errorStyle: TextStyle(
                  color: theme.isDarkMode ? Colors.grey : Colors.redAccent[700],
                  fontSize: 12),
            ),
            obscureText: (showPass2) ? false : true,
            onChanged: (val) {
              setState(() => repeatPassword = val);
            },
            onFieldSubmitted: (val) {
              //Loading
              setState(() => loading = true);
              if (_formKey.currentState!.validate()) {
                //Loading
                setState(() => loading = true);

                try {
                  AuthService().registerWithEmailAndPassword(email, password);
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    error = 'Oops.. Algo salió mal. $e';
                    loading = false;
                  });
                  // return null
                }
              }
            },
          ),

          ///Button Register
          const SizedBox(height: 50),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              )),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.grey.shade800;
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return Colors.grey.shade500;
                  }
                  return Colors.grey.shade500; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () async {
              //Loading
              setState(() => loading = true);
              if (_formKey.currentState!.validate()) {
                //Loading
                setState(() => loading = true);

                try {
                  AuthService().registerWithEmailAndPassword(email, password);
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    error = 'Oops.. Algo salió mal. $e';
                    loading = false;
                  });
                  // return null
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: const Text(
                "register",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          //Show error if threr is an error signing in
          const SizedBox(height: 5.0),
          Text(
            error,
            style: TextStyle(color: Colors.redAccent[700], fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
          //SignIn Instead
          const SizedBox(height: 5.0),
          TextButton(
              onPressed: () {
                widget.toggleView();
              },
              child: Text('Or... login instead',
                  style: TextStyle(color: fontColor, fontSize: 12)))
        ],
      ),
    );
  }
}
