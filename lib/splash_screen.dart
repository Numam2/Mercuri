import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mercuri/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: const Center(
            child: SizedBox(height: 200, child: Text('Mercuri')
                // Image(
                //   image: AssetImage('images/Denario Logo.png'),
                //   fit: BoxFit.fitHeight,
                // ),
                )),
      ),
    );
  }
}
