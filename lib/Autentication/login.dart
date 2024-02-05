import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Loading.dart';
import 'package:mercuri/Wrapper.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  const Login({required this.toggleView, super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool showPass = false;

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

//Text field state
  String email = "";
  String password = "";
  String error = "";

  bool signIn = true;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    Color fontColor = theme.isDarkMode ? Colors.white : Colors.black;
    return loading
        ? const Loading()
        : Form(
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
                          style:
                              GoogleFonts.eczar(fontSize: 35, color: fontColor),
                        ),
                      ],
                    )),
                // Image(
                //     image: AssetImage('images/Denario Logo.png'),
                //     height: 175)),

                ///Email input
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: fontColor, fontSize: 14),
                  validator: (val) =>
                      val!.isEmpty ? "Enter a valid email" : null,
                  cursorColor: Colors.grey,
                  focusNode: _emailNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: const Text('email'),
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    errorStyle: TextStyle(
                        color: theme.isDarkMode
                            ? Colors.grey
                            : Colors.redAccent[700],
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
                      ? "Password must be at least 6 characters long"
                      : null,
                  cursorColor: Colors.grey,
                  focusNode: _passwordNode,
                  decoration: InputDecoration(
                    label: const Text('password'),
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 12),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        icon: (showPass)
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
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    errorStyle: TextStyle(
                        color: theme.isDarkMode
                            ? Colors.grey
                            : Colors.redAccent[700],
                        fontSize: 12),
                  ),
                  obscureText: (showPass) ? false : true,
                  onFieldSubmitted: (val) async {
                    if (_formKey.currentState!.validate()) {
                      //Loading
                      setState(() => loading = true);

                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Wrapper())));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          setState(() {
                            error =
                                'No encontramos el usuario $email. Revisa de nuevo';
                            loading = false;
                          });
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            error = 'Contraseña incorrecta, intenta de nuevo';
                            loading = false;
                          });
                        } else {
                          setState(() {
                            error = 'Oops.. Algo salió mal';
                            loading = false;
                          });
                        }
                      } catch (e) {
                        setState(() {
                          error = 'Oops.. Algo salió mal';
                          loading = false;
                        });
                        // return null
                      }
                    }
                  },
                  onChanged: (val) {
                    setState(() => password = val);
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.grey.shade800;
                        }
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed)) {
                          return Colors.grey.shade500;
                        }
                        return Colors
                            .grey.shade500; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    print(FirebaseAuth.instance.currentUser);
                    if (_formKey.currentState!.validate()) {
                      //Loading
                      setState(() => loading = true);

                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Wrapper())));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          setState(() {
                            error =
                                'No encontramos el usuario $email. Revisa de nuevo';
                            loading = false;
                          });
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            error = 'Contraseña incorrecta, intenta de nuevo';
                            loading = false;
                          });
                        } else {
                          setState(() {
                            error = 'Oops.. Algo salió mal';
                            loading = false;
                          });
                        }
                      } catch (e) {
                        setState(() {
                          error = 'Oops.. Algo salió mal';
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
                      "Login",
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
                  style:
                      TextStyle(color: Colors.redAccent[700], fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
                //Register Instead
                const SizedBox(height: 5.0),
                TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Text('No account? Register',
                        style: TextStyle(color: fontColor, fontSize: 12)))
              ],
            ),
          );
  }
}
